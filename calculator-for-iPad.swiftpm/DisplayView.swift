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
    let replacing_symbols: (_:String)->String
    let font_size: CGFloat = 48
    @State var exp: String = ""
    
    private let calculatorService: PCalculatorService = CalculatorService()
    
    var body: some View {
        VStack{
            Button(action: reset_calc_results){
                Text("↻RESET ").font(.system(size: font_size*2/3)).foregroundColor(Color.red)
            }
            VStack{
                let expr: String = get_expr_closure()
                let expr_pointer: Int = get_expr_pointer_closure()
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
                    Text("    "+calculatorService.calculate(rawExpression: replacing_symbols(expr)).toDisplayString()).font(.system(size: font_size*3/4)).foregroundColor(Color.gray)
                    Spacer()
                }
            }
            ScrollView{
                let calc_results: [String] = get_calc_results()
                if(calc_results.count>0){
                    ForEach(0..<calc_results.count,id: \.self){
                        ridx in
                        //逆順に呼び出すためにこのように書いてる
                        let results_index = calc_results.count - 1 - ridx
                        let calc_result = calc_results[results_index];
                        HStack{
                            VStack{
                                let split_calc = calc_result.components(separatedBy: "=")
                                HStack{
                                    Button(action: {()->Void in
                                        set_expr(split_calc[0])
                                    }){
                                        Text(" "+split_calc[0]).font(.system(size:font_size*2/3))
                                    }
                                    Spacer()
                                }
                                HStack{
                                    Text("  =").font(.system(size:font_size*2/3))
                                    Button(action: {()->Void in
                                        set_expr(split_calc[1])
                                    }){
                                        Text(""+split_calc[1]).font(.system(size:font_size*2/3))
                                    }
                                    Spacer()
                                }
                            }
                            Spacer()
                        }.padding(font_size*1/8)
                    }
                }
            }
        }
    }
}
