//
//  lista.swift
//  bar2
//
//  Created by Samuele Pagnotta on 16/03/22.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct lista: View {
    @StateObject var userurl = UserURLSession()
    @EnvironmentObject var viewModel: AuthenticationViewModel
    private let user = GIDSignIn.sharedInstance.currentUser
    @AppStorage("email", store: .standard) var email = GIDSignIn.sharedInstance.currentUser?.profile?.email ?? ""
    @State var sivede = false
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        NavigationView{
            ZStack{
                //creazione di un elenco con l'array dichiarato e riempito nel file: File.swift
                List(userurl.prod0tti, id: \.id){i in
                    NavigationLink(
                        destination: descriz(temp: i, qnt: 0),
                        label: {row(temp: i)}
                    )
                    
                }.listStyle(GroupedListStyle())
                .navigationTitle("Marconi Bar")
                .navigationBarItems(
                    leading:
                        AsyncImage(url: viewModel.GetUser()) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .clipShape(Circle())
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 35,   maxHeight: 35, alignment: .leading)
                                         
                                case .failure:
                                    Image(systemName: "photo")
                                @unknown default:
                                    // Since the AsyncImagePhase enum isn't frozen,
                                    // we need to add this currently unused fallback
                                    // to handle any new cases that might be added
                                    // in the future:
                                    EmptyView()
                                }
                            },
                    trailing:
                        Button(action: {
                            viewModel.signOut()
                            riep.removeAll()
                            somma = 0
                        }, label: {
                            Text("Esci")
                        })
                )
            
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    NavigationLink(destination: Carrello()){
                        Image(systemName: "cart.fill")
                    }.font(.title2)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(width: 70, height: 70)
                    .background(Color("celeste"))
                    .cornerRadius(40)
                    .shadow(radius: 7)
                }.padding()
            }
                
        }
        
        }
        .onAppear(perform: {
            userurl.getData2()
            userurl.getClasse()
        })
        .alert(isPresented: $userurl.errAcc){
            Alert(
                title: Text("Utente non registrato su MarconiCloud"),
                message: Text("Prova a cambiare account oppure parlane con un amministratore"),
                dismissButton: .destructive(
                    Text("Esci"),
                    action: viewModel.signOut
                )
            )
        }
        .environmentObject(userurl)
    }
}

struct lista_Previews: PreviewProvider {
    static var previews: some View {
        lista()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(UserURLSession())
    }
}
