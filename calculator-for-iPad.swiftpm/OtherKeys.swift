//
//  OtherKeys.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI

struct OtherKeys: View {
    let onclick_closure: (String)->Void
    let font_size: CGFloat = 32
    // keyとactionの対応させたもの
    // ContentViewも変更
    private let key_array = [
        ["()","e","π",],
        ["mod","^","√"],
        ["abs","ln","log"],
        ["sin","cos","tan"],
        ["sin⁻¹","cos⁻¹","tan⁻¹"],
    ]
    
    var body: some View {
        ForEach((0..<key_array.count),id: \.self){
            index_r in
            let main_key_array_row = key_array[index_r]
            HStack {
                ForEach((0..<main_key_array_row.count),id: \.self){
                    index_c in
                    let key_char = main_key_array_row[index_c]
                    // ボタンの生成
                    Button(action: {()->Void in
                        onckick(push_char: key_char)
                    }){
                        Text(key_char)
                            .font(.system(size: font_size))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .background(Color(red:0.8, green:0.9, blue:0.95))
                    .foregroundColor(Color.black)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    func onckick(push_char: String)->Void{
        onclick_closure(push_char)
    }
}
