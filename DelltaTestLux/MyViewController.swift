//
//  ViewController.swift
//  18с
//
//  Created by sergey on 04.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit
import SQLite

class MyViewController: UITableViewController, UISearchBarDelegate {
    
    var qDao : QDao?
    var product : RegisteredPurchase?
    
    var questionArryDefault = [Quest]()
    var questionArray = [Quest]()
    var questionArraySearch = [Quest]()
    
    var searcBar = UISearchController()
    
    var alterSearchBar = UISearchBar()
    
    var baseName : String?
    
    
    init(product: RegisteredPurchase) {
        self.product = product
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  setTitle()
      //  alterSearch()
        baseName = product?.endNameApp
      
        qDao = QDao(baseName: baseName!)

        setupData()

        tableView.register(MyCell.self, forCellReuseIdentifier: "cell")
        tableView.register(MyCellWithImage.self, forCellReuseIdentifier: "cellImage")
        tableView.backgroundColor = UIColor(displayP3Red: 197/255, green: 202/255, blue: 232/255, alpha: 1)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        // Do any additional setup after loading the view, typically from a nib.
        setupSearch()
        
    }
    
  
  
    func setTitle(){
    tabBarController?.navigationItem.title = "Все вопросы"
        
    }

    func setupData(){
        // let qDao = QDao()
        questionArryDefault = (qDao?.getAllQuest())!
        questionArray = questionArryDefault
    }
    

    
    func setupSearch()  {
        searcBar = UISearchController(searchResultsController: nil)
        
        searcBar.searchResultsUpdater = self
        searcBar.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
 
        navigationItem.searchController = searcBar
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searcBar.searchBar.delegate = self
     
        searcBar.searchBar.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isFiltering()){
            return  questionArraySearch.count
        }else {
            
            return questionArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var question: Quest
        if(isFiltering()){
            question  = questionArraySearch[indexPath.row]
        } else {question = questionArray[indexPath.row]}
        
        let number = indexPath.row + 1
        
        question.number = "Вопрос \(number)"
        
        var cell : MyCell
        if let img = question.img {
            
            if (img.elementsEqual("имя картинки") || img.isEmpty){
                cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCell
                cell.question = question
                cell.layoutSubviews()
                return cell
                
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: "cellImage", for: indexPath) as! MyCellWithImage
                cell.question = question
                cell.layoutSubviews()
                return cell
                
            }
        }
        return UITableViewCell()
        
    }
    
  
    func filterContentForSearchText(_ searchText: String) {
        questionArraySearch = questionArray.filter({( quest : Quest) -> Bool in
            
            if searchBarIsEmpty() {
                return true
                
            } else {
                return quest.body!.lowercased().contains(searchText.lowercased())
              
            }
        })
        tableView.reloadData()
    }
    
    
}



extension MyViewController: UISearchResultsUpdating {
    
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searcBar.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return searcBar.isActive && !searchBarIsEmpty ()
        
    }
    
    // MARK: - UISearchResultsUpdating Delegate
    
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        // TODO
        
        if searchController.isActive{
            
            filterContentForSearchText(searcBar.searchBar.text!)
            
        } else {tableView.reloadData()
            
        }
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did sel")
        var question: Quest
        if(isFiltering()){
            question  = questionArraySearch[indexPath.row]
        } else {question = questionArray[indexPath.row]}


        if !(question.img!.elementsEqual("имя картинки")  || question.img!.isEmpty){

            let vc = DetailQuestionImage()
            vc.question = question
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    }
    
    
}

