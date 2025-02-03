//
//  TaskGroup.swift
//  SwiftConcurrency
//
//  Created by Sreekutty Maya on 03/02/2025.
//

import SwiftUI

class TaskGroupManager  {
    func fetchImageWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = try fetchImage()
        async let fetchImage2 = try fetchImage()
        async let fetchImage3 = try fetchImage()
        async let fetchImage4 = try fetchImage()
        async let fetchImage5 = try fetchImage()
        async let fetchImage6 = try fetchImage()
        
        do {
            let(image1,image2,image3,image4,image5,image6) = await (try fetchImage1,try fetchImage2,try fetchImage3,try fetchImage4,try fetchImage5,try fetchImage6)
            return [image1,image2,image3,image4,image5,image6]}
        catch {
            throw error
        }
    }
    
    
    func fetchImageWithTaskGroup() async throws -> [UIImage] {
        let urls = [
            "https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200","https://picsum.photos/200"
        ]
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images : [UIImage] = []
            for url in urls {
                group.addTask {
                    try? await self.fetchImage(url: url)
                }
            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
            }
            return images
        }
    }
    
    func fetchImage(url : String = "https://picsum.photos/200") async throws -> UIImage {
        do {
            let (data,_) = try await URLSession.shared.data(from: URL(string: url)!)
            let image  = UIImage(data: data)!
            return image
        } catch {
            throw error
        }
    }
}

class TaskGroupViewModel : ObservableObject {
    @Published var images : [UIImage?] = []
    var manager : TaskGroupManager = TaskGroupManager()
   
    func fetchImages() async  {
        do {
            images = try await manager.fetchImageWithTaskGroup()
        } catch {
            print(error)
        }
    }

}
struct TaskGroup: View {
    var columns = [GridItem(.flexible()),GridItem(.flexible())]
   @ObservedObject var viewModel : TaskGroupViewModel = TaskGroupViewModel()
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 20) {
                ForEach(viewModel.images, id: \.self) {
                    image in
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                }
                
            }
        }.task {
              
            await viewModel.fetchImages()
            
        }
    }
    
    
}

#Preview {
    TaskGroup()
}
