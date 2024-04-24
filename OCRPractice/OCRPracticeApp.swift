//
//  OCRPracticeApp.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/1/24.
//

import SwiftUI

@main
struct OCRPracticeApp: App {
    @StateObject private var viewModel = CameraViewModel()
    var body: some Scene {
        WindowGroup {
            OCRCameraView(viewModel: viewModel)
        }
    }
}
