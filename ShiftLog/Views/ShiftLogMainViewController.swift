//
//  ShiftLogMainViewController.swift
//  ShiftLog
//
//  Created by Yi JIANG on 16/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ShiftLogMainViewController: UIViewController {

    @IBOutlet var TurnShiftOnOffButton: UIButton!
    fileprivate let disposeBag = DisposeBag()
    var isInShift = Variable<Bool>(false)
    var seViewModel: ShiftEventViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        seViewModel = ShiftEventViewModel(ApiClient())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func bindUI(){
        TurnShiftOnOffButton.rx.tap.asObservable()
            .subscribe(onNext: { () in
                if self.seViewModel?.isInShift.value ?? false{
                    self.seViewModel?.endShiftEvent()
                } else {
                    self.seViewModel?.startShiftEvent()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
    private func bindViewModel() {
        seViewModel?.isInShift.asObservable()
            .subscribe(onNext: { isInShift in
                DispatchQueue.main.async {
                    if isInShift {
                        self.TurnShiftOnOffButton.titleLabel?.text = "End Shift"
                    } else {
                        self.TurnShiftOnOffButton.titleLabel?.text = "Start Shift"
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
}

