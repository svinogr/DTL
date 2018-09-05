//
//  ViewControllerMail.swift
//  18с
//
//  Created by sergey on 05.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit
import MessageUI

class ViewControllerMail: UIViewController {
    
    var myTextLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    func config() -> MFMailComposeViewController{
        let mailCompose = MFMailComposeViewController()
        mailCompose.mailComposeDelegate = self

        
        mailCompose.setToRecipients(["updevel@icloud.com"])
        mailCompose.setSubject("Дельта Тест Сборник")
        return mailCompose
    }
    
    @objc func sendMail(){
        let mailVC = config()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailVC, animated: true, completion: nil)
        } else {
            showMailError()
        }
    }
    
    func showMailError() {
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "Ok", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Обратная связь"

        view.backgroundColor = UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
        
        var buttonM = UIButton()
        buttonM = UIButton(type: .system)
        
        buttonM.setTitle("Написать", for: .normal)
        buttonM.addTarget(self, action: #selector(sendMail), for: .touchUpInside)
        buttonM.translatesAutoresizingMaskIntoConstraints = false
        
        
        myTextLabel.text = "Ваши пожелания и вопросы Вы можете отправлять на почту updevel@icloud.com"
        view.addSubview(buttonM)
        view.addSubview(myTextLabel)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-100-[v0]-[v1]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": myTextLabel, "v1": buttonM]))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": myTextLabel]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": buttonM]))
      
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ViewControllerMail: MFMailComposeViewControllerDelegate {
    
}
