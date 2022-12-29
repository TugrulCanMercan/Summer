


import Foundation
import Combine

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
    case url(URLError?)
    
    static func convertError(error:Error)->NetworkError{
        
        switch error {
        
        case is URLError:
            return .url((error as? URLError))
            
        case is NetworkError:
            return error as! NetworkError
       
        default:
            return .generic(error)
        }
    }
}
public protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> URLSessionTask?
    
    func requestWithCombine(endpoint: Requestable) -> AnyPublisher<Data?,NetworkError>
}

public protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> URLSessionTask
}

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}
public final class DefaultNetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    public init(config: NetworkConfigurable,
                sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
                logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func request(request: URLRequest, completion: @escaping CompletionHandler) -> URLSessionTask {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: error)
                completion(.failure(error))
            } else {
                
                print( String(data: data!, encoding: .utf8)!)
                self.logger.log(responseData: data, response: response)
                
                completion(.success(data))
            }
        }
    
        
        logger.log(request: request)

        return sessionDataTask
    }
    
    private func requestWithCombine(request: URLRequest) -> AnyPublisher<Data?,NetworkError>{
        return URLSession.shared.dataTaskPublisher(for: request)
            
            .tryMap({ (data: Data, response: URLResponse) in
                            guard let response = response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode < 300 else{
                                
                                throw NetworkError.url(URLError(.badServerResponse))
                        }
                return data
            })
          
            .mapError({ error in
                NetworkError.convertError(error: error)
            })
            .eraseToAnyPublisher()
    }
    
    
    private func resolve(error: Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    public func requestWithCombine(endpoint: Requestable) -> AnyPublisher<Data?, NetworkError> {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return requestWithCombine(request: urlRequest)
        } catch  {
            return AnyPublisher(Fail(error: .urlGeneration))
            
        }
        
    }
    
    
    public func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> URLSessionTask? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
}


public class DefaultNetworkSessionManager: NetworkSessionManager {
    public init() {}
    public func request(_ request: URLRequest,
                        completion: @escaping CompletionHandler) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger

public final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() { }

    public func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }

    public func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }

    public func log(error: Error) {
        printIfDebug("\(error)")
    }
}

func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}

