//
//  Carrello.swift
//  bar2
//
//  Created by Samuele Pagnotta on 16/03/22.
//

import SwiftUI

struct Carrello: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var userurl: UserURLSession
    //@State var sivede = false
    var body: some View {
        if riep.count == userurl.carrello.count {
            VStack{
                List{
                    ForEach(riep, id: \.id){ i in
                        HStack{
                            Text("\(i.num)")
                            Text("\(i.des)")
                            Spacer()
                            Text("\(String(format: "%.2f", i.price)) €")
                        }.padding()
                    }.onDelete { i in
                        userurl.removeprod(index: i)
                        riep.remove(atOffsets: i)
                        somma = 0
                    }
                }
                
                Spacer()
                Text("\(String(format: "%.2f", somma)) €").bold()
                Button {
                    userurl.invio()
                    //userurl.insertData()
                } label: {
                    Text("invia ordine")
                }.padding(10.0)
            }.alert(isPresented: $userurl.sivede){
                Alert(title: Text(userurl.msg.msg), message: Text(""), dismissButton: .default(Text("okkey"))
                )
            }
        }
    }
}

struct Carrello_Previews: PreviewProvider {
    static var previews: some View {
        Carrello().environmentObject(AuthenticationViewModel())
            .environmentObject(UserURLSession())
    }
}
