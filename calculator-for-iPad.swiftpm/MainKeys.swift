//
//  MainKeys.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI

struct MainKeys: View {
    let onclick_closure: (String)->Void
    // keyとactionの対応させたもの
    private let key_array = [
        ["AC","◀︎","▶︎",],
        ["7","8","9","+",],
        ["4","5","6","-",],
        ["1","2","3","×",],
        ["0",".","=","/",],
    ]
    
    var body: some View {
        VStack{
            ForEach((0...(key_array.count-1)),id: \.self){
                index_r in
                let main_key_array_row = key_array[index_r]
                HStack {
                    ForEach((0...(main_key_array_row.count-1)),id: \.self){
                        index_c in
                        let key_char = main_key_array_row[index_c]
                        // ボタンの生成
                        Button(action: {()->Void in
                            onckick(push_char: key_char)
                        }){
                            Text(key_char)
                                .font(.system(size: 48))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.cyan)
                            .foregroundColor(Color.black)
                    }
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func onckick(push_char: String)->Void{
        onclick_closure(push_char)
    }
}
