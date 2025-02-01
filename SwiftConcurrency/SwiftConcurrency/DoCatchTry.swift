//
//  DoCatchTry.swift
//  SwiftConcurrency
//
//  Created by Sreekutty Maya on 01/02/2025.
//

import SwiftUI

class Manager {
    let isActive = true
    
    func fetchText() -> (title :String?,error :Error?) {
        if isActive {
            return ("title",nil)
        } else {
            return (nil,URLError((.notConnectedToInternet)))
        }
    }
    
    func fetchText2() -> Result<String,Error> {
        if isActive {
            return .success("title")
        } else {
            return .failure(URLError((.notConnectedToInternet)))
        }
    }
    
    func fetchText3() throws -> String {
        if isActive {
            return "title"
        } else {
            throw URLError((.notConnectedToInternet))
        }
    }
    
    func fetchText4() throws -> String {
        if isActive {
            return "final text"
        } else {
            throw URLError((.notConnectedToInternet))
        }
    }

}

class TestViewModel : ObservableObject {
    let manager = Manager()
    @Published var text = "Hi.. There"
    
    
    func changeText() {
       /*
       let returnText = manager.fetchText()
        if let title = returnText.title {
            self.text = title
        } else if let error = returnText.error {
            self.text = error.localizedDescription
        }
     */
        
        /*
         let result = manager.fetchText2()
            switch result {
                case .success(let str):
                    self.text = str
                case .failure(let error):
                    self.text = error.localizedDescription
            }
        */
        do {
            let result1 = try manager.fetchText3()
            self.text = result1

            let result2 = try manager.fetchText4()
            self.text = result2

        } catch {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTry: View {
    @StateObject var viewModel = TestViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .background(.red)
            .onTapGesture {
                viewModel.changeText()
            }
    }
}

#Preview {
    DoCatchTry()
}
