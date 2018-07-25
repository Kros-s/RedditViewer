//
//  PreviewViewController.swift
//  RedditViewer
//
//  Created by Marco Antonio Mayen Hernandez on 7/25/18.
//  Copyright © 2018 Marco Antonio Mayen Hernandez. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

    
    @IBOutlet weak var preview: UIImageView!
    @IBAction func closePop(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        // Do any additional setup after loading the view.
        setupView()
    }
    
    func setupView() {
        
        preview.layer.borderWidth = 10.0
        preview.layer.masksToBounds = false
        preview.layer.borderColor = UIColor.white.cgColor
        preview.layer.cornerRadius = 50
        preview.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
