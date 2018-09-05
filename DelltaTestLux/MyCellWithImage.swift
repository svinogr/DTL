//
//  MyCellWithImage.swift
//  18с
//
//  Created by sergey on 05.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit

class MyCellWithImage: MyCell {
    
    var myImage : UIImageView = {
        var im = UIImageView()
        // im.image = UIImage(named: "i")
        im.contentMode = .scaleAspectFit
        im.translatesAutoresizingMaskIntoConstraints = false
        return im
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func addQuestionStack() {
        questionStack.addArrangedSubview(questionLabel)
        questionStack.addArrangedSubview(myImage)
        addSubview(questionStack)
    }
    
    override func setupViews() {
        
        myImage.image = UIImage(named: (question?.img)!)?.resized(newSize: CGSize(width: 100, height: 100))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-[v2]-[v3(2)]-[v4(100@20)]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberQuestionLabel, "v2": questionStack, "v3": divider, "v4": answerStack]))
        // number
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberQuestionLabel]))
        
        // question
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v2]-28-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": questionStack]))
        // divider
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v3]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v3": divider]))
        //stack
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v4]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v4": answerStack]))
    }
    
    
}
extension UIImage {
    
    func resized(newSize:CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
