//
//  ViewController.swift
//  StudyRxSwift
//
//  Created by 俞诚恺 on 2016/10/20.
//  Copyright © 2016年 sun. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var tablewView: UITableView!
    
    let disposeBag = DisposeBag()
    
    var dataArray = Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9])
    
    var storedArray = Variable<[Int]>([])
    
    var a = Variable<[Int]>([1, 2, 3, 4, 5, 6, 7, 8, 9])

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupCellAction()
        setupArrayObserver()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .done, target: self, action: #selector(ViewController.rightAction))
    }
    
    @objc private func rightAction() {
        
        a.value.append(1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupTableView() {
        
//        dataArray // 1
//            .bindTo(tablewView // 2
//                .rx // 3
//                .items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { (row, element, cell) in // 4
//                cell.textLabel?.text = "\(element) row \(row)"
//            }
//            .addDisposableTo(disposeBag) // 5

        a.asObservable()
            .bindTo(tablewView
                .rx
                .items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { (row, element, cell) in // 4
                    cell.textLabel?.text = "\(element) row \(row)"
            }
            .addDisposableTo(disposeBag)


    }
    
    private func setupCellAction() {
        
        tablewView.rx.modelSelected(Int.self) //1
            .subscribe(onNext: { // 2
                
                self.storedArray.value.append($0) // 3
                
                print("\($0) --------  \(self.tablewView.indexPathForSelectedRow)")
            })
        .addDisposableTo(disposeBag)
    }
    
    private func setupArrayObserver() {
        
        storedArray.asObservable() // 1
            .subscribe(onNext: { print($0) })
        .addDisposableTo(disposeBag)
    }
}

