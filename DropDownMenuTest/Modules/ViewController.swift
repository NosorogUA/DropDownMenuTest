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
    
    var transperentView: UIView!
    var dropTableView: DropView!
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
        transperentView = UIView()
        let window = UIApplication.shared.keyWindow
        transperentView.frame = window?.frame ?? self.view.frame
        self.view.addSubview(transperentView)
        transperentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        
        // setup jesture
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransperentView))
        transperentView.addGestureRecognizer(tapgesture)
        
        //setup table view
        dropTableView = .fromNib()
        dropTableView.frame = CGRect(x: frames.origin.x + 10, y: frames.origin.y + frames.height, width: frames.width*0.8, height: 0)
        self.view.addSubview(dropTableView)
        dropTableView.layer.cornerRadius = 10
        
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
        }, completion: { _ in
            self.dropTableView.removeFromSuperview()
            self.transperentView.removeFromSuperview()
        })
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    
}
