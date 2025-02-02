//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Sreekutty Maya on 01/02/2025.
//

import SwiftUI
import Combine

class ImageDownloader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data:Data?,response:URLResponse?) -> UIImage? {
        let image = UIImage(data: data!)
        
        guard let response = response as? HTTPURLResponse, response.statusCode > 200 || response.statusCode < 299 else {
            return nil
        }
        return image
    }
    
    func downloadImage(completionHandler : @escaping (_ image: UIImage?,_ error:Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            let image = self.handleResponse(data: data, response: response)
            completionHandler(image,error)
           
        }.resume()
    }
    
    func downloadImageWithCombine() -> AnyPublisher<UIImage?,Error>{
        URLSession.shared.dataTaskPublisher(for: url)
                   .map(handleResponse)
                   .mapError({ $0 })
                   .eraseToAnyPublisher()
    }
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data,response)  = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
        
    }
    
}


class AsyncImageViewModel : ObservableObject {
    let downloader : ImageDownloader = ImageDownloader()
    @Published var image : UIImage? = nil
    var cancellables = Set<AnyCancellable>()
    func fetchImage() async {
        
//        downloader.downloadImage { image, error in
//            DispatchQueue.main.async {
//                self.image = image
//            }
//        }
        
//        downloader.downloadImageWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink { error in
//                print(error)
//            } receiveValue: { image in
//                self.image = image
//            }.store(in: &cancellables)
        do {
            let image = try await downloader.downloadWithAsync()
            await MainActor.run {
                self.image = image
            }
        } catch {
            
        }

    }
}

struct AsyncAwait: View {
    @ObservedObject var viewModel = AsyncImageViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 400, alignment: .center)
            }
        }.onAppear {
            Task {
                await viewModel.fetchImage()
            }
        }
    }
}

#Preview {
    AsyncAwait()
}
