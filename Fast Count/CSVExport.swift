//
//  CSVExport.swift
//  Fast Count
//
//  Created by Jasper on 8/14/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import UIKit
import SSZipArchive

class CSVExport: NSObject {
	class func exportCSV(audit: AuditModel) -> (data: Data?, imagesArchive: URL) {
		let csvStringValue = csvString(audit: audit)
		return (csvStringValue.string.data(using: .utf8, allowLossyConversion: false), csvStringValue.imagesArchive)
	}
	
	class func csvString(audit: AuditModel) -> (string: String, imagesArchive: URL) {
		var locations = [LocationModel]()
		var keys = ["Category", "Name"]
		var images = [(name: String, image: UIImage)]()
		
		// Consolidate all locations to a single array, make note of all keys used, and add all images
		for category in audit.categories {
			for location in category.locations {
				
				locations.append(location)
				
				for (key, _) in location.data {
					if !keys.contains(key) {
						keys.append(key)
					}
				}
				
				if let image = location.image1 {
					let name = "\(category.name)_\(location.name)_image1.png"
					images.append((name, image))
				}
				
				if let image = location.image2 {
					let name = "\(category.name)_\(location.name)_image2.png"
					images.append((name, image))
				}
				
				if let image = location.image3 {
					let name = "\(category.name)_\(location.name)_image3.png"
					images.append((name, image))
				}
				
				if let image = location.image4 {
					let name = "\(category.name)_\(location.name)_image4.jpg"
					images.append((name, image))
				}
			}
		}
		
		var string = ""
		
		for key in keys {
			string.append("\(key),")
			for location in locations {
				if key == "Category" {
					string.append("\(location.parentCategory!.name)")
				}else if key == "Name" {
					string.append("\(location.name)")
				} else {
					if let value = location.data[key] {
						string.append(value)
					}
				}
				
				if locations.last == location {
					string.append("\n")
				} else {
					string.append(",")
				}
			}
		}
		
		let zip = exportZip(images: images, auditName: audit.name)
		return (string, zip)
	}
	
	// Returns resulting zip file URL
	class func exportZip(images: [(name: String, image: UIImage)], auditName: String) -> URL {
		let docs = AuditFilesManager.getDocumentsDirectory()
		let tmpDir = docs.appendingPathComponent("tmp", isDirectory: true)
		let archivesDir = docs.appendingPathComponent("archives", isDirectory: true)
		let archiveFile = archivesDir.appendingPathComponent("\(auditName)_images.zip")
		
		let tmpPath = tmpDir.path
		
		// Create tmpDir if it doesn't exist
		if !FileManager.default.fileExists(atPath: tmpPath) {
			try! FileManager.default.createDirectory(atPath: tmpPath, withIntermediateDirectories: true, attributes: nil)
		}
		
		// Create archivesDir if it doesn't exist
		if !FileManager.default.fileExists(atPath: archivesDir.path) {
			try! FileManager.default.createDirectory(at: archivesDir, withIntermediateDirectories: true, attributes: nil)
		}
		
		// Save all images as JPG to tmpDir
		for (name, image) in images {
			// Tried to use PNG but even three images were too large to send over email
			try! UIImageJPEGRepresentation(image, 0.0)!.write(to: tmpDir.appendingPathComponent(name))
		}
		
		// Delete old archive if it exists
		if FileManager.default.fileExists(atPath: archiveFile.absoluteString) {
			try! FileManager.default.removeItem(at: archiveFile)
		}
		
		SSZipArchive.createZipFile(atPath: archiveFile.path, withContentsOfDirectory: tmpDir.path)
		
		// Delete tmpDir
		try! FileManager.default.removeItem(at: tmpDir)

		return archiveFile
	}
}
