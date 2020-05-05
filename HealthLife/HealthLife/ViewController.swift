//
//  ViewController.swift
//  HealthLife
//
//  Created by ZAVYALOV Yaroslav on 04.05.2020.
//  Copyright © 2020 ZYG. All rights reserved.
//

import UIKit
import Vision
import Photos

class ViewController: UIViewController {

  var image: UIImage?

  lazy var textDetectionRequest: VNRecognizeTextRequest = {
    let request = VNRecognizeTextRequest(completionHandler: self.handleDetectedText)
    request.recognitionLevel = .accurate
    request.recognitionLanguages = ["en"]
    return request
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    createUI()
  }
}

extension ViewController {
  private func createUI() {
    view.backgroundColor = .white

    let button = UIButton()
    button.setTitle("Get image", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

    view.addSubview(button)
    button.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      button.heightAnchor.constraint(equalToConstant: 44.0),
      button.leftAnchor.constraint(equalTo: view.leftAnchor),
      button.rightAnchor.constraint(equalTo: view.rightAnchor)
    ])
  }

  private func presentAlert(title: String, message: String) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    present(controller, animated: true, completion: nil)
  }

  private func handleDetectedText(request: VNRequest?, error: Error?) {
    if let error = error {
      presentAlert(title: "Error", message: error.localizedDescription)
      return
    }
    
    guard let results = request?.results, results.count > 0 else {
      presentAlert(title: "Error", message: "No text was found.")
      return
    }
    
//    var components = [CardComponent]()
    
    for result in results {
      if let observation = result as? VNRecognizedTextObservation {
        for text in observation.topCandidates(1) {
          print(text.string)
//            let component = CardComponent()
//            component.x = observation.boundingBox.origin.x
//            component.y = observation.boundingBox.origin.y
//            component.text = text.string
//            components.append(component)
        }
      }
    }
    
//    guard let firstComponent = components.first else { return }
    
//    var nameComponent = firstComponent
//    var numberComponent = firstComponent
//    var setComponent = firstComponent
//    for component in components {
//      if component.x < nameComponent.x && component.y > nameComponent.y {
//        nameComponent = component
//      }
//
//      if component.x < (numberComponent.x + 0.05) && component.y < numberComponent.y {
//        numberComponent = setComponent
//        setComponent = component
//      }
//    }
    
    DispatchQueue.main.async {
//      self.nameLabel.text = nameComponent.text
//      if numberComponent.text.count >= 3 {
//        self.numberLabel.text = "\(numberComponent.text.prefix(3))"
//      }
//      if setComponent.text.count >= 3 {
//        self.setLabel.text = "\(setComponent.text.prefix(3))"
//      }
    }
  }

  private func processImage() {
    guard let image = image, let cgImage = image.cgImage else { return }
      
    let requests = [textDetectionRequest]
    let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .right, options: [:])

    DispatchQueue.global(qos: .userInitiated).async {
      do {
        try imageRequestHandler.perform(requests)
      } catch let error {
        print("Error: \(error)")
      }
    }
  }
}

extension ViewController {
  @objc private func buttonAction() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = false
    imagePickerController.sourceType = .photoLibrary
    present(imagePickerController, animated: true, completion: nil)
  }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
    if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
      image = pickedImage
      processImage()
    }
    dismiss(animated: true, completion: nil)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
}

