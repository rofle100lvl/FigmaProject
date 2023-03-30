//
//  ContentView.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 14/03/23.
//

import SwiftUI

final class ViewModel: ObservableObject {
    @Published var child: FView?
    
    public init() {
        var components = URLComponents(string: "https://api.figma.com/v1/files/zoc9T7J4TtX5u6UpQgO0Yi")
        let parameters: [String: String] = ["geometry": "paths"]
        components?.queryItems = parameters.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        var request = URLRequest(url: components!.url!)
        request.setValue("figd_y_ZoIwV59_-ZRTteSAt5xc6BgfzDgwKtZyqjsIQP", forHTTPHeaderField: "X-FIGMA-TOKEN")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let responseModel = try! jsonDecoder.decode(FigmaResponseDTO.self, from: data!)
            let document = FDocument(children: responseModel.document)
            DispatchQueue.main.async {
                self.child = document
            }
        }
        task.resume()
    }
    
    public func build(children: FView) -> UIView {
        let view = children.build()
        print(view.frame)
        return view
    }
}

struct FigmaRepresentedView: UIViewControllerRepresentable {
    let child: FView
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = child.build()
        let controller = ZViewController()
        controller.contentView = view
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        if let child = vm.child {
            FigmaRepresentedView(child: child)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
