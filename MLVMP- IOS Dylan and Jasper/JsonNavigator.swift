//
//  JsonNavigator.swift
//  MLVMP- IOS Dylan and Jasper
//
//  Created by Dylan Landry on 7/13/15.
//  Copyright (c) 2015 Dylan Landry. All rights reserved.
//

import UIKit

class JsonNavigator: NSObject {
    var json = [String : AnyObject]()
    var orderOfNavigation = [String]()
    var cards = [Card]()
    var pullSpecies: Bool = false
    var test: Bool = true
    
    init(json: [String: AnyObject]){
        
        self.json = json
        
    }
    
    func advance(selectedCardTitle: String){
        test = true
    
        json = json[selectedCardTitle.lowercaseString] as! [String : AnyObject]
        
        orderOfNavigation.append(selectedCardTitle.lowercaseString)
    
        if(json.keys.count != 1){
            
            pullSpecies = false
            
            
            
            
        } else {
            
            pullSpecies = true
            
        }
    }
    func regress(){
        
        json = jsonResponse()
        orderOfNavigation.removeLast()

        for index: Int in 0 ..< orderOfNavigation.count {

            json = json[orderOfNavigation[index]] as! [String : AnyObject]
            
        }
         
    }
    
    func checkAvail(json: [String : AnyObject], categoryToCheck: String) -> Bool{
        
        var out: Bool = false
        var newJson = [String : AnyObject]()
        newJson = json
        
        if(!(newJson.keys.count == 1)){
            
            for i in 0 ..< newJson.keys.count{
                let array : [String] = [String](newJson.keys)
                let selectedCategory = array[i];
                var matches = SortThread.getSortThread().retrieveMatches()
                
                for j in 0 ..< matches.count{
                
                    
                    
                    for k in 0 ..< matches[j].tags.count{
                        
                        if(selectedCategory == matches[j].tags[k]) {
                            
                           
                            out = true
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }else{
            
            var matches = SortThread.getSortThread().retrieveMatches()
            
            for j in 0 ..< matches.count {
                
               
                
                for k in 0 ..< matches[j].tags.count {
                    
                    if(matches[j].tags[k] == categoryToCheck){
                        
                        out = true
                        
                        
                    }
                    
                }
                
            }
            
        }
        
        
        
        return(out)
    }
    
    
    func updateCards(){
        let array : [String] = [String](json.keys)
        //Checks if we should display species or categories.
        if(json.keys.count != 1){
                
            pullSpecies = false
                
        }
        
        cards.removeAll(keepCapacity: false)
        
        if(pullSpecies == false){
        //Display categories.
            for index: Int in 0 ..< json.keys.count {
                
                if(array[index] != "picture"){
                    
                    var tempJsonLocale = json[array[index]] as! [String : AnyObject]
                    let c = Card(name: array[index], pictureName: tempJsonLocale["picture"] as! String, invasive: false)
                    cards.append(c)
                    
                }
                
                if(index == array.count - 1){
                    
                    cards = cards.sort{
                        $0.name < $1.name
                    }
                }
                
            }
            
        } else {
        //Display species.
            var matchedSpeciesArray = SortThread.getSortThread().retrieveMatches()
            if orderOfNavigation.last == "other aquatic curiosities"
            {
                    matchedSpeciesArray = matchedSpeciesArray.sort
                    {
                            $0.order < $1.order
                    }
            }
            for index: Int in 0 ..< matchedSpeciesArray.count {
                
                
                if(matchedSpeciesArray[index].invasive != nil){
                    let c = Card(name: matchedSpeciesArray[index].name, pictureName: matchedSpeciesArray[index].pictures![0], invasive: true)
                    cards.append(c)
                    
                } else {
                    
                    let c = Card(name: matchedSpeciesArray[index].name, pictureName: matchedSpeciesArray[index].pictures![0], invasive: false)
                    cards.append(c)
                    
                }
                
                
            }
            
        }
            
    }

    func getCards() -> [Card]{
      
        return cards
        
    }
    
}
