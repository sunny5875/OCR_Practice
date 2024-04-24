//
//  OCRViewController.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/24/24.
//

import SwiftUI
import AVFoundation

struct OCRCameraRepresentable: UIViewControllerRepresentable {
    
    private var viewModel: CameraViewModel
    
    init(viewModel: CameraViewModel) {
        self.viewModel = viewModel
    }
    
    func makeUIViewController(context: Context) -> OCRViewController {
        let controller = OCRViewController(viewModel: viewModel)
        return controller
    }
    
    func updateUIViewController(_ cameraViewController: OCRViewController, context: Context) { }
}


final class OCRViewController: UIViewController {
    private var cornerLength: CGFloat = 32
    private var cornerLineWidth: CGFloat = 3
    
    var viewModel: CameraViewModel
    
    init(cornerLength: CGFloat = 32, cornerLineWidth: CGFloat = 3, viewModel: CameraViewModel) {
        self.cornerLength = cornerLength
        self.cornerLineWidth = cornerLineWidth
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private var focusZone: CGRect {
        let layerHeight = viewModel.cameraPreviewLayer?.bounds.height ?? 0
        return CGRect(x: 33,
                      y: (layerHeight / 2) - (180 / 2),
                      width: view.bounds.width - 66, 
                      height: 240
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.setFocuszone(focusZone)
    }
    
    func setup() {
        viewModel.setupCaptureSession()
        viewModel.setupDevice()
        viewModel.setupInputOutput()
        viewModel.startRunningCaptureSession()
        
        setupPreviewLayer()
        setFocusZoneCornerLayer()
    }
    
    
    func setupPreviewLayer() {
        self.viewModel.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: viewModel.captureSession)
        self.viewModel.cameraPreviewLayer?.videoGravity = .resizeAspectFill
        self.viewModel.cameraPreviewLayer?.frame = CGRect(x: 0,
                                                          y: 0,
                                                          width: view.frame.width,
                                                          height: view.frame.height)
        
        let focusRound = UIBezierPath(roundedRect: focusZone, cornerRadius: 30)
        let path = CGMutablePath()
        path.addRect(view.bounds)
        path.addPath(focusRound.cgPath)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        maskLayer.fillRule = .evenOdd
        maskLayer.cornerRadius = 30
        
        viewModel.cameraPreviewLayer?.addSublayer(maskLayer)
        
        self.view.layer.insertSublayer(viewModel.cameraPreviewLayer!, at: 0)
    }
    
    private func setFocusZoneCornerLayer() {
        var cornerRadius = viewModel.cameraPreviewLayer?.cornerRadius ?? CALayer().cornerRadius
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > focusZone.width / 2 { cornerLength = focusZone.width / 2 }
        
        let focuszonePath = UIBezierPath(roundedRect: focusZone, cornerRadius: 30)
        
        let combinedPath = CGMutablePath()
        combinedPath.addPath(focuszonePath.cgPath)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = combinedPath
        shapeLayer.strokeColor = UIColor.systemOrange.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = cornerLineWidth
        shapeLayer.lineCap = .square
        
        self.viewModel.cameraPreviewLayer?.addSublayer(shapeLayer)
    }
}

