//
//  AutoLayoutTableViewCell.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/06/13.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class AutoLayoutTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet var skeletonParts: [UIView]!
    lazy var skeletonView: SkeletonView = {
        let view = SkeletonView(parentFrame: self.frame, roundedCornerParts: self.skeletonParts)
        view.backgroundColor = UIColor.clear
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(skeletonView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
