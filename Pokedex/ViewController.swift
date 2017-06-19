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
            try bgMusic = AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3")!))
            bgMusic.prepareToPlay()
            bgMusic.numberOfLoops = -1
            bgMusic.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
        parsePokemonCSV()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredPokemon.count
        }
        return listPokemon.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var poke: Pokemon!
        
        if inSearchMode{
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = listPokemon[indexPath.row]
        }
        
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell{
            
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }
    
    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemon = listPokemon.filter({$0.name.range(of: lower) != nil})
        }
        collectionView.reloadData()
            
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
    
    @IBAction func toggledMusic(_ sender: AnyObject){
        if bgMusic.isPlaying{
            musicToggler.setImage(UIImage(named: "NoMusic.png")!, for: UIControlState())
            bgMusic.pause()
        } else {
            musicToggler.setImage(UIImage(named: "Music.png")!, for: UIControlState())
            bgMusic.play()
        }
        
    }

}

