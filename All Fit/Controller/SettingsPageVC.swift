//
//  SettingsPageVC.swift
//  All Fit
//
//  Created by Lam Nguyen on 8/9/21.
//

import UIKit
import MessageUI

class SettingsPageVC: HalfPageModalViewController {
    
    // MARK: asset initialization
    
    let titleLabel      = UILabel()                     //Label for the title
    let supportTable    = UITableView()                 //Table to show support options
    let supportLabel    = UILabel()                     //Label on top of the support table
    let appVersion      = "1.1"                         //Value for the app version
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.backgroundColor = .white
        
        //Set up the title label
        containerView.addSubview(titleLabel)
        (titleLabel).attributedText = NSAttributedString(string: "Settings", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 45),
            NSAttributedString.Key.foregroundColor: UIColor(red: 152, green: 152, blue: 152)
        ])
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 22).isActive = true
        titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 25).isActive = true
        
        
        //Set up the support label
        containerView.addSubview(supportLabel)
        supportLabel.attributedText = NSAttributedString(string: "Support", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor(red: 152, green: 152, blue: 152)
        ])
        
        addLabelConstraints(label: supportLabel, bottomAnchor: titleLabel.bottomAnchor)
        
        
        //Set up the support table
        containerView.addSubview(supportTable)
        supportTable.backgroundColor = containerView.backgroundColor
        supportTable.separatorStyle = .none
        supportTable.isScrollEnabled = false
        supportTable.dataSource = self
        supportTable.register(SettingsTableCell.self, forCellReuseIdentifier: "datacell")
        
        addTableConstraints(table: supportTable)
        
    }
    
    // MARK: asset constraints
    
    /*
        @addLabelConstraints
        Adds constraints to a label
     */
    func addLabelConstraints(label: UILabel, bottomAnchor: NSLayoutYAxisAnchor){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 28).isActive = true
        label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 19).isActive = true
    }
    
    /*
        @addTableConstraints
        Adds constraints to a table
     */
    func addTableConstraints(table: UITableView){
        table.translatesAutoresizingMaskIntoConstraints = false
        table.heightAnchor.constraint(equalToConstant: 200).isActive = true
        table.topAnchor.constraint(equalTo: supportLabel.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10).isActive = true
        table.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -18).isActive = true
    }
}

// MARK: table functions

extension SettingsPageVC: UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! SettingsTableCell
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        
        //Customize the cell
        cell.titleLabel.textColor = .black
        cell.titleLabel.font = UIFont.systemFont(ofSize: 20)
        if indexPath.row == 0       { cell.titleLabel.text = "Report Bugs"; cell.continueButton.addTarget(self, action: #selector(reportBugsClicked), for: .touchUpInside) }
        else if indexPath.row == 1  { cell.titleLabel.text = "Contact"; cell.continueButton.addTarget(self, action: #selector(contactClicked), for: .touchUpInside) }
        else if indexPath.row == 2  { cell.titleLabel.text = "Privacy Policy"; cell.continueButton.addTarget(self, action: #selector(privacyClicked), for: .touchUpInside) }
        else if indexPath.row == 3  { cell.titleLabel.text = "App Version" }
        
        // Set up the button
        cell.continueButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        cell.continueButton.tintColor = .gray
        cell.continueButton.contentHorizontalAlignment = .right
        if indexPath.row == 3{
            cell.continueButton.setImage(nil, for: .normal)
            cell.continueButton.isUserInteractionEnabled = false
            cell.continueButton.setTitle(appVersion, for: .normal)
            cell.continueButton.setTitleColor(.gray, for: .normal)
        }
        
        //Hide the switch
        cell.switchToggle.isHidden = true
        
        return cell
    }
    
    // MARK: objc functions
    /*
        @reportBugsClicked
        When clicked, open up the link to report bugs form
     */
    @objc func reportBugsClicked(){
        let urlString = "https://forms.gle/WfTSQemhdfwTaVo16"
        if let urlToOpen  = URL(string: urlString){             //Open Report Bugs Link
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        }
    }
    
    /*
        @contactClicked
        When clicked, opens up a view controller to contact developer
     */
    @objc func contactClicked(){
        //Check to see if Mail is setup on device
        guard MFMailComposeViewController.canSendMail() else{
            let alertController = UIAlertController(title: "Error", message: "Please set up mail on device", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            return
        }
        
        //Open the mail controller
        let mailcntr = MFMailComposeViewController()
        mailcntr.mailComposeDelegate = self
        mailcntr.setSubject("All Fit Contact")                                               //Email Subject
        mailcntr.setToRecipients(["lance66nguyen@gmail.com"])                        //Email Recipients
        
        present(mailcntr, animated: true)
    }
    
    /*
        @didFinishWith
        Dismiss the mail view controller when cancel is clicked or mail is sent
     */
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func privacyClicked(){
        let urlString = "https://lamnguynn.github.io/All-Fit/"
        if let urlToOpen  = URL(string: urlString){             //Open Privacy Policy Link
            UIApplication.shared.open(urlToOpen, options: [:], completionHandler: nil)
        }
    }
    
}
