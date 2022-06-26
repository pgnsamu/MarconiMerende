//
//  File.swift
//  Esercizio JSON 1
//
//  Created by Samuele on 21/05/21.
//

import Foundation
import SwiftUI
import CoreLocation
import Firebase
//import GoogleSignIn

struct insert:  Hashable, Identifiable, Encodable{
    var classe: String
    var id: Int
    var qta: Int
    var serialsim: String
    var nome: String
    var cognome: String
    var cod_organizzazione: Int
}

struct utente: Decodable, Hashable, Encodable{
    var status: Int
    var nome: String
    var cognome: String
    var gruppo: String
    var cod_organizzazione: String
}

//per creazione token
struct responsejwt: Hashable, Codable {
    var message: String
    var jwt: String
    var email: String
    var expireAt: Int?
}
struct user: Hashable, Codable{
    var classe: String
    var serialsim: String
    var nome: String
    var cognome: String
    var cod_organizzazione: Int
}
//autorizazione token
struct responsetkn: Hashable, Codable{
    var message: Bool
    var desc: String
}

//per inserimento prodotti
struct response2: Decodable, Hashable{
    var status: Int
    var msg: String
}

struct ordine: Decodable, Hashable, Identifiable{
    var classe: String
    var data: String
    var qta: Int
    var serialsim: Int
    var nome: String
    var cognome: String
    var cod_organizzazione: Int
    var id: Int
    var IDU: Int
}

struct prodotto: Decodable, Hashable, Identifiable{
    var id: String
    var des: String
    var price: String
}

struct elemento: Encodable, Hashable, Identifiable{
    var id: Int
    var qta: Int
}

struct Cart: Decodable, Hashable, Identifiable{
    var id: Int
    var des: String
    var price: Double
    var num: Int
}

func Checkout(riep: [Cart]) -> Double {
    var finale: Double = 0
    for i in riep{
        finale += i.price
    }
    return finale
}



var riep: [Cart] = []

var somma: Double = 0



/*
//aggiungere Google Signin
func logOut(){
    GIDSignIn.sharedInstance()?.signOut()
    try! Auth.auth().signOut()
}*/

/* non funziona KEKW prima prova
func AddPrd1(prd: Cart,riep: [Cart]) -> Cart{
    var a: Int = 0
    var index: Int = 0
    var tempo: [Cart] = []
    for k in riep {
        tempo.append(k)
    }
    for i in riep{
        if(prd.id == i.id){
            index = a
            var nvprd: Cart = Cart(id: prd.id, des: prd.des, price: (prd.price + i.price), num: (prd.num + i.num))
            tempo.remove(at: a)
            tempo.append(nvprd)
        }else if(index+1 == a){
            //nvprd: Cart = Cart(id: prd.id, des: prd.des, price: prd.price, num: prd.num)
            tempo.append(prd)
            index = a
        }
        a += 1
    }
    return tempo[index]
}
funzione usata in descrizione per aggiungere proddotti all'array
func AddPrd(prd: Cart,riep: [Cart]) -> Cart{
    var nvprd: Cart = Cart(id: prd.id, des: prd.des, price: prd.price, num: prd.num)
    for i in riep{
        if(prd.id == i.id){
            nvprd = Cart(id: prd.id, des: prd.des, price: (prd.price + i.price), num: (prd.num + i.num))
        }
    }
    return nvprd
}*/
 
