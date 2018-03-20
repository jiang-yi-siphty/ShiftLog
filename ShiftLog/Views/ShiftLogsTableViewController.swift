//
//  ShiftLogsTableViewController.swift
//  ShiftLog
//
//  Created by Yi JIANG on 20/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShiftLogsTableViewController: UITableViewController {

    fileprivate let disposeBag = DisposeBag()
    var slViewModel: ShiftLogViewModel? {
        didSet{
            bindViewModel()
        }
    }
    var selectedCellIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        bindUI()
        tableView.register(LogTableViewCell.nib(), forCellReuseIdentifier: "LogTableViewCell")
        slViewModel = ShiftLogViewModel(ApiClient())

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate func bindUI() {
        
    }
    
    fileprivate func bindViewModel() {
        tableView.dataSource = nil
        slViewModel?.shiftLogs.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier:"LogTableViewCell", cellType: LogTableViewCell.self)) { (_, shiftLog, cell) in
            cell.configureCell(shiftLog)
            }.disposed(by: disposeBag)
    }
    
}
