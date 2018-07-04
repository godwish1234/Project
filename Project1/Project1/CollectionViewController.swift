//
//  CollectionViewController.swift
//  Project1
//
//  Created by GODWISH JAKIN on 3/7/18.
//  Copyright © 2018 GODWISH JAKIN. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

private let reuseIdentifier = "Cell"

struct MyVariables {
    static var chosenTitles : String = ""
    static var chosenDescriptions : String = ""
    static var chosenImage : String = ""
}

var Titles = [String]()
var Descriptions = [String]()
var Images = [String]()

let imageCache = NSCache<AnyObject, AnyObject>()

struct JSONData: Decodable {
    
    let title: String?
    let rows: [Rows]
    
}

public struct Rows: Decodable {
    
    let title: String?
    let description: String?
    let imageHref: String?
}

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}

class CollectionViewController: ViewController, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Initialise()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        if let img = imageCache.object(forKey: Images[indexPath.row] as AnyObject) {
            cell.Image.image = img as! UIImage
        }
        
        // if not, download image from url
        
        if(Images[indexPath.row] != ""){
            let url = URL(string: Images[indexPath.row])
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    cell.Image.image = UIImage(named: "noimage")
                    return
                }
                
                let url2 = NSData(contentsOf: URL(string: Images[indexPath.row])!)
                DispatchQueue.main.async {
                    
                    if let image = UIImage(data: data!) {
                        imageCache.setObject(image, forKey: Images[indexPath.row] as AnyObject)
                        cell.Image.image = UIImage(data: url2 as! Data)
                    }
                }
                
            }).resume()
        }
        
        else{
            cell.Image.image = UIImage(named: "noimage")
        }
        
        cell.Title.text = Titles[indexPath.row]
        //cell.Description.text = Descriptions[indexPath.row]
        
        cell.Image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(itemClicked(_:))))
    
        return cell
    }
    
    @objc func itemClicked(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: location)
        
        MyVariables.chosenImage = Images[(indexPath?.row)!]
        MyVariables.chosenTitles = Titles[(indexPath?.row)!]
        MyVariables.chosenDescriptions = Descriptions[(indexPath?.row)!]

        performSegue(withIdentifier: "showDetails", sender: self)
        
    }
    
    func Initialise(){
        
        var NamesArray = [String]() 
        
        let jsonURLString = "https://api.myjson.com/bins/terr0"
        guard let url = URL(string: jsonURLString) else {return}
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}
            
            
            do{
                let datas = try JSONDecoder().decode(JSONData.self, from: data)
                
                for rows in datas.rows {
                    
                    
                    if(rows.title == nil ){
                        Titles.append("blank")
                    }
                    else{
                        
                        Titles.append(rows.title!)
                        
                    }
                    
                    if(rows.description == nil ){
                        Descriptions.append("blank")
                    }
                    else{
                        Descriptions.append(rows.description!)
                    }
                    
                    if(rows.imageHref == nil){
                        Images.append("")
                    }
                    else{
                        Images.append(rows.imageHref!)
                    }
 
                }
                
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
                
            }
            catch{
                print("Error reading" + error.localizedDescription)
                
            }
            
            }.resume()
        
        
    }
    
    

}
