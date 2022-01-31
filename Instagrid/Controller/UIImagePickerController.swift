//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by Dusan Orescanin on 27/01/2022.
//
import UIKit

// MARK: - EXTENSION UIImagePickerController

// EXTENSION UIIMAGEPICKER TO ROTATE THE PICKER
extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
}
