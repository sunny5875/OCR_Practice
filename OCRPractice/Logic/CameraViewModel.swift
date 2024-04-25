//
//  CameraView.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/24/24.
//

import SwiftUI
import AVFoundation
import VisionKit

class CameraViewModel: NSObject, ObservableObject {
    
    @Published var isDone = false
    @Published var ocrText = ""
    @Published var cropImage = UIImage()
    @Published var stringValue: String = ""
    @Published var isFlashOn = false
    @Published var isSilentModeOn = false
    
    var focusZone: CGRect = .zero
    
    // 실시간 캡처 활동을 관리하고, 입력 장치의 데이터 흐름을 조정하여 출력을 캡처하는 Object
    var captureSession = AVCaptureSession()
    
    // Capture Session에 대한 입력 및 하드웨어별 캡처 기능에 대한 제어를 제공
    var currentCamera: AVCaptureDevice?
    
    // 캡처된 결과물
    var photoOutput: AVCapturePhotoOutput?
    
    // 캡처된 비디오를 표시하는 Core Animation Layer
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    // OCR
    var scanner =  Scanner()
    
    
    // 출력의 품질 설정
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.high
    }
    
    
    // 후면 카메라 설정
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera],
            mediaType: AVMediaType.video,
            position: AVCaptureDevice.Position.back)
        self.currentCamera = deviceDiscoverySession.devices.find(\.position, value: .back)
    }
    
    // captureSession에 Input과 Output 설정
    func setupInputOutput() {
        do {
            guard let currentCamera 
            else { return }
            
            // MARK: - Input 설정
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera)
            captureSession.addInput(captureDeviceInput)
            let output = AVCapturePhotoOutput()
            photoOutput = output
            captureSession.addOutput(output)
            
        } catch {
            print(error)
        }
    }
    
    func setFocuszone(_ rect: CGRect) {
        self.focusZone = rect
    }
    func startRunningCaptureSession() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.captureSession.startRunning()
        }
    }
    
    func capturePhoto() {
        let photoSettings = AVCapturePhotoSettings()
        print("[Camera]: Photo's taken")
        self.photoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }

}


extension CameraViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, willBeginCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, willCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData)
        else { return }

        let cropData: UIImage = cropToPreviewLayer(
            from: image,
            toSizeOf: self.focusZone
        ) ?? image
        
        self.cropImage = cropData
        scanner.recognizeText(image: cropData) {
            self.ocrText = $0
            self.isDone = true
            print("[CameraModel]: Capture routine's done \(self.ocrText)")
        }
    }
    
    private func cropToPreviewLayer(from originalImage: UIImage, toSizeOf rect: CGRect) -> UIImage? {
        guard let cgImage = originalImage.cgImage ,
              let outputRect = cameraPreviewLayer?.metadataOutputRectConverted(fromLayerRect: rect)
        else { return nil }
       
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)

        let cropRect = CGRect(x: (outputRect.origin.x * width), y: (outputRect.origin.y * height), width: (outputRect.size.width * width), height: (outputRect.size.height * height))

        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
        }

        return nil
    }
}
