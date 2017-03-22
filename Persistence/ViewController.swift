//
//  ViewController.swift
//  Persistence
//
//  Created by Jason Mendez on 3/15/17.
//  Copyright © 2017 Jason Mendez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate static let rootKey = "rootKey"
    @IBOutlet var lineFields: [UITextField]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let fileURL = self.dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path!)) {
            if let array = NSArray(contentsOf: fileURL as URL) as? [String] {
                for i in 0..<array.count {
                    lineFields[i].text = array[i]
                }
            }
            
            let data = NSMutableData(contentsOf: fileURL as URL)
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data as! Data)
            let fourLines = unarchiver.decodeObject(forKey: ViewController.rootKey) as! FourLines
            unarchiver.finishDecoding()
            
            if let newLines = fourLines.lines {
                for i in 0..<newLines.count {
                    lineFields[i].text = newLines[i]
                }
            }
            
        }
        
        
        let app = UIApplication.shared
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive(notification:)), name: Notification.Name.UIApplicationWillResignActive, object: app)
        
        
    }

    
    func applicationWillResignActive(notification: NSNotification) {
        let fileURL = self.dataFileURL()
        let fourLines = FourLines()
        let array = (self.lineFields as NSArray).value(forKey: "text")
            as! [String]
        fourLines.lines = array
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(fourLines, forKey: ViewController.rootKey)
        archiver.finishEncoding()
        data.write(to: fileURL as URL, atomically: true)

    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        url = URL(fileURLWithPath: "") as NSURL?  // Create a blank path
        do {
            try url = urls.first!.appendingPathComponent("data.archive") as NSURL?
                // somehow doesn't work. page 432
        } catch {
            print("Error is \(error)")
        }
        return url!
    }


}

