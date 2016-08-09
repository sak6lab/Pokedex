//
//  ViewController.swift
//  Pokedex
//
//  Created by Saketh D on 8/5/16.
//  Copyright © 2016 Saketh D. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var musicToggler: UIButton!
    
    var bgMusic: AVAudioPlayer!
    
    var listPokemon = [Pokemon]()
    var inSearchMode = false
    var filteredPokemon = [Pokemon]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try bgMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("music", ofType: "mp3")!))
            bgMusic.prepareToPlay()
            bgMusic.numberOfLoops = -1
            bgMusic.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        parsePokemonCSV()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }
        return listPokemon.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = listPokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell{
            
            let pokemon: Pokemon!
            if inSearchMode {
                pokemon = filteredPokemon[indexPath.row]
            } else {
               pokemon = listPokemon[indexPath.row]
            }
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
            //print(rows)
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredPokemon = listPokemon.filter({$0.name.rangeOfString(lower) != nil})
        }
        collectionView.reloadData()
            
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
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

