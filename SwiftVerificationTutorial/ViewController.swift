//
//  ViewController.swift
//  SwiftVerificationTutorial
//
//  Created by christian jensen on 10/29/15.
//  Copyright © 2015 christian jensen. All rights reserved.
//

import UIKit;
import SinchVerification;


class ViewController: UIViewController {
    var verification:Verification!;
    var applicationKey = "";
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var calloutButton: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var spinner:UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        phoneNumber.becomeFirstResponder();
        disableUI(false);
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    func disableUI(disable: Bool){
        var alpha:CGFloat = 1.0;
        if (disable) {
            alpha = 0.5;
            phoneNumber.resignFirstResponder();
            spinner.startAnimating();
            self.status.text="";
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(30 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                self.disableUI(false);
            });
        }
        else{
            self.phoneNumber.becomeFirstResponder();
            self.spinner.stopAnimating();
            
        }
        self.phoneNumber.enabled = !disable;
        self.smsButton.enabled = !disable;
        self.calloutButton.enabled = !disable;
        self.calloutButton.alpha = alpha;
        self.smsButton.alpha = alpha;
    }
    
    @IBAction func smsVerification(sender: AnyObject) {
        self.disableUI(true);
        verification = SMSVerification(applicationKey:applicationKey, phoneNumber: phoneNumber.text!)
        verification.initiate { (success:Bool, error:NSError?) -> Void in
            self.disableUI(false);
            if (success){
                self.performSegueWithIdentifier("enterPin", sender: sender);
            } else {
                self.status.text = error?.description;
            }
        }
    }
    @IBAction func calloutVerification(sender: AnyObject) {
        disableUI(true);
        verification = CalloutVerification(applicationKey:applicationKey, phoneNumber: phoneNumber.text!);
        verification.initiate { (success:Bool, error:NSError?) -> Void in
            self.disableUI(false);
            self.status.text = (success ? "Verified" : error?.description);
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "enterPin") {
            let enterCodeVC = segue.destinationViewController as! EnterCodeViewController;
            enterCodeVC.verification = self.verification;
        }
        
    }
}

