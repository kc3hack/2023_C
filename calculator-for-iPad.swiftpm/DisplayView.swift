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
    let set_expr: (_: String)->Void
    let get_expr_pointer_closure: ()->Int
    let get_calc_results: ()->[String]
    let reset_calc_results: ()->Void
    let font_size: CGFloat = 48
    @State var exp: String = ""
    
    private let calculatorService: PCalculatorService = CalculatorService()
    
    var body: some View {
        VStack{
            Button(action: reset_calc_results){
                Text("↻RESET ").font(.system(size: font_size*2/3)).foregroundColor(Color.red)
            }
            VStack{
                let expr = get_expr_closure()
                let temp_result = expr.replacingOccurrences(of: "÷", with: "/").replacingOccurrences(of: "×", with: "*")
                let expr_pointer = get_expr_pointer_closure()
                ScrollView (.horizontal) {
                    ZStack(alignment: .leading){
                        Text(" ").font(.system(size: 12,design: .monospaced))+Text(expr).font(.system(size: font_size, design: .monospaced))+Text("|").font(.system(size: font_size)).foregroundColor(Color.clear)
                        if(expr_pointer==0){
                            Text("|").font(.system(size: font_size)).foregroundColor(Color.blue)
                        }
                        else{
                            Text(" ").font(.system(size: 12,design: .monospaced))+Text(expr.prefix(expr_pointer-1)).font(.system(size: font_size, design: .monospaced)).foregroundColor(Color.clear)+Text(" ").font(.system(size: font_size*0.875,design: .monospaced))+Text("|").font(.system(size: font_size)).foregroundColor(Color.blue)
                        }
                    }.padding(.all,20)
                }
                HStack{
                    Text("    "+calculatorService.calculate(rawExpression: temp_result).toDisplayString()).font(.system(size: font_size*3/4)).foregroundColor(Color.gray)
                    Spacer()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            ScrollView{
                let calc_results: [String] = get_calc_results()
                if(calc_results.count>0){
                    ForEach(0..<calc_results.count,id: \.self){
                        ridx in
                        //逆順に呼び出すためにこのように書いてる
                        let results_index = calc_results.count - 1 - ridx
                        let calc_result = calc_results[results_index];
                        HStack{
                            let split_calc = calc_result.components(separatedBy: "=")
                            Button(action: {()->Void in
                                set_expr(split_calc[0])
                            }){
                                Text(" "+split_calc[0]).font(.system(size:font_size*2/3))
                            }
                            Text("=").font(.system(size:font_size*2/3))
                            Button(action: {()->Void in
                                set_expr(split_calc[1])
                            }){
                                Text(""+split_calc[1]).font(.system(size:font_size*2/3))
                            }
                            
                            Spacer()
                        }.padding(font_size*1/8)
                    }
                }
            }
        }
    }
}
