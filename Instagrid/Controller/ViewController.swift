//
//  ViewController.swift
//  Instagrid
//
//  Created by Dusan Orescanin on 27/01/2022.
//

import UIKit

class ViewController: UIViewController {
    
    // SWIPE OUTLETS
    @IBOutlet private weak var swipeToShareStackView: UIStackView!
    @IBOutlet private weak var swipeLabel: UILabel!
    
    // FRAME IMAGEVIEW AND BUTTON
    @IBOutlet private weak var topLeftImageView: UIImageView!
    @IBOutlet private weak var topLeftButton: UIButton!
    @IBOutlet private weak var topRightImageView: UIImageView!
    @IBOutlet private weak var topRightButton: UIButton!
    @IBOutlet private weak var leftDownImageView: UIImageView!
    @IBOutlet private weak var leftDownButton: UIButton!
    @IBOutlet private weak var rightDownImageView: UIImageView!
    @IBOutlet private weak var rightDownButton: UIButton!
    
    // PHOTOFRAME VIEW
    @IBOutlet private weak var photoFrameView: UIView!
    
    // FRAME GRIDVIEWS & FRAME SELECTION BTN TABLE
    @IBOutlet private var gridViews: [UIView]!
    @IBOutlet private var frameSelectionButtons: [UIButton]!
    
    // VIEWWILLLAYOUTSUBVIEW IS CALLED AND - LANDSCAPE & PORTRAIT CHANGES
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe(gestureRecognizer:)))
        if UIApplication.shared.statusBarOrientation.isLandscape {
            // LANDSCAPE CHANGE
            swipeGesture.direction = .left
            self.swipeToShareStackView.addGestureRecognizer(swipeGesture)
            self.swipeLabel.text = "Swipe left to share"
        } else {
            // PORTRAIT CHANGE
            swipeGesture.direction = .up
            self.swipeToShareStackView.addGestureRecognizer(swipeGesture)
            self.swipeLabel.text = "Swipe up to share"
        }
    }
    
    // MARK: - SWIPE UP TO SHARE METHOD
    
    // METHOD INTERRACTION FOR SWIPE UP
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
    
    /// GET IMAGE FROM PHOTOFRAME AND SHARE IT WITH UIACTIVITYVIEWCONTROLLER
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

// MARK: - IMAGEPICKER PROTOCOL

// EXTENSION OF CLASS VIEWCONTROLLER CONFORM TO UINAVIGATIONCONTROLLDELEGATE PROTOCOL
extension ViewController: UINavigationControllerDelegate {}

// EXTENSION OF CLASS VIEWCONTROLLER TELLS WHEN USER SELECT A PIC / CANEL THE IMAGEPICKER
extension ViewController: UIImagePickerControllerDelegate {
    // PIC AN IMAGE & DISPLAY IN UIIMAGEVIEW METHOD
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

// EXTENSION OF CLASS VIEWCONTROLLER WITH IBACTION, ACTIONSHEET, FRAMESELECTION METHODS
private extension ViewController {
    // METHOD WHEN USER SELECT A FRAME
    @IBAction func chooseImage(_ sender: UIButton) {
        buttonTapped(button: sender)
        
        // CREATE IMAGEPICKER & PROVIDE IT A DELEGATE OF UIIMAGEPICKERCONTROLLER
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        // SET ACTIONSHEET WITH UIALERTCONTROLLER
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        // BONUS SOURCETYPE POSSIBILITY CHOOSE PIC FROM CAMERA (IF AVAILABLE)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }))
        }
        
        // CHOOSE A PIC FROM PHOTOLIBRARY
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }))
        
        // CANCEL ACTION
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
     
    // MARK: - SELECTION FRAME METHOD
    
    //  CHANGE THE FRAME METHOD
    //  CHANGE THE FRAME METHOD

    @IBAction private func frameSelection(_ sender: UIButton) {
        frameSelectionButtons.forEach {$0.isSelected = false} // UNSELECT
        sender.isSelected = true // SELECT THE BTN CHEK APPEARS
        
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
        photoFrameView.flashAnimation() // ANIMATE PHOTOFRAMEVIEW WHEN A NEW FRAME IS SELECTED
    }
    
    /// SELECT THE APPROPRIATE IMAGE VIEW TO PLACE THE PIC METHOD
    func buttonTapped(button: UIButton) {
        button.isSelected = true
    }
    
    /// DISPLAY THE PIC AND SET THE BTN TRANSPARENT METHOD
    func displayImage(image: UIImage, imageView: UIImageView, button: UIButton) {
        imageView.image = image
        button.alpha = 0.02
        button.isSelected = false
    }
}
