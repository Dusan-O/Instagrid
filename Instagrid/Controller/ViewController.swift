//
//  ViewController.swift
//  Instagrid
//
//  Created by Dusan Orescanin on 07/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // swipe outlets
    @IBOutlet private weak var swipeToShareStackView: UIStackView!
    @IBOutlet private weak var swipeLabel: UILabel!
    // Frame ImageView and Button
    @IBOutlet private weak var topLeftImageView: UIImageView!
    @IBOutlet private weak var topLeftButton: UIButton!
    @IBOutlet private weak var topRightImageView: UIImageView!
    @IBOutlet private weak var topRightButton: UIButton!
    @IBOutlet private weak var leftDownImageView: UIImageView!
    @IBOutlet private weak var leftDownButton: UIButton!
    @IBOutlet private weak var rightDownImageView: UIImageView!
    @IBOutlet private weak var rightDownButton: UIButton!
    // photoFrame view
    @IBOutlet private weak var photoFrameView: UIView!
    // Frame gridViews and frame selection buttons table
    @IBOutlet private var gridViews: [UIView]!
    @IBOutlet private var frameSelectionButtons: [UIButton]!
    
    // When the view is about to change viewWillLayoutSubviews get called and activate landscape et portrait changes
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(gestureRecognizer:)))
        if UIApplication.shared.statusBarOrientation.isLandscape {
            // activate landscape changes
            swipeGesture.direction = .left
            self.swipeToShareStackView.addGestureRecognizer(swipeGesture)
            self.swipeLabel.text = "Swipe left to share"
        } else {
            // activate portrait changes
            swipeGesture.direction = .up
            self.swipeToShareStackView.addGestureRecognizer(swipeGesture)
            self.swipeLabel.text = "Swipe up to share"
        }
    }
    
    // MARK: - Swipe to share method
    
    // This method is use to interact with the swipe to share stack view with a gesture
    @objc
    private func swipe(gestureRecognizer: UISwipeGestureRecognizer) {
        if UIDevice.current.orientation.isPortrait {
            if gestureRecognizer.direction == .up {
                // Animate swipeToShareStackView & photoFrameView by moving it off screen view
                swipeToShareStackView.animateAndMove(x: 0, y: -self.view.frame.height)
                photoFrameView.animateAndMove(x: 0, y: -(self.view.frame.height+photoFrameView.frame.height)/2)
                shareImage()
            }
        } else if UIDevice.current.orientation.isLandscape {
            if gestureRecognizer.direction == .left { // swipe direction changed
                swipeToShareStackView.animateAndMove(x: -self.view.frame.width, y: 0)
                photoFrameView.animateAndMove(x: -(self.view.frame.width+photoFrameView.frame.width)/2, y: 0)
                shareImage()
            }
        }
    }
    
    /// Get the image from the photoFrameView and share it with an UIActivityViewController
    private func shareImage() {
        let renderer = UIGraphicsImageRenderer(size: self.photoFrameView.bounds.size)
        let imageToShare = renderer.image { ctx in
            self.photoFrameView.drawHierarchy(in: self.photoFrameView.bounds, afterScreenUpdates: true)
        }
        let shareActivity = UIActivityViewController(activityItems: [imageToShare], applicationActivities: nil)
        shareActivity.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            self.swipeToShareStackView.animateBack(x: -self.view.frame.height, y: 0, delay: 0.1)
            self.photoFrameView.animateBack(x: -(self.view.frame.height+self.photoFrameView.frame.height)/2, y: 0, delay: 0)
        }
        present(shareActivity, animated: true, completion: nil)
    }
}

// MARK: - ImagePicker Protocol

// extension of class ViewController comform to UINavigationControllerDelegate protocol
extension ViewController: UINavigationControllerDelegate {}

// extension of class ViewController tell us when the user either selected a picture or cancelled the imagePicker
extension ViewController: UIImagePickerControllerDelegate {
    // This method is use to pick the image and display in a UIImageView
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        if topLeftButton.isSelected {
            displayImage(image: image, imageView: topLeftImageView, button: topLeftButton)
        } else if topRightButton.isSelected {
            displayImage(image: image, imageView: topRightImageView, button: topRightButton)
        } else if rightDownButton.isSelected  {
            displayImage(image: image, imageView: rightDownImageView, button: rightDownButton)
        } else if leftDownButton.isSelected  {
            displayImage(image: image, imageView: leftDownImageView, button: leftDownButton)
        }
        picker.dismiss(animated: true, completion: nil)
        
    }
}

// Extension of ViewController with my IBAction, actionSheet and frameSelection method
private extension ViewController {
    // This method is use when user select a frame to place an image inside
    @IBAction func chooseImage(_ sender: UIButton) {
        buttonTapped(button: sender)
        
        // Create an imagePicker and provide it a delegate of UIImagePickerController
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // Set my actionSheet with UIAlertController
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        // BONUS SourceType Possibility to choose picture directly from a shoot with the camera (if available)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }))
        }
        
        // Choose a picture from phone photoLibrary
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        // Cancel Action
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Frame selection method
    
    //  This method is use to change frame when you tape on a button
    @IBAction private func frameSelection(_ sender: UIButton) {
        frameSelectionButtons.forEach {$0.isSelected = false} // Unselect all Buttons
        sender.isSelected = true // select the button tapped to make the Nike layer appeared on
        
        switch sender.tag {
        case 1:
            gridViews[1].isHidden = true
            gridViews[2].isHidden = false
        case 2:
            gridViews[1].isHidden = false
            gridViews[2].isHidden = true
        case 3:
            gridViews[1].isHidden = false
            gridViews[2].isHidden = false
        default:
            break;
        }
        photoFrameView.flashAnimation() // Animate the photoFrameView when select a new frame
    }
    
    /// This method is use to select the appropriate image view to place your picture
    func buttonTapped(button: UIButton) {
        button.isSelected = true
    }
    
    /// This method is use to display an image and set his button transperant
    func displayImage(image: UIImage, imageView: UIImageView, button: UIButton) {
        imageView.image = image
        button.alpha = 0.02
        button.isSelected = false
    }
}
