//
//  row.swift
//  bar2
//
//  Created by Samuele Pagnotta on 16/03/22.
//

import SwiftUI

struct row: View {
    var temp: prodotto
    var body: some View {
        HStack{
            //minimo indispensabile per la personalizzazione delle righe
            Text("\(temp.des)")
            Text("\(temp.price)").fontWeight(.light)
        }
    }
}

struct row_Previews: PreviewProvider {
    static var previews: some View {
        row(temp: array[1])
    }
}
