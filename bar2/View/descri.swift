//
//  descri.swift
//  bar2
//
//  Created by Samuele Pagnotta on 16/03/22.
//

import SwiftUI


struct descriz: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var userurl: UserURLSession
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var temp: prodotto
    @State var qnt: Int
    @State var confermato: Bool = false
    var body: some View {
        VStack{
            Stepper(value: $qnt) {
                Text("Quantità")
            }
            HStack{
                Spacer()
                Text("\(qnt)")
            }

            let prezzo: Double = (temp.price as NSString).doubleValue
            let fin: Double = Double(qnt) * prezzo
            let prodotto: elemento = elemento(id: Int(temp.id) ?? 0, qta: qnt)
            Text("\(String(format: "%.2f", fin)) €")
            Spacer()
            Button(action: {
                if(prodotto.qta != 0){
                    var a: Int = 0
                    var ctrl: Bool = true
                    var nvprd: elemento = prodotto
                    for i in userurl.carrello{
                        if(prodotto.id == i.id ){
                            if((prodotto.qta + i.qta)>0){
                                nvprd = elemento(id: prodotto.id, qta: (prodotto.qta+i.qta))
                                userurl.carrello.remove(at: a)
                                riep.remove(at: a)
                                print("a")
                            }else{
                                ctrl = false
                                userurl.carrello.remove(at: a)
                                riep.remove(at: a)
                                print("b")
                            }
                        }
                       a += 1
                    }
                    if(ctrl){
                        if(nvprd.qta > 0){
                            riep.append(Cart(id: nvprd.id, des: temp.des, price: (Double(nvprd.qta) * Double(temp.price)!), num: nvprd.qta))
                            userurl.addChart(qta: nvprd.qta, id: nvprd.id)
                        }
                    }
                    
                }
                somma = Checkout(riep: riep)
                self.mode.wrappedValue.dismiss()
            }, label: {
                Text("Conferma")
            })
            NavigationLink(destination: lista()
                            .navigationBarHidden(true),
                           isActive: $confermato){EmptyView()}
                .navigationBarTitle(temp.des, displayMode: .inline)
        }.padding()
    }
}

struct descri_Previews: PreviewProvider {
    static var previews: some View {
        descriz(temp: array[1], qnt: 1).environmentObject(AuthenticationViewModel())
            .environmentObject(UserURLSession())
    }
}
