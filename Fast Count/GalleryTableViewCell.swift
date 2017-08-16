//
//  GalleryTableViewCell.swift
//  Fast Count
//
//  Created by Jasper on 8/14/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

	var roomDetailView: RoomDetailView! {
		didSet {
			// Load images from KeyedArchiver
			
			if let image = roomDetailView.currentLocation.image1{
				imageView1.image = image
				imageView1.contentMode = .scaleAspectFit
				imageView1.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
			}
			
			if let image = roomDetailView.currentLocation.image2{
				imageView2.image = image
				imageView2.contentMode = .scaleAspectFit
				imageView2.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
				
			}
			
			if let image = roomDetailView.currentLocation.image3{
				imageView3.image = image
				imageView3.contentMode = .scaleAspectFit
				imageView3.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
			}
			
			if let image = roomDetailView.currentLocation.image4{
				imageView4.image = image
				imageView4.contentMode = .scaleAspectFit
				imageView4.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
			}
		}
	}
	
	@IBOutlet var galleryImageView: UIImageView!
	@IBOutlet var cameraImageView: UIImageView!
	
	@IBOutlet var imageTextField1: UITextField!
	@IBOutlet var imageTextField2: UITextField!
	@IBOutlet var imageTextField3: UITextField!
	@IBOutlet var imageTextField4: UITextField!
	
	@IBOutlet var imageView1: UIImageView!
	@IBOutlet var imageView2: UIImageView!
	@IBOutlet var imageView3: UIImageView!
	@IBOutlet var imageView4: UIImageView!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
//		let totalImageLabel = roomDetail + "." + CategoryLabel + "." + RoomLocationLabel
		let totalImageLabel = "ThisTextWillNotSave"
		let totalImageLabelTrim = String(totalImageLabel.characters.filter { !" \n\t\r".characters.contains($0) })
		imageTextField1.text = totalImageLabelTrim + ".1"
		imageTextField2.text = totalImageLabelTrim + ".2"
		imageTextField3.text = totalImageLabelTrim + ".3"
		imageTextField4.text = totalImageLabelTrim + ".4"
		
		// the method below will transform ios camera image into a button:
		let UICameraButton = UITapGestureRecognizer(target: roomDetailView, action: #selector(RoomDetailView.tappedCamera))
		UICameraButton.delegate = self
		cameraImageView.addGestureRecognizer(UICameraButton)
		cameraImageView.isUserInteractionEnabled = true
		
		// the method below will transform ios photo gallary image into a button:
		let UIGalleryButton = UITapGestureRecognizer(target: roomDetailView, action: #selector(RoomDetailView.tappedPhotoGallery))
		UIGalleryButton.delegate = self
		galleryImageView.addGestureRecognizer(UIGalleryButton)
		galleryImageView.isUserInteractionEnabled = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
}
