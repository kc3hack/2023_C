//
//  MainKeys.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI

struct MainKeys: View {
    let onclick_closure: (String)->Void
    let font_size: CGFloat = 36
    // keyとactionの対応させたもの
    private let key_array = [
        ["AC","◀︎","▶︎","⌫",],
        ["7","8","9","+",],
        ["4","5","6","-",],
        ["1","2","3","×",],
        ["0",".","=","÷",],
    ]
    
    var body: some View {
        VStack{
            ForEach((0..<key_array.count),id: \.self){
                index_r in
                let main_key_array_row = key_array[index_r]
                HStack {
                    ForEach((0..<main_key_array_row.count),id: \.self){
                        index_c in
                        let key_char = main_key_array_row[index_c]
                        let is_number = Int(key_char) != nil
                        // ボタンの生成
                        Button(action: {()->Void in
                            onckick(push_char: key_char)
                        }){
                            Text(key_char)
                                .font(.system(size: font_size))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .background(is_number ? Color(red:0.8, green:0.8, blue:0.8) : Color(red:0.8, green:0.9, blue:0.95))
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func onckick(push_char: String)->Void{
        onclick_closure(push_char)
    }
}
