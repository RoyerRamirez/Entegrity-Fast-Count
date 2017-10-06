//
//  GalleryHeaderTableViewCell.swift
//  Fast Count
//
//  Created by Jasper on 8/15/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit

class GalleryHeaderTableViewCell: UITableViewCell {

    var roomDetailView: RoomDetailView!

	@IBAction func cameraTapped(_ sender: Any) {
        roomDetailView.tappedCamera()
	}

	
	@IBAction func rollTapped(_ sender: Any) {
        roomDetailView.tappedPhotoGallery()
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
