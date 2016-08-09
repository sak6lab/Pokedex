//
//  Pokemon.swift
//  Pokedex
//
//  Created by Saketh D on 8/5/16.
//  Copyright © 2016 Saketh D. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexID: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var name: String{
        return _name
    }
    var pokedexID: Int{
        return _pokedexID
    }
    var description: String{
        if _description == nil {
            _description = ""
        }
        return _description
    }
    var type: String{
        if _type == nil {
            _type = ""
        }
        return _type
    }
    var defense: String{
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    var height: String{
        if _height == nil {
            _height = ""
        }
        return _height
    }
    var weight: String{
        if _weight == nil{
            _weight = ""
        }
        return _weight
    }
    var attack: String{
        if _attack == nil{
            _attack = ""
        }
        return _attack
    }
    var nextEvolutionTxt: String{
        if _nextEvolutionTxt == nil{
            _nextEvolutionTxt = nil
        }
        return _nextEvolutionTxt
    }
    var nextEvolutionId: String{
        if _nextEvolutionId == nil{
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    var nextEvolutionLvl: String{
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    init(name: String, pokedexID: Int){
        self._name = name
        self._pokedexID = pokedexID
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(_pokedexID)/"
    }
    
    func downloadPokemonDetails(completed: downloadComplete) {
        let url = NSURL(string: _pokemonUrl)!
        Alamofire.request(.GET, url).responseJSON { (response: Response<AnyObject, NSError>) in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                    if let type = types[0]["name"]{
                        self._type = type.capitalizedString
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count{
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                } else {
                    self._type = " "
                }
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0 {
                    
                    if let urlstr = descArr[0]["resource_uri"] {
                        if let url = NSURL(string: "\(URL_BASE)\(urlstr)"){
                            Alamofire.request(.GET, url).responseJSON(completionHandler: { (response: Response<AnyObject, NSError>) in
                                let desResult = response.result
                                if let descDict = desResult.value as? Dictionary<String, AnyObject>  {
                                    if let description = descDict["description"] as? String {
                                        self._description = description
                                        print(self._description)
                                    }
                                    
                                }
                                
                                completed()
                                
                            })
                        }
                    }
                   
                } else {
                   self._description = " "
                }
                
                if let evolArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolArr.count > 0{
                    if let to = evolArr[0]["to"] as? String {
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolArr[0]["resource_uri"] as? String {
                                
                                let newstr = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                let num = newstr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolArr[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                print(self._nextEvolutionLvl, self._nextEvolutionId, self._nextEvolutionTxt)
                            }
                        }
                    }
                }
            
            }
        }
    }
}
