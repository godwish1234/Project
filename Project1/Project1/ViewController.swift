//
//  ViewController.swift
//  Project1
//
//  Created by GODWISH JAKIN on 3/7/18.
//  Copyright © 2018 GODWISH JAKIN. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

public struct Scene: Decodable {
    
    let title: String?
    let rows: [Rows]

}

public struct Rows: Decodable {
    
    let title: String?
    let description: String?
    //let imageHref: UIImage?
    //let room: [RoomList]
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    


}

