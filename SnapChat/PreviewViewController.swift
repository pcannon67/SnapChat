//
//  PreviewViewController.swift
//  SnapChat
//
//  Created by Peter Menner on 5/27/15.
//  Copyright (c) 2015 Peter Menner. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var secondsButton: UIButton!
    @IBAction func secondsPressed(sender: AnyObject) {
        println("show pickerView")
        println("\(picker.bounds.width) \(picker.bounds.height)")
        pickerContainer.frame = CGRectMake(0, UIScreen.mainScreen().bounds.height - picker.bounds.height, picker.bounds.width, picker.bounds.height)
        self.view.addSubview(pickerContainer)
    }
    
    var previewImage: UIImage?
    var picker = UIPickerView(frame: CGRectMake(0, 0, 0, 0))
    var pickerContainer = UIView(frame: CGRectMake(0, 0, 0, 0))
    var duration = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.showsSelectionIndicator = true
        picker.delegate = self
        picker.dataSource = self
        pickerContainer.backgroundColor = UIColor.grayColor()
        pickerContainer.addSubview(picker)
        
        secondsButton.setTitle("\(duration)", forState: .Normal)
        
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 10 : 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if component == 1 {
            return "seconds"
        } else {
            return "\(row+1)"
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            println("Selected \(row+1) seconds")
            secondsButton.setTitle("\(row+1)", forState: .Normal)
            duration = row + 1
            pickerContainer.removeFromSuperview()
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        previewImageView.image = previewImage
        self.navigationController?.navigationBarHidden = true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //pickerContainer.removeFromSuperview()
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? FriendsTableViewController {
            destination.imageToUpload = previewImage!
            destination.duration = duration
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
