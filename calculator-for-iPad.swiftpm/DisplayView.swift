//
//  DisplayView.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI

struct DisplayView: View {
    let get_expr_closure: ()->String
    let get_expr_pointer_closure: ()->Int
    
    var body: some View {
        VStack{
            VStack{
                let expr = get_expr_closure()
                let expr_pointer = get_expr_pointer_closure()
                
                Text(expr.prefix(expr_pointer)).font(.system(size: 48))+Text("|").font(.system(size: 48)).foregroundColor(Color.blue)+Text(expr.suffix(expr.unicodeScalars.count - expr_pointer)).font(.system(size: 48))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
