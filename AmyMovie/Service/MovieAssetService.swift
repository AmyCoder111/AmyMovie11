//
//  MovieAssetService.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 4/24/21.
//

import Foundation
import UIKit

protocol MovieAssetServiceType {
    func fetchPosterImage(_ path: String?, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void)
}

final class MovieAssetService: MovieAssetServiceType {
    
    private let apiClient: APIClient = APIClient(baseURL: "https://image.tmdb.org/t/p/")
    private let imageQueue: DispatchQueue = DispatchQueue(label:"image_decoding", attributes: .concurrent)
    private var imageCache = NSCache<NSString, UIImage>()
    
    func fetchPosterImage(_ path: String?, completionHandler: @escaping (Result<UIImage, ServiceError>) -> Void) {
        guard let path = path else {
            completionHandler(.failure(.custom("Fail to get request path")))
            return
        }
        
        let imageKey = NSString(string: path)
        if let cachedImage = imageCache.object(forKey: imageKey) {
            completionHandler(.success(cachedImage))
            return
        }
        
        let task = apiClient.load(path: path, method: .get, params: [:]) { [weak self] result in
            switch result {
                case .success(let data):
                    if let imageData = data as? Data {
                        self?.imageQueue.async {
                            if let image = UIImage(data: imageData) {
                                self?.imageCache.setObject(image, forKey: imageKey)
                                DispatchQueue.main.async {
                                    completionHandler(.success(image))
                                }
                            }
                        }
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completionHandler(.failure(error))
                    }
            }
        }
        
        task?.resume()
    }
}
