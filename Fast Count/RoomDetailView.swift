//
//  RoomDetailView.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 6/27/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit
import MobileCoreServices


class RoomDetailView: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var gallery: GalleryTableViewCell!
    
    var dataCells: [DataCellTableViewCell] = []
    
    var currentAudit : AuditModel!
	var currentLocation : LocationModel!
    //var currentImage : ImageModel!

    var RoomLocationLabel = String() //This string has the Room Location Name
    var CategoryLabel = String() // This string has the category Name
    var AuditNameLabel = String() // This string has the Audit Name

    var newMedia : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // the method below creates the title for the page
        navigationItem.title = "Audit Detailed Inputs"
        
        print("\n\nViewDidLoad load preparing to load!!!! \n\n")
        loadDataCells()
        print("\n\nViewDidLoad loaded correctly!!!! \n\n")
        
    }

	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    // **************** Label/TextField Widths ****************

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

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}


    // ***************************** Load Content for TableView ************************************

    func loadDataCells() {
        dataCells = []
        var labels = [UILabel]()

        for key in LocationModel.defaultKeys {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataCellTableViewCell
            cell.setupCell(key: key, parent: self, isDefaultKey: true)
            labels.append(cell.label)
            dataCells.append(cell)
        }

		for key in currentLocation.customKeys {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataCellTableViewCell
            cell.setupCell(key: key, parent: self, isDefaultKey: false)
            dataCells.append(cell)
            labels.append(cell.label)
        }

        self.updateWidthsForLabels(labels: labels)

        for dataCell in dataCells {
            if dataCell == dataCells.last {
                dataCell.nextField = nil
            } else {
                dataCell.nextField = dataCells[dataCells.index(of: dataCell)! + 1].dataTextField
            }
        }
    }

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return dataCells.count + 3
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		// DATA HEADER
		if indexPath.row == 0 {
			let cell = tableView.dequeueReusableCell(withIdentifier: "DataHeader") as! DataHeaderTableViewCell
			cell.headerLabel.text = CategoryLabel + ": " + RoomLocationLabel
            cell.parent = self
			return cell
		}

        // DATA CELLS
        if indexPath.row > 0 && indexPath.row <= dataCells.count {
            return dataCells[indexPath.row - 1]
        }

        // GALLERY HEADER
		if indexPath.row == LocationModel.defaultKeys.count + currentLocation.customKeys.count + 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GalleryHeader") as! GalleryHeaderTableViewCell
            cell.roomDetailView = self
			return cell
		}
		
		// IMAGE GALLERY
		gallery = tableView.dequeueReusableCell(withIdentifier: "Gallery") as! GalleryTableViewCell
		gallery.roomDetailView = self
		return gallery
        
	}
    
        
    
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		if typeOfCellAt(indexPath: indexPath) == "Gallery" {
			return 215
		} else {
			return 44
		}
	}
	
	func typeOfCellAt(indexPath: IndexPath) -> String {
		if indexPath.row == 0 {
			return "DataHeader"
		}
		
		if indexPath.row > 0 && indexPath.row <= LocationModel.defaultKeys.count + currentLocation.customKeys.count {
			return "DataCell"
		}
		
		if indexPath.row == LocationModel.defaultKeys.count + currentLocation.customKeys.count + 1 {
			return "GalleryHeader"
		}
		
		return "Gallery"
	}

    // *********************************** Camera Features *********************************************
    
       
    @IBAction func image1Tapped(_ sender: UITapGestureRecognizer) {
        if self.gallery.imageView1.image != nil {
            let imageViewTapped = sender.view as! UIImageView
            let newImageViewTapped = UIImageView(image: imageViewTapped.image)
            newImageViewTapped.frame = UIScreen.main.bounds
            newImageViewTapped.backgroundColor = .gray
            newImageViewTapped.contentMode = .redraw
            newImageViewTapped.isUserInteractionEnabled = true
            let exitTap = UITapGestureRecognizer(target: self, action: #selector(exitFullScreen))
            newImageViewTapped.addGestureRecognizer(exitTap)
            self.view.addSubview(newImageViewTapped)
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false

        }
    }
    @IBAction func image2Tapped(_ sender: UITapGestureRecognizer) {
        if self.gallery.imageView2.image != nil {
            let imageViewTapped = sender.view as! UIImageView
            let newImageViewTapped = UIImageView(image: imageViewTapped.image)
            newImageViewTapped.frame = UIScreen.main.bounds
            newImageViewTapped.backgroundColor = .lightGray
            newImageViewTapped.contentMode = .redraw
            newImageViewTapped.isUserInteractionEnabled = true
            let exitTap = UITapGestureRecognizer(target: self, action: #selector(exitFullScreen))
            newImageViewTapped.addGestureRecognizer(exitTap)
            self.view.addSubview(newImageViewTapped)
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
            
        }
    }
    @IBAction func image3Tapped(_ sender: UITapGestureRecognizer) {
        if self.gallery.imageView3.image != nil {
            let imageViewTapped = sender.view as! UIImageView
            let newImageViewTapped = UIImageView(image: imageViewTapped.image)
            newImageViewTapped.frame = UIScreen.main.bounds
            newImageViewTapped.backgroundColor = .lightGray
            newImageViewTapped.contentMode = .redraw
            newImageViewTapped.isUserInteractionEnabled = true
            let exitTap = UITapGestureRecognizer(target: self, action: #selector(exitFullScreen))
            newImageViewTapped.addGestureRecognizer(exitTap)
            self.view.addSubview(newImageViewTapped)
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    @IBAction func image4Tapped(_ sender: UITapGestureRecognizer) {
        if self.gallery.imageView4.image != nil {
            let imageViewTapped = sender.view as! UIImageView
            let newImageViewTapped = UIImageView(image: imageViewTapped.image)
            newImageViewTapped.frame = UIScreen.main.bounds
            newImageViewTapped.backgroundColor = .lightGray
            newImageViewTapped.contentMode = .redraw
            newImageViewTapped.isUserInteractionEnabled = true
            let exitTap = UITapGestureRecognizer(target: self, action: #selector(exitFullScreen))
            newImageViewTapped.addGestureRecognizer(exitTap)
            self.view.addSubview(newImageViewTapped)
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }
    }


    @objc func exitFullScreen(_ sender: UITapGestureRecognizer){
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    func enterFullScreen(_ sender: UITapGestureRecognizer) {
       
    }
   
    
	
    // the method below will calls methods for pulling up the camera when tapping on the camera icon
    func tappedCamera(){
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
    func tappedPhotoGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
            newMedia = false // This prevents existing images from being re-saved.
            print("\nExiting tappedPhotoGallery Function. \n")
        }
    }
	
    // The method below will tell the app to select the picture choosen from above whether it came
	// from photo gallery or camera
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        self.dismiss(animated: true, completion: nil)
        if mediaType.isEqual(to: kUTTypeImage as String){
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
			
            if self.gallery.imageView1.image == nil {
                print("\nEntered the first saving loop \n ")
				currentLocation.image1 = image
				self.gallery.imageView1.image = image
                self.gallery.imageView1.contentMode = .scaleAspectFit
				currentAudit.saveWithImages()
                
            } else if (self.gallery.imageView2.image == nil) {
                print("\nEntered the second saving loop \n ")
				currentLocation.image2 = image
				self.gallery.imageView2.image = image
                self.gallery.imageView2.contentMode = .scaleAspectFit
                currentAudit.saveWithImages()
            } else if (self.gallery.imageView3.image == nil){
                print("\nEntered the third saving loop \n ")
				currentLocation.image3 = image
				self.gallery.imageView3.image = image
                self.gallery.imageView3.contentMode = .scaleAspectFit
                currentAudit.saveWithImages()
            } else if (self.gallery.imageView4.image == nil) {
                print("\nEntered the fourth saving loop \n ")
				currentLocation.image4 = image
				self.gallery.imageView4.image = image
                self.gallery.imageView4.contentMode = .scaleAspectFit
                currentAudit.saveWithImages()
            }  else if (self.gallery.imageView1.image != nil) && (self.gallery.imageView2.image != nil) && (self.gallery.imageView3.image != nil) && (self.gallery.imageView4.image != nil) {
                /// Implementing Warning Message
                let picAlert = UIAlertController(title: "Error", message: "Image capacity has been reached. No more images can be displayed. Please contact your App Developer for further assistance.", preferredStyle: UIAlertControllerStyle.alert)
                
                picAlert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action: UIAlertAction!) in
                    print("Error logic is functioning properly")
                    
                }))
                self.present(picAlert, animated: true, completion: nil)
                /// End of Warning Message
            } 
 			
            // the method below saves a new picture taken by the camera to the photo gallery
            if (newMedia == true) {
                print("\nEntered this final loop \n")
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(RoomDetailView.image(image:didFinishSavingWithError:contextInfo:)), nil)
                newMedia = false
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code for video here
            }
        }
    }
    
    // the method below will run if there was an error while attempting to pull the camera or photo gallery up
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
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
    
    

    // *********************************** Custom Data *********************************************
    func addCustomData(key: String){
        currentLocation.data[key] = ""
        currentAudit.save()
        loadDataCells()
        tableView.reloadData()
    }

    func renameCustomDataKey(oldKey: String, newKey: String) {
        if let value = currentLocation.data[oldKey] {
            currentLocation.data[oldKey] = nil
            currentLocation.data[newKey] = value
        }
        
        currentAudit.save()
        loadDataCells()
        tableView.reloadData()
    }

    func removeCustomData(key: String){
        currentLocation.data[key] = nil
        currentAudit.save()
        loadDataCells()
        tableView.reloadData()
    }
}





