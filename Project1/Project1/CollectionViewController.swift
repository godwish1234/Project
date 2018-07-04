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

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Initialise()


        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return Titles.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        
        //let data = try? Data(contentsOf: url!)
        
        /*
        if let img = imageCache.object(forKey: Images[indexPath.row] as AnyObject) {
            cell.Image.image = img as! UIImage
        }
        else{
            DispatchQueue.global().async {
                //let url = URL(string: Images[indexPath.row])
                
                if(Images[indexPath.row] != ""){
                    print("A")
                    let url = NSData(contentsOf: URL(string: Images[indexPath.row])!)
                    DispatchQueue.main.async {
                        cell.Image.image = UIImage(data: url as! Data)
                        imageCache.setObject(UIImage(data: url as! Data)!, forKey: Images[indexPath.row] as AnyObject)
                    }
                }
                else{
                    //Images.remove(at: <#T##Int#>)
                    print("B")
                }
                
                
            }
        }*/
        
        if let img = imageCache.object(forKey: Images[indexPath.row] as AnyObject) {
            cell.Image.image = img as! UIImage
        }
        
        // if not, download image from url
        
        if(Images[indexPath.row] != ""){
            let url = URL(string: Images[indexPath.row])
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
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
        
        
        
        
        /*
        let url = URL(string: Images[indexPath.row])
        
        let session = URLSession(configuration: .default)
        
        let downloadPicTask = session.dataTask(with: url!) { (data, response, error) in
            // The download has finished.
            print("aaa")
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        
                        
                        /*
                        DispatchQueue.global().async {
                            //let url = URL(string: Images[indexPath.row])
                            let url2 = NSData(contentsOf: URL(string: Images[indexPath.row])!)
                            DispatchQueue.main.async {
                                cell.Image.image = UIImage(data: imageData)
                                imageCache.setObject(UIImage(data: url2 as! Data)!, forKey: Images[indexPath.row] as AnyObject)
                            }
                            
                        }*/
                        
                        // Finally convert that Data into an image and do what you wish with it.
                        //let image = UIImage(data: imageData)
                        cell.Image.image = UIImage(data: imageData)
                        imageCache.setObject(UIImage(data: imageData)!, forKey: Images[indexPath.row] as AnyObject)
                        
                    } else {
                        print("Couldn't get image: Image is nil")
                        Images.remove(at: indexPath.row)
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
        */
        
        
        
        
        
        cell.Title.text = Titles[indexPath.row]
        cell.Description.text = Descriptions[indexPath.row]
        
        
        // Configure the cell
    
        return cell
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
