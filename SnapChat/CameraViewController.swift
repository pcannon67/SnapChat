//
//  CameraViewController.swift
//  SnapChat
//
//  Created by Peter Menner on 5/27/15.
//  Copyright (c) 2015 Peter Menner. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class CameraViewController: UIViewController {
    
    var snaps = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        // Do any additional setup after loading the view.
    }
    
    var image: UIImage?

    @IBOutlet weak var cameraView: UIView!
    
    @IBOutlet weak var snapsWaitingButton: UIButton!
    
    
    @IBAction func takePhotoPressed(sender: UIButton) {
        if let videoConnection = stillImageOutput?.connectionWithMediaType(AVMediaTypeVideo) {
            videoConnection.videoOrientation = AVCaptureVideoOrientation.Portrait
            stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: { (sampleBuffer, error) -> Void in
                if sampleBuffer != nil {
                    var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    var dataProvider = CGDataProviderCreateWithCFData(imageData)
                    var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                    var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
                    self.image = image
                    self.captureSession.stopRunning()
                    self.performSegueWithIdentifier("Preview", sender: self)
                }
            })
        }
    }
    
    let captureSession = AVCaptureSession()
    var stillImageOutput: AVCaptureStillImageOutput? = nil
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    
    
    override func viewWillAppear(animated: Bool) {
        snapsWaitingButton.alpha = 0
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        var backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error: NSError? = nil
        var input = AVCaptureDeviceInput(device: backCamera, error: &error)
        if error == nil && captureSession.canAddInput(input) {
            captureSession.addInput(input)
            
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput!.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(previewLayer)
                previewLayer.frame = cameraView.frame
                captureSession.startRunning()
            }
        }
        
        if let user = PFUser.currentUser() {
            println("current user: " + user.objectId!)
            var query = PFQuery(className: "SnapTargets")
            query.includeKey("user")
            query.includeKey("snap")
            query.whereKey("user", equalTo: user)
            query.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error != nil {
                    println("error retrieving snaps")
                } else {
                    println(results)
                    if let results = results as? [PFObject] {
                        if results.count > 0 {
                            self.snaps = results
                            self.snapsWaitingButton.setTitle("\(results.count)", forState: .Normal)
                            self.snapsWaitingButton.alpha = 1
                        }
                    }
                }
            })
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        //previewLayer.frame = cameraView.bounds
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Preview" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let previewController = navigationController.topViewController as? PreviewViewController {
                    previewController.previewImage = image
                }
            }
        }
        if segue.identifier == "ShowSnaps" {
            if let navigationController = segue.destinationViewController as? UINavigationController, let destination = navigationController.topViewController as? SnapListTableViewController {
                destination.snaps = snaps
            }
        }
    }


}
