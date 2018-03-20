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
import Kingfisher

class ShiftLogMainViewController: UIViewController {

    @IBOutlet var turnShiftOnOffButton: UIButton!
    @IBOutlet var businessLogoImageView: UIImageView!
    @IBOutlet var businessNameLabel: UILabel!
    fileprivate let disposeBag = DisposeBag()
    var isInShift = Variable<Bool>(false)
    var seViewModel: ShiftEventViewModel? {
        didSet {
            bindShiftEventViewModel()
        }
    }
    var busiViewModel: BusinessViewModel? {
        didSet {
            bindBusinessViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
        seViewModel = ShiftEventViewModel(ApiClient())
        busiViewModel = BusinessViewModel(ApiClient())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func bindUI(){
        turnShiftOnOffButton.rx.tap.asObservable()
            .subscribe(onNext: { () in
                if self.seViewModel?.isInShift.value ?? false{
                    self.seViewModel?.endShiftEvent()
                } else {
                    self.seViewModel?.startShiftEvent()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
    }
    
    private func bindShiftEventViewModel() {
        seViewModel?.isInShift.asObservable()
            .subscribe(onNext: { isInShift in
                DispatchQueue.main.async {
                    if isInShift {
                        self.turnShiftOnOffButton.titleLabel?.text = "End Shift"
                    } else {
                        self.turnShiftOnOffButton.titleLabel?.text = "Start Shift"
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        seViewModel?.isAlertShowing.asObservable()
            .subscribe(onNext: { (isAlertShowing) in
                if isAlertShowing {
                    DispatchQueue.main.async {
                        let disconnectionAlert = UIAlertController(title: "Network Disconnected", message: "You can't start or stop Shift until you reconnect Internet.", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        disconnectionAlert.addAction(cancelAction)
                        self.present(disconnectionAlert, animated: true, completion: nil)
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    private func bindBusinessViewModel() {
        busiViewModel?.businessName.asObservable()
            .bind(to: businessNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        busiViewModel?.businessLogo.asObservable()
            .subscribe(onNext: { (logoUrlString) in
                if let logoUrlString = logoUrlString, let imageUrl = URL(string: logoUrlString) {
                    self.businessLogoImageView.contentMode = .scaleAspectFit
                    self.businessLogoImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}

