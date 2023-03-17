//
//  ContentView.swift
//  FigmaProject
//
//  Created by Roman Gorbenko on 14/03/23.
//

import SwiftUI
import Combine

public class ViewModel: ObservableObject {
    @Published public var response: ResponseFDTO? = nil
    @Published public var child: FView?
    public var store = Set<AnyCancellable>()
    
    public init() {
        let url = URL(string: "https://api.figma.com/v1/files/zoc9T7J4TtX5u6UpQgO0Yi")
        var request = URLRequest(url: url!)
        request.setValue("figd_y_ZoIwV59_-ZRTteSAt5xc6BgfzDgwKtZyqjsIQP", forHTTPHeaderField: "X-FIGMA-TOKEN")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            let responseModel = try! jsonDecoder.decode(ResponseFDTO.self, from: data!)
            self.response = responseModel
            let document = FDocument(children: self.response!.document)
            self.child = document
        }
        task.resume()
    }
    
    public func build(children: FView) -> UIView {
        let view = children.build()
        print(view.frame)
        return view
    }
}

struct MMM: UIViewRepresentable {
    let child: FView
    
    func makeUIView(context: Context) -> UIView {
        child.build()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

struct ContentView: View {
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        if let child = vm.child {
            MMM(child: child)
                .onAppear {
                    vm.build(children: child)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
