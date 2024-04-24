//
//  OCRResultView.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/24/24.
//

import SwiftUI

struct OCRResultView: View {
    @StateObject var viewModel: CameraViewModel
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            Text("인식 결과")
                .font(.title2)
            Image(uiImage: viewModel.cropImage)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            
            Text(viewModel.ocrText)
            Spacer()
        }
    }
}

