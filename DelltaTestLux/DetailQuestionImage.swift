//
//  DetailQuestionImage.swift
//  18с
//
//  Created by sergey on 05.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit

class DetailQuestionImage: UIViewController {
    var myImage : UIImageView = {
        var im = UIImageView()
        im.contentMode = .scaleAspectFit
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    var question : Quest?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
        
        //navigationItem.title = "Рисунок к вопросу"
        
       view.addSubview(myImage)
        
        myImage.image = UIImage(named: (question?.img)!)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: ["v": myImage]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["v": myImage]))
        
        // Do any additional setup after loading the view.
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

