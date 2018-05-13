//
//  FirstTabViewController.swift
//  Playground
//
//  Created by Andrew Tantomo on 2018/05/10.
//  Copyright © 2018年 Andrew Tantomo. All rights reserved.
//

import UIKit

class FirstTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loveButtonTapped(_ sender: Any) {
        let item = tabBarItem

//        var v: UIImageView = self
//        repeat { v = v.superview! } while !(v is UITableView)

        item?.badgeValue = "2"
        if let view = tabBarController?.tabBar.subviews[2].subviews.first as? UIImageView {

            let image = UIImageView(image: view.image)
            image.bounds = view.bounds
            image.tintColor = UIColor(red: 210/255, green: 64/255, blue: 94/255, alpha: 1.0)

            view.addSubview(image)

            //print(view)
            UIView.animate(withDuration: 0.7, animations: {
                image.alpha = 0.0
                image.transform = CGAffineTransform(scaleX: 3, y: 3)
            }, completion: { completed in
                image.removeFromSuperview()
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
