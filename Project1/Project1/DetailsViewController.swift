//
//  DetailsViewController.swift
//  Project1
//
//  Created by GODWISH JAKIN on 4/7/18.
//  Copyright © 2018 GODWISH JAKIN. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleBar: UINavigationBar!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleBar.topItem?.title = MyVariables.chosenTitles
        descriptionView.text = MyVariables.chosenDescriptions
        
        if(MyVariables.chosenImage == ""){
            imageView.image = UIImage(named: "noimage")
        }
        else{
            do {
                let url = URL(string: MyVariables.chosenImage)
                let data = try Data(contentsOf: url!)
                imageView.image = UIImage(data: data)
            }
            catch{
                print(error)
            }
        }
        
        
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
