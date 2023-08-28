//
//  MainMenuViewController.swift
//  NewsApplication1
//
//  Created by Madhu Mangadoddi on 27/08/23.
//

import Foundation
import UIKit

class MainMenuViewController : UIViewController{
    
    
    @IBOutlet var tapGester: UITapGestureRecognizer!
    @IBOutlet var MenuTableView: UITableView!
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view != self.view {
            print("clicked")
        }else{
            print("second")
        }
        print("sdfsdf")
    }
    
    @IBAction func TapGestertapped(_ sender: Any) {
        print("menu")
        
    }
    
    
    override func viewDidLoad() {
        self
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.layer.add(transition, forKey: kCATransition)
        
        
        //self.modalPresentationStyle = .custom
        //self.view.frame.size.width = 200
        //self.view.widthAnchor.constraint(equalToConstant: 200).isActive = true
        MenuTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
        MenuTableView.delegate = self
        MenuTableView.dataSource = self
    }
    override func updateViewConstraints() {
        self.view.frame.size.width = UIScreen.main.bounds.width/2
//        self.view.frame.origin.y =  100
        self.view.layer.cornerRadius = 7
        self.view.layer.borderWidth = 1
        super.updateViewConstraints()
    }
}

extension MainMenuViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = MenuTableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.menuItemLabel.text = menuArray[indexPath.row]
        return cell
    }
    
    
}
