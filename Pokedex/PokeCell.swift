//
//  PokeCell.swift
//  Pokedex
//
//  Created by Saketh D on 8/5/16.
//  Copyright © 2016 Saketh D. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var thumbLbl: UILabel!
    
    var pokemon: Pokemon!
    
    func configureCell(_ pokemon: Pokemon){
        self.pokemon = pokemon
        
        thumbLbl.text = self.pokemon.name.capitalized
        thumbLbl.font = UIFont(name: "Pokemon Solid", size: 14)
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexID)")
    }
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 4.0
        self.clipsToBounds = true
    }
}
