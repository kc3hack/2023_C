//
//  DisplayView.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI
import CalculatorCore

struct DisplayView: View {
    let get_expr_closure: ()->String
    let get_expr_pointer_closure: ()->Int
    let get_userDefaultsService: ()->PUserDefaultsService
    let font_size: CGFloat = 36
    @State var exp: String = ""
    
    var body: some View {
        ScrollView{
            /*
             let userDefaultsService = get_userDefaultsService()
            if(userDefaultsService.count>0){
                userDefaultsService.forEach{
                    Text(userDefaultsService.getString(forKey: $0.key))
                }
            }
             */
            VStack{
                let expr = get_expr_closure()
                let expr_pointer = get_expr_pointer_closure()
                
                ZStack(alignment: .leading){
                    Text(" ").font(.system(size: 12,design: .monospaced))+Text(expr).font(.system(size: font_size, design: .monospaced))+Text("|").font(.system(size: font_size)).foregroundColor(Color.clear)
                    if(expr_pointer==0){
                        Text("|").font(.system(size: font_size)).foregroundColor(Color.blue)
                    }
                    else{
                        Text(" ").font(.system(size: 12,design: .monospaced))+Text(expr.prefix(expr_pointer-1)).font(.system(size: font_size, design: .monospaced)).foregroundColor(Color.clear)+Text(" ").font(.system(size: font_size*0.875,design: .monospaced))+Text("|").font(.system(size: font_size)).foregroundColor(Color.blue)
                    }
                }.padding(.all,20)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
