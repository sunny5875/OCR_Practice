//
//  OCRCameraView.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/24/24.
//

import SwiftUI
import AVFoundation

struct OCRCameraView: View {
    @StateObject var viewModel: CameraViewModel
    
    var body: some View {
        ZStack {
            OCRCameraRepresentable(viewModel: viewModel)
                .ignoresSafeArea()
            VStack {
                VStack {
                    Text("사각형에 카드를 맞추면\nOCR로 text를 가져올 수 있습니다.")
                        .multilineTextAlignment(.center)
                    
                }
                .padding(.top, 64)
                
                Spacer()
                Button(action: {
                    viewModel.capturePhoto()
                }, label: {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                })
                .padding(.bottom, 64)
            }
            .foregroundStyle(Color.white)
           
        }
        .sheet(isPresented: $viewModel.isDone, onDismiss: {
            viewModel.isDone = false
        }, content: {
            OCRResultView(viewModel: viewModel)
        })
    }
}

