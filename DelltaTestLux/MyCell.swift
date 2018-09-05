//
//  MyCell.swift
//  18с
//
//  Created by sergey on 04.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {
    var question: Quest?
    
    let colorNumber = UIColor(displayP3Red: 92/255, green: 107/255, blue: 192/255, alpha: 1)
    
    let colorDivider = UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
    
    var numberQuestionLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(displayP3Red: 92/255, green: 107/255, blue: 192/255, alpha: 1)
        label.textColor = .white
        return label
    }()
    
    var questionLabel : UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let divider : UIImageView = {
        let div = UIImageView()
        div.translatesAutoresizingMaskIntoConstraints  = false
        div.backgroundColor =  UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
        div.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        return div
    }()
    
    
    
    var answerStack : UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    var questionStack : UIStackView = {
        var stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 10
        return stack
    }()
    
    var answerLabel = {() -> UILabel in
        var nLabel = UILabel()
        nLabel.translatesAutoresizingMaskIntoConstraints = false
        nLabel.numberOfLines = 0
        return nLabel
    }
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(displayP3Red: 232/255, green: 234/255, blue: 246/255, alpha: 1)
        self.selectionStyle = .none
        self.layer.borderColor = UIColor(displayP3Red: 92/255, green: 107/255, blue: 192/255, alpha: 1).cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        addSubview(numberQuestionLabel)
        addQuestionStack()
        addSubview(divider)
        addSubview(answerStack)
    }
    
    func addQuestionStack(){
        questionStack.addArrangedSubview(questionLabel)
        addSubview(questionStack)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupNumberToQuestionToAnswers()
        setupViews()
        
        
    }
    
    func  setupNumberToQuestionToAnswers(){
        numberQuestionLabel.text = question?.number
        questionLabel.text = question?.body
        setupAnswers()
    }
    
    func setupAnswers(){
        answerStack.removeAllArrangedSubviews()
        let answers = question!.answers
        for answerTDO in answers! {
            let label = answerLabel()
            
            answerStack.addArrangedSubview(label)
            
            label.text = "- \(answerTDO.body!)"
            
            if answerTDO.right! {
                label.font = UIFont.boldSystemFont(ofSize: 16)
                
            }
        }
    }
    
    
    
    func setupViews(){
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-[v2]-[v3(2)]-[v4(100@20)]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberQuestionLabel, "v2": questionStack, "v3": divider, "v4": answerStack]))
        // number
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberQuestionLabel]))
        
        // question
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v2]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v2": questionStack]))
        // divider
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v3]-16-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v3": divider]))
        //stack
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[v4]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v4": answerStack]))
        
    }
    
    
    
}
extension UIStackView {
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
