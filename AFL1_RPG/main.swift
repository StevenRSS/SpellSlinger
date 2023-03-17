//
//  main.swift
//  AFL1_RPG
//
//  Created by MacBook Pro on 10/03/23.
//

import Foundation

print("// Welcome to Spellcaster //")
print("// - Let's Play! - //")
print("\nWhat's your name wizard?")
var playerName = String(readLine()!)

print("\nOh! nice to meet you \(playerName)")
print("Shall we start? Yes/No")
var startCommand = String(readLine()!)

var loop = true

let spells = ["Lightning Bolt", "Flash Freeze", "Damnation", "Pyroblast", "Hydroblast", "Blade Dance", "Poison Puffs"]

var playerSpells: Array<String> = []

var playerHealth = 20

var playerPoison = 0

var playerBurn = 0

var playerFreeze = 0

var enemySpells: Array<String> = []

var enemyHealth = 20

var enemyPoison = 0

var enemyBurn = 0

var enemyFreeze = 0

var mana = 1


if(startCommand.lowercased() == "no") {
    print("See you next time!")
}else if (startCommand.lowercased() == "yes"){
    print("\nHere we Go ~ !")
    print("You're given 5 spells each turn to cast")
    print("Each spells need mana to cast with each of them having different mana costs")
    print("The more powerful the spell the more mana it costs to cast!")
    print("The enemy has the same set of spells as you do")
    print("Each player start at 20 health points")
    print("The goal is to reduce the enemy health to 0")
    print("Well, that should be all that you need. Have fun!")
    
    var turn = 1
    
    while(loop){
        
        if (playerSpells.count == 0) {
            getSpells(PE: 0)
        }
        if (enemySpells.count == 0) {
            getSpells(PE: 1)
        }
            
            var cast = true
            
            while(cast){
                
                print("\nPyroblast -> Mana Cost: 1, Damage: 1, Burn: 1")
                print("Poison Puffs -> Mana Cost: 2, Damage: 1, Poison: 2")
                print("Lightning Bolt -> Mana Cost: 2, Damage: 3")
                print("Hydroblast -> Mana Cost: 3, Damage: 1, Freeze: 1")
                print("Flash Freeze -> Mana Cost: 3, Freeze: 2")
                print("Blade Dance -> Mana Cost: 4, Damage: 5")
                print("Damnation -> Mana Cost: 7, Damage: 10")
                
                print("\nTurn : \(turn)")
                print("Mana : \(mana)")
                
                if(enemyBurn != 0) {
                    enemyHealth -= enemyBurn
                    print("The enemy got Burned for \(enemyBurn) damage")
                    enemyBurn = 0
                } else if (enemyPoison != 0) {
                    enemyHealth -= 1
                    enemyPoison -= 1
                    print("The enemy took 1 damage from Poison. \(enemyPoison) Poison remaining")
                }
                print("\nEnemy Health : \(enemyHealth)")
                print("Enemy Spells Count : \(enemySpells.count)")
                
                if(playerBurn != 0) {
                    playerHealth -= playerBurn
                    print("You got Burned for \(playerBurn) damage")
                    playerBurn = 0
                } else if (playerPoison != 0) {
                    playerHealth -= 1
                    playerPoison -= 1
                    print("You took 1 damage from Poison. \(playerPoison) Poison remaining")
                }
                
                print("\nYour Health: \(playerHealth)")
                print("Your spells : \(playerSpells)")
                var skip: String
                if (playerSpells.count == 0) {
                    print("You need to skip a turn to get more spells!")
                }
                
                if (playerFreeze != 0){
                    print("You are frozen for \(playerFreeze), \(playerFreeze - 1) turns remaining to move")
                    playerFreeze -= 1
                    skip = "yes"
                }
                
                print("Skip turn? Yes/No")
                skip = String(readLine()!)
                
                if(skip.lowercased() == "no"){
                    print("Your Action : ")
                    var pCasting = String(readLine()!)
                    
                    if (playerSpells.contains(pCasting.capitalized)){
                        let spellCastedPlayer = castSpellPlayer(Spell: pCasting)
                        if(spellCastedPlayer.approve){
                            playerSpells.remove(at: spellCastedPlayer.index!)
                            if(enemyFreeze != 0) {
                                print("The enemy is Frozen. \(enemyFreeze) turns remaining")
                                enemyFreeze -= 1
                            } else if (enemyFreeze == 0) {
                                enemyAtk()
                            }
                            
                            if(enemyHealth <= 0 && playerHealth <= 0) {
                                print("You and the enemy are both dead :D. It's a draw!")
                                exit(0)
                            }else if(enemyHealth <= 0){
                                print("Congratulations You WIN!")
                                exit(0)
                            }else if(playerHealth <= 0){
                                print("You died..")
                                exit(0)
                            }
                            
                            turn += 1
                            mana = turn
                            
                        } else {
                            pCasting = ""
                        }
                        
                    } else {
                        print("That's not a spell that you currently have")
                        pCasting = ""
                    }
                } else if (skip.lowercased() == "yes"){
                    print("You Skipped a Turn")
                    if(playerSpells.count == 0){
                        getSpells(PE: 0)
                    }
                    if(enemySpells.count == 0){
                        getSpells(PE: 1)
                    }
                    
                    if(enemyFreeze != 0) {
                        print("The enemy is Frozen. \(enemyFreeze) turns remaining")
                        enemyFreeze -= 1
                    } else if (enemyFreeze == 0) {
                        enemyAtk()
                    }
                    
                    turn = turn + 1
                    mana = turn
                    
                }
        }
        
        
    }
}

func getSpells(PE: Int) {
    var spell = ""
    for i in 1...5 {
        let rng = Int.random(in: 0...6)
            spell = spells[rng]
        
        if(PE != 1){
            playerSpells.append(spell)
        } else {
            enemySpells.append(spell)
        }
    }
}

func castSpellEnemy() -> (approve: Bool, index: Int?) {
    var mana_cost = 0
    var approve = true
    var index: Int
    
    let rng = Int.random(in: 0...enemySpells.count)
    
    if(enemySpells.indices.contains(rng)){
        var spell = enemySpells[rng]
        
        switch spell {
        case "Lightning Bolt":
            mana_cost = 2
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerHealth -= 3
            print("The enemy cast Lightning Bolt!")
            print("You lose 3 life")
            index = enemySpells.firstIndex(of: "Lightning Bolt")!
            approve = true
            return (approve, index)
            
        case "Flash Freeze":
            mana_cost = 3
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerFreeze = 2
            print("The enemy cast Flash Freeze!")
            print("You are Frozen for 2 turns")
            index = enemySpells.firstIndex(of: "Flash Freeze")!
            approve = true
            return (approve, index)
            
        case "Damnation":
            mana_cost = 7
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerHealth -= 10
            print("DAMNATION!!")
            print("YOU LOSE 10 LIFE")
            index = enemySpells.firstIndex(of: "Damnation")!
            approve = true
            return (approve, index)
            
        case "Pyroblast":
            mana_cost = 1
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerHealth -= 1
            playerBurn = 1
            print("The enemy cast Pyroblast!")
            print("You lose 1 life and get Burn 1")
            index = enemySpells.firstIndex(of: "Pyroblast")!
            approve = true
            return (approve, index)
            
        case "Hydroblast":
            mana_cost = 3
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerHealth -= 1
            playerFreeze = 1
            print("The enemy cast Hydroblast!")
            print("You lose 1 life and get Frozen for 1 turn")
            index = enemySpells.firstIndex(of: "Hydroblast")!
            approve = true
            return (approve, index)
            
        case "Blade Dance":
            mana_cost = 4
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerHealth -= 5
            print("The enemy cast Blade Dance!")
            print("You lose 5 life!")
            index = enemySpells.firstIndex(of: "Blade Dance")!
            approve = true
            return (approve, index)
            
        case "Poison Puffs":
            mana_cost = 2
            if(mana_cost > mana) {
                print("E: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            playerHealth -= 1
            playerPoison = 2
            print("The enemy cast Poison Puffs!")
            print("You lose 1 life and get Poison 2")
            index = enemySpells.firstIndex(of: "Poison Puffs")!
            approve = true
            return (approve, index)
            
        default:break
        }
    }
    return (false, nil)
}

func enemyAtk() {
    var approve = false
        let castSpellEnemy = castSpellEnemy()
        if(castSpellEnemy.approve){
            enemySpells.remove(at: castSpellEnemy.index!)
        }
        approve = castSpellEnemy.approve
}

func castSpellPlayer(Spell: String) -> (approve: Bool, index: Int?) {
    var mana_cost = 0
    var approve: Bool
    var index: Int
    
        switch Spell {
        case "Lightning Bolt":
            mana_cost = 2
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyHealth -= 3
            print("You cast Lightning Bolt!")
            print("The enemy loses 3 life")
            index = playerSpells.firstIndex(of: "Lightning Bolt")!
            approve = true
            return (approve, index)
            
        case "Flash Freeze":
            mana_cost = 3
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyFreeze = 2
            print("You cast Flash Freeze!")
            print("The enemy is Frozen for 2 turns")
            index = playerSpells.firstIndex(of: "Flash Freeze")!
            approve = true
            return (approve, index)
            
        case "Damnation":
            mana_cost = 7
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyHealth -= 10
            print("DAMNATION!!")
            print("THE ENEMY LOSES 10 LIFE")
            index = playerSpells.firstIndex(of: "Damnation")!
            approve = true
            return (approve, index)
            
//        case "Counterspell":
//            mana_cost = 2
//            if(mana_cost != mana) {
//                print("Not Enough Mana!")
//                approve = false
//                return (approve, nil)
//            }
//            print("You Countered the enemy's spell")
            
        case "Pyroblast":
            mana_cost = 1
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyHealth -= 1
            enemyBurn = 1
            print("You cast Pyroblast!")
            print("The enemy loses 1 life and got Burn 1")
            index = playerSpells.firstIndex(of: "Pyroblast")!
            approve = true
            return (approve, index)
            
        case "Hydroblast":
            mana_cost = 3
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyHealth -= 1
            enemyFreeze = 1
            print("You cast Hydroblast!")
            print("The enemy loses 1 life and get Frozen for 1 turn")
            index = playerSpells.firstIndex(of: "Hydroblast")!
            approve = true
            return (approve, index)
            
        case "Blade Dance":
            mana_cost = 4
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyHealth -= 5
            print("You cast Blade Dance!")
            print("The enemy loses 5 life!")
            index = playerSpells.firstIndex(of: "Blade Dance")!
            approve = true
            return (approve, index)
            
        case "Poison Puffs":
            mana_cost = 2
            if(mana_cost > mana) {
                print("P: Not Enough Mana!")
                approve = false
                return (approve, nil)
            }
            enemyHealth -= 1
            enemyPoison = 2
            print("You cast Poison Puffs!")
            print("The enemy loses 1 life and get Poison 2")
            index = playerSpells.firstIndex(of: "Poison Puffs")!
            approve = true
            return (approve, index)
            
        default:break
        }
    return (false, nil)
}
