//
//  Task.swift
//  SwiftConcurrency
//
//  Created by Sreekutty Maya on 02/02/2025.
//

import SwiftUI

class AsyncImageDownloadViewModel : ObservableObject {
   @Published var image1 : UIImage?
    @Published var image2 : UIImage?

    func downloadImage() async  {
//        try? await Task.sleep(nanoseconds: 5_000_000_000)

        do {
            let (data,_) = try await URLSession.shared.data(from: URL(string: "https://picsum.photos/200")!)
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image1 = image
            })
        } catch {
            print(error)
        }
        
    }
    
    func downloadImage2() async  {
        do {
            let (data,_) = try await URLSession.shared.data(from: URL(string: "https://picsum.photos/200")!)
            let image = UIImage(data: data)
            await MainActor.run(body: {
                self.image2 = image
            })
        } catch {
            print(error)
        }
        
    }
}

struct DeepDiveTask: View {
    @ObservedObject var viewModel : AsyncImageDownloadViewModel = AsyncImageDownloadViewModel()
        @State private var fetchImageTask: Task<(), Never>? = nil

    var body: some View {
        VStack(spacing:40) {
            if let image = viewModel.image1 {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .background(.red)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .background(.red)
            }
        }
        .task {
            await viewModel.downloadImage()
        }
//        .onDisappear() {
//            fetchImageTask?.cancel()
//        }
//        .onAppear() {
//            fetchImageTask = Task  {
//                await viewModel.downloadImage()
//            }
//            //            Task {
//            //                await viewModel.downloadImage2()
//            //            }
//        }
//                detached shouldn't be used in normal cases as it gets detached from parent, we might need to manually handles all cases refer doc
                
//                Task.detached {
//                    print("detached : \(Thread.current) : \(Task.currentPriority)")
//                    await viewModel.downloadImage()
//
//                }
//            }
            
            
//            
//            Task(priority: .high) {
//                //                try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("high : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("medium : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("low : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility : \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("background : \(Thread.current) : \(Task.currentPriority)")
//            }
//        }
    }
}

#Preview {
    DeepDiveTask()
}
