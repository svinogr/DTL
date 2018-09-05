//
//  GeneralTabController.swift
//  DelltaTestLux
//
//  Created by sergey on 27.08.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import UIKit

class GeneralTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gen = ViewController()
        let genNav = UINavigationController(rootViewController: gen)
        let tabGen = UITabBarItem()
        gen.tabBarItem = tabGen
        tabGen.image = UIImage(named: "general")
        tabGen.title = "Варианты"
      
        
        let gen3 = ViewControllerMail()
        let genNav3 = UINavigationController(rootViewController: gen3)
        let tabGen3 = UITabBarItem()
        gen3.tabBarItem = tabGen3
        tabGen3.image = UIImage(named: "mail")
        tabGen3.title = "Обратная связь"
        
        viewControllers = [genNav, genNav3]
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
