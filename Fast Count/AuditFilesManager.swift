//
//  AuditFileManager.swift
//  Fast Count
//
//  Created by Royer Ramirez Ruiz on 8/4/17.
//  Copyright © 2017 EntegrityEnergyPartners. All rights reserved.
//

import Foundation

class AuditFilesManager : FileManager {
    // check stored value with this to ensure file format is up to date
    static let CURRENT_VERSION = 1
    
    // The method below returns a URL of the documents directory.
    class func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		let documentsDirectory = paths[0]
		return documentsDirectory
    }
    
    // The method below returns a URL of the directory in which all the audits will be saved. This code
    // also creates the directory if it does not exist.
    class func getAuditsDirectory() -> URL {
        let url = getDocumentsDirectory().appendingPathComponent("audits", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.absoluteString, isDirectory: UnsafeMutablePointer<ObjCBool>(bitPattern: 1)) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    // Returns a URL of the directory in which all the images for the audits will be saved. This code
    // also creates the directory if it does not exist.
    class func getAuditImagesDirectory() -> URL {
        let url = getDocumentsDirectory().appendingPathComponent("auditImages", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.absoluteString, isDirectory: UnsafeMutablePointer<ObjCBool>(bitPattern: 1)) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    
    
    // AUDITS
    
    // The method below runs the actual code to take the audit from the file and turn it into an
    // instance of AuditModel. Takes a URL as an argument and returns an optional AuditModel. This
    // returns nil if loading the audit from the file fails. Generally you will not need to use this
    // method. Use the next one instead.
    class func loadAudit(url: URL) -> AuditModel? {
        NSKeyedUnarchiver.setClass(AuditModel.self, forClassName: "FastCountAudit")
        NSKeyedUnarchiver.setClass(CategoryModel.self, forClassName: "FastCountCategory")
        NSKeyedUnarchiver.setClass(LocationModel.self, forClassName: "FastCountLocation")
        //NSKeyedUnarchiver.setClass(ImageModel.self, forClassName: "FastCountImage")
        
        if let uid = AuditFilesManager.getUIDFromURL(url: url) {
            if let auditImages = AuditFilesManager.loadAuditImages(uid: uid) {
                AuditImagesModel.currentAuditImages = auditImages
            } else {
                AuditImagesModel.currentAuditImages = AuditImagesModel(uid: Int64(uid))
            }
        } else {
            return nil
        }
        
        let data = try? Data(contentsOf: url)
        if data != nil {
            let audit = NSKeyedUnarchiver.unarchiveObject(with: data!) as? AuditModel
            return audit
        }
        return nil
    }
    
    // The method below does the same thing as loadAudit(url: URL) but with a given audit UID. Assumes
    // the audit you want to load is in the audits directory. This is added for convenience so that the
    // URL does not have to be retrieved when saving.
    class func loadAudit(uid: Int) -> AuditModel? {
        let url = getAuditsDirectory().appendingPathComponent("audit_\(uid)")
        return loadAudit(url: url)
    }
    
    // The method below returns an array of every audit in the audits directory. First it loads all the
    // urls within the audits directory, then for each one of those, decodes them into AuditModel
    // instances, and adds them to the array. At the end the array is returned.
    class func listAudits() -> [AuditModel]{
        // List Children
        let childrenOp = try? FileManager.default.contentsOfDirectory(at: getAuditsDirectory(),
                                                                  includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsSubdirectoryDescendants)
        var loadedAudits = [AuditModel]()
    
        // Decode Children into instances of AuditModel
        if let children = childrenOp {
            for child in children {
                if let loadedAudit = loadAudit(url: child) {
                    loadedAudits.append(loadedAudit)
                }
            }
        }
        return loadedAudits
    }
    
    // The method below runs the code that turns the given instance of AuditModel into the format used
    // by NSKeyedArchiver to save the information. Returns true if the saving succeeded and false if
    // otherwise. Generally you will not need to use this method. Use the next one instead.
    class func saveAudit(audit: AuditModel, url: URL) -> Bool {
        print("This the audit url being saved: \(url)")
        NSKeyedArchiver.setClassName("FastCountAudit", for: AuditModel.self)
        NSKeyedArchiver.setClassName("FastCountCategory", for: CategoryModel.self)
        NSKeyedArchiver.setClassName("FastCountLocation", for: LocationModel.self)
        let auditsData = NSKeyedArchiver.archivedData(withRootObject: audit) as NSData
        return auditsData.write(to: url, atomically: true)
    }
    
    // The method below does the same thing as saveAudit(audit: AuditModel, url: URL) but, like
    // loadAudit(fileName: String), assumes that the audit you want to save is saved in the audit
    // directory. This is added for convenience so that the URL does not have to be retrieved when
    // saving.
    class func saveAudit(audit: AuditModel, uid: Int) -> Bool {
        print("Save audit number: \(audit.uid)")
        print("This was the name being saved: audit_\(uid)")
        return saveAudit(audit: audit, url: getAuditsDirectory().appendingPathComponent("audit_\(uid)", isDirectory: false))
    }
    
    // The method below deletes the audit at the given uid as well as its images
    class func deleteAudit(uid: Int) {
        print("This is the audit number: \(uid)")
        deleteFile(url: getAuditsDirectory().appendingPathComponent("audit_\(uid)", isDirectory: false))
        deleteAuditImages(uid: uid)
    }
    
    
    // AUDIT IMAGES
    
    class func loadAuditImages(url: URL) -> AuditImagesModel? {
        NSKeyedUnarchiver.setClass(AuditImagesModel.self, forClassName: "FastCountAuditImages")
        let data = try? Data(contentsOf: url)
        if data != nil {
            let auditImages = NSKeyedUnarchiver.unarchiveObject(with: data!) as? AuditImagesModel
            return auditImages
        }
        return nil
    }
    
    class func loadAuditImages(uid: Int) -> AuditImagesModel? {
        let url = getAuditImagesDirectory().appendingPathComponent("audit_\(uid)")
        return loadAuditImages(url: url)
    }
    
    class func saveAuditImages(auditImages: AuditImagesModel, url: URL) -> Bool {
        NSKeyedArchiver.setClassName("FastCountAuditImages", for: AuditImagesModel.self)
        let imagesData = NSKeyedArchiver.archivedData(withRootObject: auditImages) as NSData
        return imagesData.write(to: url, atomically: true)
    }
    
    class func deleteAuditImages(uid: Int) {
        deleteFile(url: getAuditImagesDirectory().appendingPathComponent("audit_\(uid)", isDirectory: false))
    }
    
    // The method below deletes the file at the given URL.
    class func deleteFile(url: URL)  {
        do {
            print("This is the audit url final: \(url)")
            //try FileManager.default.removeItem(at: url)
            let fileManager = FileManager.default
            try fileManager.removeItem(at: url)
        } catch let error as NSError {
            print("Error has occured: \(error)\n")
        }
    }
    
    class func getUIDFromURL(url: URL) -> Int?{
        let filename = url.lastPathComponent
        if filename.hasPrefix("audit_") {
            let idStr = filename.substring(from: String.Index.init(encodedOffset: 6))
            return Int(idStr)
        }
        
        return nil
    }
}




