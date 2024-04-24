//
//  ContentView.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/1/24.
//

import SwiftUI
import VisionKit

struct ContentView: View {
    @StateObject var scanner =  Scanner()
    @State var isTap = false
    
    var body: some View {
        ScrollView {
            VStack {
                Image("test_", bundle: .none)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                
                Button(action: {
                    scanner.recognizeText(image: UIImage(named: "test_")!)
                }, label: {
                    Text("문서 촬영하기")
                })
                
                Text(scanner.text)
            }
        }
    }
    
    
    
}

#Preview {
    ContentView()
}
