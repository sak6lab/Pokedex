//
//  ViewController.swift
//  Pokedex
//
//  Created by Saketh D on 8/5/16.
//  Copyright © 2016 Saketh D. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var musicToggler: UIButton!
    
    
    var bgMusic: AVAudioPlayer!
    
    var listPokemon = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try bgMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!))
        } catch let err as NSError {
            print(err.debugDescription)
        }
        bgMusic.prepareToPlay()
        bgMusic.play()
        collectionView.delegate = self
        collectionView.dataSource = self
        parsePokemonCSV()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            
            let pokemon = listPokemon[(indexPath.row)]
            cell.configureCell(pokemon)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    func parsePokemonCSV(){
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        do{
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            print(rows)
            for row in rows{
                if let identifier = row["identifier"], let id = row["id"]{
                    let pokemon = Pokemon(name: identifier, pokedexID: Int(id)!)
                    listPokemon.append(pokemon)
                }
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    @IBAction func toggledMusic(sender: AnyObject){
        if bgMusic.playing{
            musicToggler.setImage(UIImage(named: "NoMusic.png")!, forState: .Normal)
            bgMusic.pause()
        } else {
            musicToggler.setImage(UIImage(named: "Music.png")!, forState: .Normal)
            bgMusic.play()
        }
        
    }

}

