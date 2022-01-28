//
//  UIImagePickerController.swift
//  Instagrid
//
//  Created by Dusan Orescanin on 07/01/2022.
//
import UIKit

// extension of UIImagePickerController with help me to rotate my picker
extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
}
