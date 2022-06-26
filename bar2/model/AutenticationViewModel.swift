//
//  AutenticationViewModel.swift
//  bar2
//
//  Created by Samuele Pagnotta on 16/03/22.
//

import Foundation
import Firebase
import GoogleSignIn
import SwiftUI



class AuthenticationViewModel: ObservableObject {

    
    
    @Published var state = false
    
    func GetUser() -> URL? {
        let temp = GIDSignIn.sharedInstance.currentUser?.profile?.imageURL(withDimension: 200)
        return temp
    }
    
    func resign() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            //se aveva già fatto il login
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                //richiamo il metodo di autenticazione personalizzato
              authenticateUser(for: user, with: error)
          }
        }
    }
    
    func signIn() {
      if GIDSignIn.sharedInstance.hasPreviousSignIn() {
          //se aveva già fatto il login
          GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
              //richiamo il metodo di autenticazione personalizzato
            authenticateUser(for: user, with: error)
        }
      } else {
          //se non aveva già fatto il login
          
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let configuration = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
          authenticateUser(for: user, with: error)
        }
      }
    }
    
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {

      if let error = error {
        print(error.localizedDescription)
        return
      }
      

      guard let authentication = user?.authentication, let idToken = authentication.idToken else {
          return
          
      }
      
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
      

      Auth.auth().signIn(with: credential) { [unowned self] (_, error) in
        if let error = error {
          print(error.localizedDescription)
        } else {
          self.state = true
        }
      }
    }
    
    func signOut() {

      GIDSignIn.sharedInstance.signOut()
      
      do {

        try Auth.auth().signOut()
        
        state = false
      } catch {
        print(error.localizedDescription)
      }
    }
    
    
}
