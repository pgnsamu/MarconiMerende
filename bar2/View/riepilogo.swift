//
//  riepilogo.swift
//  bar2
//
//  Created by Samuele Pagnotta on 05/06/22.
//

import SwiftUI

struct riepilogo: View {
    @EnvironmentObject var userurl: UserURLSession
    @EnvironmentObject var viewModel: AuthenticationViewModel
    var body: some View {
        NavigationView{
            VStack{
                List(userurl.ordini, id: \.self){ i in
                    HStack{
                        Text(String(i.id))
                        Text(String(i.qta))
                    }
                }
                NavigationLink("Acquista") {
                    lista()
                }
            }
            .navigationTitle("Ordini della tua classe")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        viewModel.signOut()
                                    }, label: {
                                        Text("Esci")
                                    })
            )
        }.refreshable {
            userurl.GetOrdini()
        }
        .onAppear {
            userurl.GetOrdini()
        }
    }
}

struct riepilogo_Previews: PreviewProvider {
    static var previews: some View {
        riepilogo()
            .environmentObject(AuthenticationViewModel())
            .environmentObject(UserURLSession())
    }
}
