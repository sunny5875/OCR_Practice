//
//  Scanner.swift
//  OCRPractice
//
//  Created by 현수빈 on 4/1/24.
//

import Foundation
import VisionKit
import Vision

class Scanner: NSObject, ObservableObject {
    @Published var text = ""
    @Published var image: UIImage = UIImage(named: "test")!
    
    override init() {
    }
    
    func recognizeText(image: UIImage?, completion: @escaping (String) -> ())  {
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")

            DispatchQueue.main.async {
                self?.text = text
                completion(text)
            }
        }
   
         let revision3 = VNRecognizeTextRequestRevision3
         request.revision = revision3
         request.recognitionLevel = .accurate
         request.recognitionLanguages = ["ko-KR", "en-US"]
         request.usesLanguageCorrection = true

         do {
             var possibleLanguages: Array<String> = []
             possibleLanguages = try request.supportedRecognitionLanguages()
         } catch {
             print("Error getting the supported languages.")
         }
    
        do{
            try handler.perform([request])
        } catch {
            text = "\(error)"
            print(error)
        }
    }
}
