//
//  MorePageVC.swift
//  All Fit
//
//  Created by Lam Nguyen on 12/29/20.
//

import UIKit
import MessageUI
import SafariServices

class MorePageVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var bugsButton: UIButton!             //IBOutlet for report bugs button
    @IBOutlet weak var contactButton: UIButton!          //IBOutlet for contact
    
    @IBOutlet weak var aboutTextLabel: UILabel!          //IBOutlet for about text label
    @IBOutlet weak var upcomingFeatTextLabel: UILabel!   //IBOutlet for upcoming feature label
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet var stackView: UIStackView!
    
    //Variables to control whether to display "About", "Privacy Policy" and "Upcoming Feature" text label
    private var hideAboutText = true
    private var hideUpcomingFeatureText = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.backgroundColor = .white
        
        
        upcomingFeatTextLabel.isHidden = true
        upcomingFeatTextLabel.textColor = .darkGray
        aboutTextLabel.isHidden = hideAboutText
        aboutTextLabel.textColor = .darkGray
        upcomingFeatTextLabel.isHidden = hideUpcomingFeatureText
        scrollView.backgroundColor = applyRedColor()
        
        //Open the links when the appropriate link is pressed
        bugsButton.addTarget(self, action: #selector(openBugsLink), for: .touchUpInside)
        
        //Open up email to contact
        contactButton.addTarget(self, action: #selector(openEmail), for: .touchUpInside)
        
        //Prevent scrolling when page is first opened.
        scrollView.isScrollEnabled = false
        
    }

    //Write the email
    @objc private func openEmail(){
        //Check to see if email can be sent and show an alert if fail
        guard MFMailComposeViewController.canSendMail() else{
            let alertController = UIAlertController(title: "Error", message: "Please set up mail on device", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        let mailcntr = MFMailComposeViewController()
        mailcntr.mailComposeDelegate = self
        mailcntr.setSubject("All Fit Contact")                                               //Email Subject
        mailcntr.setToRecipients(["lance66nguyen@gmail.com"])                               //Email Recipients
        
        present(mailcntr, animated: true)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @objc private func openBugsLink(){
        if let urlToOpen  = URL(string: "https://forms.gle/WfTSQemhdfwTaVo16"){             //Open Report Bugs Link
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        }
    }
    
    //When "About" button is clicked, drop down some text using an animation or hide it.
    @IBAction func aboutButtonClicked(_ sender: UIButton){
        aboutTextLabel.text = "Welcome to All Fit! I created this app as a way to easily plan my workouts in a nice and organized way. I also created All Fit with gym beginners in mind as they may or may not know some tips, as well as exercises, to get started. \n\nI hope you will find this app useful to your workouts, and if you have questions, please feel free to contact me through email.\n\nThank you for downloading!"
        
        //Add an animation to increase the fluidity
        UIView.animate(withDuration: 0.35) { [self] in
            hideAboutText = !self.hideAboutText
            aboutTextLabel.isHidden = self.hideAboutText
        }
        
        //Enable scrolling based on if the text label is hidden or not
        //PATCH: If statement added to resolve issues from iPhone 4s
        if UIScreen.main.bounds.height < 500{
            scrollView.isScrollEnabled = hideAboutText
        }
        else{
            scrollView.isScrollEnabled = !hideAboutText
        }
        

    }
    
    //When "Upcoming Features" button is clicked, drop down some text using an animation or hide it.
    @IBAction func upcomingFeatClicked(_ sender: UIButton){
        upcomingFeatTextLabel.text = "None at the moment."
        
        //Add an animation to increase the fluidity
        UIView.animate(withDuration: 0.3) { [self] in
            hideUpcomingFeatureText = !self.hideUpcomingFeatureText
            upcomingFeatTextLabel.isHidden = self.hideUpcomingFeatureText
        }

    }


}
