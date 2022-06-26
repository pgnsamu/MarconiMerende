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
    
    
    //@Published var responseToken: responsejwt = responsejwt(message: "placeholder", jwt: "", email: "", expireAt: 0)
    //@Published var responseToken: String = ""
    @AppStorage("token", store: .standard) var responseToken: String = ""
    
    @Published var sivede = false
    @Published var errAcc = false
    
    let group = DispatchGroup()  //getToken() inizio-fine
    let group2 = DispatchGroup() //getclasse() inizio-fine
    let group3 = DispatchGroup() //getAuth() inizio-fine
    let group4 = DispatchGroup() //authcheck inizio-fine
    let group5 = DispatchGroup() //
    
    //@Published var risposta = false
    @Published var active = true
    
    var url_create = "https://merende.000webhostapp.com/merende/createauth.php"
    var url_get = "https://merende.000webhostapp.com/merende/riepilogo.php?classe="
    var url_checkB = "https://merende.000webhostapp.com/merende/auth.php?Authorization="
    var url = "https://aeminformatica.it/webservice/listamerende/"
    var url2 = "merende.epizy.com/merende/createauth.php"
    var url_insert = "https://merende.000webhostapp.com/post2.php"
    var url_insert2 = "https://merende.000webhostapp.com/merende/post3.php"
    
    @Published var prod0tti: [prodotto] = [prodotto(id: "", des: "", price: "")]
    var studente: utente = utente(status: 1, nome: "", cognome: "", gruppo: "", cod_organizzazione: "")
    
    @Published var ordini: [ordine] = [ordine(classe: "", data: "", qta: 0, serialsim: 0, nome: "", cognome: "", cod_organizzazione: 0, id: 0, IDU: 0)]
    
    @Published var msg: response2 = response2(status: 0, msg: "")
    @Published var carrello: [insert] = []
    @Published var arrayA: [String] = []
    
    //Utilizzo token
    func prinT(){
        print(responseToken)
    }

    func GetToken(datiutente: [user]) {
        print("inizio creazione token")
        arrayA.append("inizio creazione token")
        guard let url_create = URL(string: url_create) else {
            print("merende")
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
        
        group.enter()
        //print(String(data: httpbody, encoding: .utf8))
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(responsejwt.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.responseToken = result.jwt
                        print("token creato")
                        self.active = true
                        self.group.leave()
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
        group4.enter()
        if(studente.nome == ""){
            getClasse()
        }
        group2.notify(queue: .main) { [self] in
            if(responseToken == ""){
                GetToken(datiutente:  [user(classe: studente.gruppo, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: 1)])
            }
            group.notify(queue: .main) { [self] in
                GetAuth()
                group3.notify(queue: .main) { [self] in
                    if(active == false){
                        GetToken(datiutente:  [user(classe: studente.gruppo, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: 1)])
                        group.notify(queue: .main) { [self] in
                            group4.leave()
                        }
                    }else{
                        group4.leave()
                    }
                    
                }
            }
        }
    }
    
    func GetAuth(){
        let url_check = url_checkB+responseToken
        guard let url_check = URL(string: url_check) else {
            print("merende")
            return
            
        }
        print(url_check)
        var request = URLRequest(url: url_check)
        request.httpMethod = "GET"
        //print(String(data: httpbody, encoding: .utf8))
        group3.enter()
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(responsetkn.self, from: data)
                    
                    DispatchQueue.main.async { [self] in
                        self.active = result.message
                        print(result.desc)
                        group3.leave()
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                }
                
            }else{
                print("No data")
            }
        }.resume()
        
    
        
    }
        
    func removeprod(index: IndexSet){
        self.carrello.remove(atOffsets: index)
    }
    
    func GetOrdini(){
        if(studente.gruppo==""){
            getClasse()
        }
        let url_getF = url_get+"5Ainf"
        guard let url_getF = URL(string: url_getF) else {
            print("merende")
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
        print("richiesta classe")
        let urlb = "https://aeminformatica.it/webservice/listamerende/getuserinfo.php?username="
        let email = GIDSignIn.sharedInstance.currentUser?.profile?.email
        let url4 = urlb+email!
        guard let url4 = URL(string: url4) else {
            print("merende")
            return
        }
         
        var request = URLRequest(url: url4)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        group2.enter()
        URLSession.shared.dataTask(with: request) { data, res, err in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(utente.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.studente = result
                        print(result)
                        print("fine richiesta classe")
                        self.group2.leave()
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                    if (err.localizedDescription == "The data couldn’t be read because it is missing."){
                        self.errAcc = true
                    }
                    
                }
                
            }else{
                print("No data")
            }
        }.resume()
    }
    
    func addChart(qta: Int, id: Int){
        carrello.append(insert(classe: studente.gruppo, id: id, qta: qta, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: Int(studente.cod_organizzazione) ?? 1))
    }
    
    /*func invio() {
        authCheck()
        group4.notify(queue: .main) { [self] in
            insertData()
        }
        
    }*/
    
    func insertData() {
        guard let url_insert2 = URL(string: url_insert2) else {
            print("merende")
            return
            
        }
        
        var request = URLRequest(url: url_insert2)
        request.httpMethod = "POST"
        request.setValue(responseToken, forHTTPHeaderField: "authorization")
        do {
            let httpbody = try JSONEncoder().encode(carrello)
            let jsonString = String(data: httpbody, encoding: .utf8)!
            request.httpBody = httpbody
            print(jsonString)
            print(request)
        } catch {
            print(error)
            print("request")
        }

        
        //print(String(data: httpbody, encoding: .utf8))
        group5.enter()
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data {
                do{
                    let result = try JSONDecoder().decode(response2.self, from: data)
                    
                    DispatchQueue.main.async { [self] in
                        self.msg = result
                        if(result.status != 2){
                            sivede = true
                        }
                        print(result)
                        group5.leave()
                    }
                } catch (let err) {
                    print(err.localizedDescription)
                    group5.leave()
                    msg.status = 2
                }
                
            }else{
                print("No data")
            }
        }.resume()
    }
    
    func invio(){
        insertData()
        group5.notify(queue: .main) { [self] in
            if(msg.status != 1){
                GetToken(datiutente: [user(classe: studente.gruppo, serialsim: "00", nome: studente.nome, cognome: studente.cognome, cod_organizzazione: 1)])
                group.notify(queue: .main) { [self] in
                    insertData()
                }
                
            }
            
        }
    }
    
    /*func insertData(){
        guard let url_insert = URL(string: url_insert) else {
            print("merende")
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
    }*/
    
    func getData2(){
        guard let url = URL(string: url) else {
            print("merende")
            return
            
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
   
        URLSession.shared.dataTask(with: request) { data, res, err in
            print("richiesta prodotti")
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
