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
    @IBOutlet weak var refreshBarbuttonItem: UIBarButtonItem!
    
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
        // MARK: set up tableview cell selected action
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.selectedCellIndexPath = indexPath
                self.performSegue(withIdentifier: "ShowMapViewSegue", sender: self)
            })
            .disposed(by: disposeBag)
        
        refreshBarbuttonItem.rx.tap.asObservable()
            .subscribe(onNext: { () in
                self.slViewModel?.updateShiftLogs()
            }, onError: { error in
                print("error: \(error.localizedDescription)")
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    fileprivate func bindViewModel() {
        tableView.dataSource = nil
        slViewModel?.shiftLogs.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier:"LogTableViewCell", cellType: LogTableViewCell.self)) { (_, shiftLog, cell) in
            cell.configureCell(shiftLog)
            }.disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapViewSegue" {
            if let destinationVC = segue.destination as? ShiftMapViewController {
                guard let selectedCellIndexPath = selectedCellIndexPath else { return }
                guard let cell = tableView.cellForRow(at: selectedCellIndexPath) as? LogTableViewCell else { return }
                guard let shiftLogItem = cell.shiftLogItem else { return }
                destinationVC.shiftLogItem = shiftLogItem
            }
        }
    }
}
