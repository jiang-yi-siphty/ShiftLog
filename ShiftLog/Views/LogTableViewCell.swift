//
//  LogTableViewCell.swift
//  ShiftLog
//
//  Created by Yi JIANG on 20/3/18.
//  Copyright © 2018 Siphty. All rights reserved.
//

import UIKit
import Kingfisher

class LogTableViewCell: UITableViewCell {

    @IBOutlet var shiftImageView: UIImageView!
    @IBOutlet var startDateTimeLabel: UILabel!
    @IBOutlet var endDateTimeLabel: UILabel!
    @IBOutlet var shiftTitleLabel: UILabel!
    var shiftLogItem: ShiftLogItem? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    static func reuseId() -> String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureCell(_ shiftLogItem: ShiftLogItem?) {
        self.shiftLogItem = shiftLogItem
        guard let shiftLogItem = shiftLogItem else { return }
        startDateTimeLabel.text = shiftLogItem.start
        if shiftLogItem.end == "" {
            endDateTimeLabel.text = "-----"
            shiftTitleLabel.text = "Shift (Working)"
        } else {
            endDateTimeLabel.text = shiftLogItem.end
            shiftTitleLabel.text = "Shift"
        }
        guard let imageUrlString = shiftLogItem.image else { return }
        shiftImageView.contentMode = .scaleAspectFit
        if let imageUrl = URL(string: imageUrlString + "\(shiftLogItem.id ?? Int(arc4random()))")  {
            shiftImageView.kf.setImage(with: imageUrl, placeholder: UIImage(named: "placeholder"), options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}
