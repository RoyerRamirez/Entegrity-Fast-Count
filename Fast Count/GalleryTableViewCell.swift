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
				//imageView1.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
			}
			
			if let image = roomDetailView.currentLocation.image2{
				imageView2.image = image
				imageView2.contentMode = .scaleAspectFit
				
			}
			
			if let image = roomDetailView.currentLocation.image3{
				imageView3.image = image
				imageView3.contentMode = .scaleAspectFit
			}
			
			if let image = roomDetailView.currentLocation.image4{
				imageView4.image = image
				imageView4.contentMode = .scaleAspectFit
			}
		}
	}
	
	@IBOutlet var imageView1: UIImageView!
	@IBOutlet var imageView2: UIImageView!
	@IBOutlet var imageView3: UIImageView!
	@IBOutlet var imageView4: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
}
