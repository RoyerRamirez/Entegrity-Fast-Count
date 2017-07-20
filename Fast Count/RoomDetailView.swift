//
//  RoomDetailView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit
import MobileCoreServices

class RoomDetailView: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    // Labels:
    @IBOutlet var labels: [UILabel]! //Photo Gallary Label
    @IBOutlet var label2: UILabel! // Header Label
    
    // Images that turn into Buttons:
    @IBOutlet var galleryImageView: UIImageView!
    @IBOutlet var cameraImageView: UIImageView!
    
    
    // Image Views:
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
   // var for every Text Field:
    @IBOutlet var servesTextField: AttributeTextField!
    @IBOutlet var idTextField: AttributeTextField!
    @IBOutlet var makeTextField: AttributeTextField!
    @IBOutlet var modelTextField: AttributeTextField!
    @IBOutlet var serialTextField: AttributeTextField!
    @IBOutlet var yearTextField: AttributeTextField!
    @IBOutlet var voltageTextField: AttributeTextField!
    @IBOutlet var phaseTextField: AttributeTextField!
    @IBOutlet var descriptionTextField: AttributeTextField!
    @IBOutlet var conditionTextField: AttributeTextField!
    @IBOutlet var auditorTextField: AttributeTextField!
    @IBOutlet var efficiencyTextField: AttributeTextField!
    @IBOutlet var notesTextField: AttributeTextField!
    @IBOutlet var imageTextField1: UITextField!
    @IBOutlet var imageTextField2: UITextField!
    @IBOutlet var imageTextField3: UITextField!
    
    // Other Variables
	var fieldArray : [AttributeTextField] {
		get {
			return [servesTextField, idTextField, makeTextField, modelTextField, serialTextField, yearTextField,
					voltageTextField, phaseTextField, descriptionTextField, conditionTextField, auditorTextField,
					efficiencyTextField, notesTextField]
		}
	}
    var currentLocation : LocationModel!
    var labelText3 = String() //This string has the Room Location Name
    var labelText4 = String() // This string has the category Name
    var auditorText3 = String() //This string has the auditor name
    //var imagePicker: UIImagePickerController!
    var newMedia : Bool?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // The method below will set up the table view
		servesTextField.delegate = self
		idTextField.delegate = self
		makeTextField.delegate = self
		modelTextField.delegate = self
		serialTextField.delegate = self
		yearTextField.delegate = self
		voltageTextField.delegate = self
		phaseTextField.delegate = self
		descriptionTextField.delegate = self
		conditionTextField.delegate = self
		auditorTextField.delegate = self
		efficiencyTextField.delegate = self
		notesTextField.delegate = self
        updateWidthsForLabels(labels: labels)
        
        //Giving each picture a unique name
        let totalImageLabel = labelText4 + "." + labelText3
        let totalImageLabelTrim = String(totalImageLabel.characters.filter { !" \n\t\r".characters.contains($0) })
        imageTextField1.text = totalImageLabelTrim + ".1"
        imageTextField2.text = totalImageLabelTrim + ".2"
        imageTextField3.text = totalImageLabelTrim + ".3"
		
		// Load currentLocation.data
		for field in fieldArray {
			field.text = (currentLocation.data[field.attributeKey] == nil ? "" : currentLocation.data[field.attributeKey]!)
		}
        
        // the method below will provide the text that was inputed when a new audit was created
        let totalLabel = labelText4 + ":  " + labelText3
        label2.text = totalLabel
        auditorTextField.text = auditorText3
        
        // the method below creates the title for the page
        navigationItem.title = "Audit Detailed Inputs"
        
        // the method below will transform ios camera image into a button:
        let UICameraButton = UITapGestureRecognizer(target: self, action: #selector(RoomDetailView.tappedCamera(_:)))
        UICameraButton.delegate = self
        cameraImageView.addGestureRecognizer(UICameraButton)
        cameraImageView.isUserInteractionEnabled = true

        
        // the method below will transform ios photo gallary image into a button:
        let UIGalleryButton = UITapGestureRecognizer(target: self, action: #selector(RoomDetailView.tappedPhotoGallery(_:)))
        UIGalleryButton.delegate = self
        galleryImageView.addGestureRecognizer(UIGalleryButton)
        galleryImageView.isUserInteractionEnabled = true
        
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // method below calculates the label width
    private func calculateLabelWidth(label: UILabel) -> CGFloat {
        let labelSize = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.height))
        return labelSize.width
    }
    
    // method below finds the max width of labels
    private func calculateMaxLabelWidth(labels: [UILabel]) -> CGFloat {
        //return reduce(map(labels, calculateLabelWidth), 0, max)
        return labels.map(calculateLabelWidth).reduce(0, max)
    }
    
    // method below adds Auto Layout constraints to constrain the labels
    private func updateWidthsForLabels(labels: [UILabel]) {
        let maxLabelWidth = calculateMaxLabelWidth(labels: labels)
        for label in labels {
            let constraint = NSLayoutConstraint(item: label,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: maxLabelWidth)
            label.addConstraint(constraint)
        }
    }
    
    // This method should loop through each text field (except auditor) then hide the keyboard (pressing enter key)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
			case servesTextField: idTextField.becomeFirstResponder() // passes each textField to next
			case idTextField: makeTextField.becomeFirstResponder()
			case makeTextField: modelTextField.becomeFirstResponder()
			case modelTextField: serialTextField.becomeFirstResponder()
			case serialTextField: yearTextField.becomeFirstResponder()
			case yearTextField: voltageTextField.becomeFirstResponder()
			case voltageTextField: phaseTextField.becomeFirstResponder()
			case phaseTextField: descriptionTextField.becomeFirstResponder()
			case descriptionTextField: conditionTextField.becomeFirstResponder()
			case conditionTextField: efficiencyTextField.becomeFirstResponder()
			case efficiencyTextField: notesTextField.becomeFirstResponder()
			default: efficiencyTextField.resignFirstResponder() //closes out the keyboard at the end
        }
        return true
    }
    
    // This method should autosave the text
	func textFieldDidEndEditing(_ textField: UITextField) {
		print("change")
		if let field = textField as? AttributeTextField {
			// Only need to update currentLocation for the attribute just edited.
			currentLocation.data[field.attributeKey] = (field.text == nil ? "" : field.text!)
			AuditModel.saveAuditsToUserDefaults()
		}
	}
	
 /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.indexPathForSelectedRow
        cell.selectionStyle = UITableViewCellSelectionStyle.none
    } */
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
    
// ************************************************ Camera Features ******************************************************************************
    // the method below will calls methods for pulling up the camera when tapping on the camera icon
    func tappedCamera(_ sender: UIImageView){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) { // checks to see if the camera is avaiable
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false // prevents black screen with a square frame to appear after taking pic
            self.present(imagePicker, animated: true, completion: nil) // presents picture after taking picture
            newMedia = true
        }
    }
    
    // The method below will open the Photo Library and bring the picture selected to a view controller
    func tappedPhotoGallery(_ sender: UIImageView) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = false
            
        }
    }
    
    // The method below will tell the app to select the picture choosen from above whether it came from photo gallery or camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        if mediaType.isEqual(to: kUTTypeImage as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView1.image = image
        
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(RoomDetailView.image(image:didFinishSavingWithError:contextInfo:)), nil)
                
            }
            else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code for video here
            }
        }
    }
    
    // the method below will run if there was an error while attempting to pull the camera or photo gallery up
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        if error != nil {
            let alert = UIAlertController(title: "Save Failed", message: "Failed to save image", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "OK",style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}





