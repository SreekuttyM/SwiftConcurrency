//
//  AsyncAwait.swift
//  SwiftConcurrency
//
//  Created by Sreekutty Maya on 02/02/2025.
//

import SwiftUI

class AsyncAwaitViewModel : ObservableObject {
    @Published var data : [String] = []
    
    func addItem() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.data.append("\(Thread.current)")
        }
        addItem2()
    }
    
    func addItem2() {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "\(Thread.current)"
            DispatchQueue.main.async {
                self.data.append(title)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        await MainActor.run {
            self.data.append(author1)
        }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run(body: {
            self.data.append(author2)
            
            let author3 = "Author3 : \(Thread.current)"
            self.data.append(author3)
        })
    }
}

struct AsyncAwait: View {
     @ObservedObject var viewModel = AsyncAwaitViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.data,id:\.self) { data in
                Text("\(data)")
            }
        }.onAppear() {
            Task {
              await  viewModel.addAuthor1()
            }
        }
    }
}

#Preview {
    AsyncAwait()
}
