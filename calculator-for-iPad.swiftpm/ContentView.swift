import SwiftUI

struct ContentView: View {
    @State private var expr = ""
    @State private var expr_pointer: Int = 0

    // keyとactionの対応させたもの
    private let main_key_array = [
        [
            "AC",
            "◀︎",
            "▶︎",
        ],
        [
            "7",
            "8",
            "9",
            "+",
        ],
        [
            "4",
            "5",
            "6",
            "-",
        ],
        [
            "1",
            "2",
            "3",
            "×",
        ],
        [
            "0",
            ".",
            "=",
            "/",
        ],
    ]
    
    
    
    var body: some View {
        VStack{
            VStack{
                Text(expr.prefix(expr_pointer)).font(.system(size: 48))+Text("|").font(.system(size: 48)).foregroundColor(Color.blue)+Text(expr.suffix(expr.unicodeScalars.count - expr_pointer)).font(.system(size: 48))
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            HStack{
                VStack{
                    
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                //このVStackをメソッドに分離したい
                VStack{
                    ForEach((0...(main_key_array.count-1)),id: \.self){
                        index_r in
                        let main_key_array_row = main_key_array[index_r]
                        HStack {
                            ForEach((0...(main_key_array_row.count-1)),id: \.self){
                                index_c in
                                let key_char = main_key_array_row[index_c]
                                // ボタンの生成
                                Button(action: {()->Void in
                                    ckick(push_char: key_char)
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
                
                
            }.frame(maxWidth: .infinity, maxHeight: 360)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func ckick(push_char: String)->Void{
        let before_pointer = String(expr.prefix(expr_pointer))
        let after_pointer = String(expr.suffix(expr.unicodeScalars.count - expr_pointer))
        
        // =が押されたら式を評価するけど、ちょっと記憶をどうするかを考える
        if(push_char=="="){
            call()
            expr = ""
            expr_pointer = 0
        }
        else if(push_char=="AC"){
            expr = ""
            expr_pointer = 0
        }
        else if(push_char=="◀︎"){
            expr_pointer = expr_pointer==0 ? 0 : expr_pointer-1
        }
        else if(push_char=="▶︎"){
            expr_pointer = expr_pointer==expr.unicodeScalars.count ? expr_pointer : expr_pointer+1
        }
        else{
            expr = before_pointer + push_char + after_pointer
            expr_pointer += 1
        }
    }
    
    func call()->Void{
        //ここに呼び出しを書く
    }
}
