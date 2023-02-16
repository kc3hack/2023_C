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
    @State var exp: String = ""
    
    var body: some View {
        VStack{
            VStack{
                let expr = get_expr_closure()
                let expr_pointer = get_expr_pointer_closure()
                ZStack(alignment: .leading){
                    Text(" ").font(.system(size: 12,design: .monospaced))+Text(expr).font(.system(size: 48, design: .monospaced))+Text("|").font(.system(size: 48)).foregroundColor(Color.clear)
                    if(expr_pointer==0){
                        Text("|").font(.system(size: 48)).foregroundColor(Color.blue)
                    }
                    else{
                        Text(" ").font(.system(size: 12,design: .monospaced))+Text(expr.prefix(expr_pointer-1)).font(.system(size: 48, design: .monospaced)).foregroundColor(Color.clear)+Text(" ").font(.system(size: 42,design: .monospaced))+Text("|").font(.system(size: 48)).foregroundColor(Color.blue)
                    }
                }.padding(.all,20)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}