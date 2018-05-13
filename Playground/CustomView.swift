//
//  CustomView.swift
//  Playground
//
//  Created by Andrew Tantomo on 2016/11/06.
//  Copyright © 2016年 Andrew Tantomo. All rights reserved.
//

import UIKit

@IBDesignable class CustomView : UIButton {

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        label.text = " iPhone 6s Plus"
//        let url = "http://i.telegraph.co.uk/multimedia/archive/03058/iphone_6_3058505b.jpg"
//        aimageView.image = UIImage(data: NSData(contentsOf: NSURL(string: url)! as URL)! as Data)
    }
    
    var label: UILabel!
    var aimageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }

    func addSubviews() {
        aimageView = UIImageView()
        addSubview(aimageView)
        label = UILabel()
        addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        backgroundColor = .purple
        layer.borderWidth = 0.5
        layer.cornerRadius = 5
        aimageView.frame = self.bounds
        aimageView.contentMode = UIViewContentMode.scaleAspectFit
        label.frame = CGRect(x: 0, y: bounds.size.height - 40, width: bounds.size.width, height: 40)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        label.textAlignment = .center
        label.textColor = .gray
    }
}
