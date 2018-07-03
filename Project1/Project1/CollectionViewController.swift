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


struct JSONData: Decodable {
    
    let title: String?
    let rows: [Rows]
    
}

public struct Rows: Decodable {
    
    let title: String?
    let description: String?
    let imageHref: String?
}

class CollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapInitialise()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
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
        
        let url = URL(string: Images[indexPath.row])
        
        if(url == "blank"){
            print("blank")
        }
        else{
            let data = try? Data(contentsOf: url!)
            
            cell.Image.image = UIImage(data: data!)
        }
        
        cell.Title.text = Titles[indexPath.row]
        cell.Description.text = Descriptions[indexPath.row]
        
        
        // Configure the cell
    
        return cell
    }
    
    func mapInitialise(){
        
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
                        Images.append("blank")
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
