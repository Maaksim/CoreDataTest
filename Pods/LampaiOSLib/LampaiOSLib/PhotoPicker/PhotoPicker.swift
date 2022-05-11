//
//  UIViewBaseExtensions.swift
//  lampa_lib_ios
//
//  Created by Maksym Vitovych on 27/01/22.
//  Copyright © 2022 Lampa. All rights reserved.
//

import UIKit

public protocol PhotoPickerDelegate: AnyObject {
    func fileIsSelected(image: UIImage?)
}

open class PhotoPicker: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public weak var target: UIViewController?
    var selectedPhoto: UIImage?
    var imageView: UIImageView?
    let imagePicker = UIImagePickerController()

    public weak var delegate: PhotoPickerDelegate?
    public var dialogTitle: String = "File selection"
    public var dialogMessage: String = "Select the file of the proposed sources"
    public var photoActionTitle: String = "Gallery"
    public var cameraActionTitle: String = "Camera"
    public var cancelActionTitle: String = "Cancel"
    
    open func chosePhoto() {
        self.imagePicker.delegate = self

        let alert = UIAlertController(title: dialogTitle, message: dialogMessage, preferredStyle: .actionSheet)
        let photoAction = UIAlertAction(title: photoActionTitle, style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            
            self.startPhotoLib()
        }
        let cameraAction = UIAlertAction(title: cameraActionTitle, style: .default) { [weak self] _ in
            guard let `self` = self else { return }
            
            self.startCamera()
        }
        
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .cancel) { [weak self] _ in
            guard let _ = self else { return }
        }
        alert.addAction(photoAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        target?.present(alert, animated: true, completion: nil)
    }
    
    func startCamera() {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        target?.present(imagePicker, animated: true, completion: nil)
    }
    
    func startPhotoLib() {
        self.imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.mediaTypes = ["public.image"]
        target?.present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.target?.dismiss(animated: true, completion: {
                let stringInfo = self.convertFromUIImagePickerControllerInfoKeyDictionary(info)
                let image = stringInfo[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage
                self.delegate?.fileIsSelected(image: image)
            })
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        target?.dismiss(animated: true, completion: nil)
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    
    // Helper function inserted by Swift 4.2 migrator.
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
    }
}
