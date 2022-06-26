//
//  login.swift
//  bar2
//
//  Created by Samuele Pagnotta on 16/03/22.
//

import SwiftUI
import GoogleSignIn
import Firebase

struct login: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State var animation: Double = 0
    var body: some View {
        //pagina standard del login da abbellire
        VStack{
            /*
            Image("logomarconi")
                .resizable()
                //.scaledToFit()
                .frame(width: 200, height: 200, alignment: .center)
                .padding(.bottom, 50)
             */
            
            ZStack{
                Image("logomarconiC")
                    .resizable()
                    .frame(width: 135, height: 135, alignment: .center)
                Image("logomarconiF")
                    .resizable()
                    .frame(width: 200, height: 200, alignment: .center)
                    .rotationEffect(Angle(degrees: animation))
            }.padding(.bottom, 50)
            
            Button {
                viewModel.signIn()
            } label: {
                ZStack{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 3)
                        .foregroundColor(Color("celeste"))
                        .frame(width: 300, height: 40, alignment: .center)
                    HStack{
                        Image("logomarconiC")
                            .resizable()
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("Accedi con marconicloud")
                            .foregroundColor(Color("celeste"))
                            .bold()
                            .font(.system(size: 20))
                    }
                    
                }
                
            }
            
        }
    }
}

struct login_Previews: PreviewProvider {
    static var previews: some View {
        login()
    }
}
