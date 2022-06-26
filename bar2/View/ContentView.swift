//
//  ContentView.swift
//  bar2
//
//  Created by Samuele Pagnotta on 15/03/22.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        VStack{
            //utente loggato o no?
            switch viewModel.state {
                //se si apri lista prodotti
                case true: lista()
                //se no vai alla pagina di login
                case false: login(viewModel: _viewModel)
            }
        }.onAppear {
            //ricerca se l'utente è loggato
            viewModel.resign()

        }
 
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject var viewModel = AuthenticationViewModel()
    static var previews: some View {
        ContentView()
            .environmentObject(AuthenticationViewModel())
    }
}
