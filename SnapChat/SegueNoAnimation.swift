//
//  SegueNoAnimation.swift
//  SnapChat
//
//  Created by Peter Menner on 5/27/15.
//  Copyright (c) 2015 Peter Menner. All rights reserved.
//

import UIKit

class SegueNoAnimation: UIStoryboardSegue {
   
    override func perform() {
        if let sourceVC = self.sourceViewController as? UIViewController {
            sourceVC.presentViewController(self.destinationViewController as! UIViewController, animated: false, completion: nil)
        }
    }
    
}
