//
//  ViewController.swift
//  DropDownMenuTest
//
//  Created by mac on 12/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableViewController: UITableView!
    
    var presenter: Presenter!
    
    let transperentView = UIView()
    let dropTableView = UITableView()
    var currentFrames: CGRect!
    var tags: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter = Presenter(view: self)
        setupTableView()
    }
    
    private func setupTableView() {
        let dropDownCell = UINib(nibName: DropDownMenuTableViewCell.identifier, bundle: nil)
        tableViewController.register(dropDownCell, forCellReuseIdentifier: DropDownMenuTableViewCell.identifier)
    }
    
    private func addDropDownView(frames: CGRect) {
        // setup background
        let window = UIApplication.shared.keyWindow
        transperentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transperentView)
        transperentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        // setup jesture
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransperentView))
        transperentView.addGestureRecognizer(tapgesture)
       
        //setup table view
        dropTableView.frame = CGRect(x: frames.origin.x + 10, y: frames.origin.y + frames.height, width: frames.width*0.8, height: 0)
        self.view.addSubview(dropTableView)
        dropTableView.layer.cornerRadius = 10
        
        //register options cell
        let dropVariantCell = UINib(nibName: DropOptionTableViewCell.identifier, bundle: nil)
        dropTableView.register(dropVariantCell, forCellReuseIdentifier: DropOptionTableViewCell.identifier)
       
        //animate showing
         transperentView.alpha = 0
         UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
             self.transperentView.alpha = 0.5
             self.dropTableView.frame = CGRect(x: frames.origin.x + 10, y: frames.origin.y + frames.height, width: frames.width*0.8, height: 400)
         }, completion: nil)
         
    }
    
    @objc func removeTransperentView() {
        print("removeView")
        //animate hiding
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: {
            self.transperentView.alpha = 0
            self.dropTableView.frame = CGRect(x: self.currentFrames.origin.x + 10, y: self.currentFrames.origin.y + self.currentFrames.height, width: self.currentFrames.width*0.8, height: 0)
        }, completion: nil)
    }
 
    func openDropMenu(frames: CGRect) {
           //open table vie
        print("Open drop menu")
        currentFrames = frames
        addDropDownView(frames: frames)
       }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewController {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tableViewController {
            switch MainControllerCells(rawValue: indexPath.row) {
            case .tags:
                print("configure cell")
                let cell = tableView.dequeueReusableCell(withIdentifier: DropDownMenuTableViewCell.identifier, for: indexPath) as! DropDownMenuTableViewCell
                presenter.configureDetailCell(cell)
                cell.variantsButtonHandler = { [weak self] in
                    self?.openDropMenu(frames: cell.frame)
                }
                cell.selectionStyle = UITableViewCell.SelectionStyle.none
                return cell
            case .none:
                return UITableViewCell()
            }
        }
        else if tableView == dropTableView {
            print("configure drop cell")
            let cell = tableView.dequeueReusableCell(withIdentifier: DropOptionTableViewCell.identifier, for: indexPath) as! DropOptionTableViewCell
            presenter.configureTagListCell(cell: cell, indexPath: indexPath)
            return cell
        } else {
            print("return enpty cell")
            return UITableViewCell()
        }
    }
}

