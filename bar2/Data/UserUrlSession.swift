//
//  File.swift
//  bar2
//
//  Created by Samuele Pagnotta on 17/03/22.
//

import Foundation
import SwiftUI
import Firebase
import GoogleSignIn




class UserURLSession: ObservableObject, Identifiable{
    
    var url_create = "https://ensomma.000webhostapp.com/merende/createauth.php"
    //@Published var responseToken: responsejwt = responsejwt(message: "placeholder", jwt: "", email: "", expireAt: 0)
    //@Published var responseToken: String = ""
    @AppStorage("token", store: .standard) var responseToken: String = ""
    
    @Published var sivede = false
    
    var url_get = "https://ensomma.000webhostapp.com/merende/riepilogo.php?classe="
    
    let group = DispatchGroup()

    var url_checkB = "https://ensomma.000webhostapp.com/merende/auth.php?Authorization="
    
    @Published var risposta = false
    @Published var expired = false
    
    //Utilizzo token
    func prinT(){
        print(responseToken)
    }
    
    func GetToken(datiutente: [user]) {
        guard let url_create = URL(string: url_create) else {
            print("ensomma")
            return
            
        }
        
        var request = URLRequest(url: url_create)
        request.httpMethod = "POST"
        do {
            let httpbody = try JSONEncoder().encode(datiutente)
            let jsonString = String(data: httpbody, encoding: .utf8)!
            request.httpBody = httpbody
            print(jsonString)
        } catch {
            print(error)
            print("request")
        }

        
        //print(String(data: httpbody, encoding: .utf8))
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(responsejwt.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.responseToken = result.jwt
                        //print(result)
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                }
                
            }else{
                print("No data")
            }
        }.resume()
    }
    
    func authCheck(){
        if(responseToken == ""){
            GetToken(datiutente:  [user(classe: studente.gruppo, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: 1)])
            print(responseToken)
            print("a")
        }
        GetAuth()
        if(expired == true){
            GetToken(datiutente:  [user(classe: studente.gruppo, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: 1)])
            GetAuth()
            print(" ")
        }
    }
    
    func GetAuth(){
        let url_check = url_checkB+responseToken
        guard let url_check = URL(string: url_check) else {
            print("ensomma")
            return
            
        }
        print(url_check)
        var request = URLRequest(url: url_check)
        request.httpMethod = "GET"
        //print(String(data: httpbody, encoding: .utf8))
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            group.enter()
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(responsetkn.self, from: data)
                    
                    DispatchQueue.main.async { [self] in
                        self.risposta = result.message
                        self.expired = result.desc == "Expired token" ? true : false
                        print(result.desc)
                        group.leave()
                        /*
                        if(result.message == false){
                            GetToken(datiutente: [user(classe: studente.gruppo, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: 1)])
                        }*/
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                    print("2")
                }
                
            }else{
                print("No data")
            }
        }.resume()
        
    }
    
    //var url = "https://ensomma.000webhostapp.com/json2.php"
    var url = "https://aeminformatica.it/webservice/listamerende/"
    var url2 = "merende.epizy.com/merende/createauth.php"
    //var url_insert = "https://merende.epizy.com/post2.php"
    var url_insert = "https://ensomma.000webhostapp.com/post2.php"
    
    @Published var prod0tti: [prodotto] = [prodotto(id: "", des: "", price: "")]
    var studente: utente = utente(status: 1, nome: "", cognome: "", gruppo: "", cod_organizzazione: "")
    
    @Published var ordini: [ordine] = [ordine(classe: "", data: "", qta: 0, serialsim: 0, nome: "", cognome: "", cod_organizzazione: 0, id: 0, IDU: 0)]
    
    @Published var msg: response2 = response2(status: 0, msg: "")
    @Published var carrello: [insert] = []
    
    func removeprod(index: IndexSet){
        self.carrello.remove(atOffsets: index)
    }
    
    func GetOrdini(){
        if(studente.gruppo==""){
            getClasse()
        }
        let url_getF = url_get+"5Ainf"
        guard let url_getF = URL(string: url_getF) else {
            print("ensomma")
            return
        }
        print(url_getF)
        
        var request = URLRequest(url: url_getF)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            print("entrata23")
            if let data = data {
                do{
                    let result = try JSONDecoder().decode([ordine].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.ordini = result
                        print(result)
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                }
                
            }else{
                print("No data")
            }
        }.resume()
    }
    
    func getClasse(){
        print("NNNNNNNNNNNNNNNNNN")
        let urlb = "https://aeminformatica.it/webservice/listamerende/getuserinfo.php?username="
        let email = GIDSignIn.sharedInstance.currentUser?.profile?.email
        let url4 = urlb+email!
        guard let url4 = URL(string: url4) else {
            print("ensomma")
            return
        }
         
        var request = URLRequest(url: url4)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, res, err in
            print("entrata2")
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(utente.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.studente = result
                        print(result)
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                }
                
            }else{
                print("No data")
            }
        }.resume()
    }
    
    func addChart(qta: Int, id: Int){
        carrello.append(insert(classe: studente.gruppo, id: id, qta: qta, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: Int(studente.cod_organizzazione) ?? 1))
    }
    
    
    func insertData(){
        group.notify(queue: .main, execute: { [self] in
            guard let url_insert = URL(string: url_insert) else {
                print("ensomma")
                return
                
            }
            
            var request = URLRequest(url: url_insert)
            request.httpMethod = "POST"
            do {
                let httpbody = try JSONEncoder().encode(carrello)
                let jsonString = String(data: httpbody, encoding: .utf8)!
                request.httpBody = httpbody
                print(jsonString)
            } catch {
                print(error)
                print("request")
            }

            
            //print(String(data: httpbody, encoding: .utf8))
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    do{
                        let result = try JSONDecoder().decode(response2.self, from: data)
                        
                        DispatchQueue.main.async { [self] in
                            self.msg = result
                            sivede = true
                            print(result)
                        }
                    } catch (let err) {
                        print(err.localizedDescription)
                    }
                    
                }else{
                    print("No data")
                }
            }.resume()
        })
    }
    
    func getData2(){
        guard let url = URL(string: url) else {
            print("ensomma")
            return
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
   
        URLSession.shared.dataTask(with: request) { data, res, err in
            print("entrata")
            if let data = data {
                //print(String(data: data, encoding: .utf8) ?? "*")
                do{
                    
                    let mystring = String(data: data, encoding: .utf8)
                    let due = mystring!.dropFirst(7)
                    //print(mystring!.dropFirst(7))
                    let data2 = Data(due.utf8)
                    let result = try JSONDecoder().decode([prodotto].self, from: data2)
                
                    DispatchQueue.main.async {
                        self.prod0tti = result
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                }
                
            }else{
                print("No data")
            }
        }.resume()
        
    }

}
