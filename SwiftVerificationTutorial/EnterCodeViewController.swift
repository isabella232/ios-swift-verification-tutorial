//
//  EnterCodeViewController.swift
//  SwiftVerificationTutorial
//
//  Created by christian jensen on 10/29/15.
//  Copyright © 2015 christian jensen. All rights reserved.
//

import UIKit;
import SinchVerification;

class EnterCodeViewController: UIViewController {
    var verification:Verification!;

    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var pinCode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad();
        pinCode.becomeFirstResponder();
    }

    @IBAction func verify(sender: AnyObject) {
        spinner.startAnimating();
        verifyButton.enabled = false;
        status.text  = "";
        pinCode.enabled = false;
        verification.verify(pinCode.text!, completion: { (success:Bool, error:NSError?) -> Void in
            self.spinner.stopAnimating();
            self.verifyButton.enabled = true;
            self.pinCode.enabled = true;
            if (success) {
                self.status.text = "Verified";
            } else {
                self.status.text = error?.description;
            }
        });
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
