import SwiftUI
import CalculatorCore

struct ContentView: View {
    @State private var expr = ""
    @State private var expr_pointer: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            //もし横長モードなら右側に計算用テンキー(右利き優位なので設定で左に変えれたら便利)
            if(1000<geometry.size.width){
                HStack{
                    DisplayView(get_expr_closure: get_expr, get_expr_pointer_closure: get_expr_pointer)
                    ControllerView(onclick_closure: onckick)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else if(geometry.size.width < 400){
                VStack{
                    DisplayView(get_expr_closure: get_expr, get_expr_pointer_closure: get_expr_pointer)
                    OtherKeys(onclick_closure: onckick)
                    MainKeys(onclick_closure: onckick)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else{
                VStack{
                    DisplayView(get_expr_closure: get_expr, get_expr_pointer_closure: get_expr_pointer)
                    ControllerView(onclick_closure: onckick)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    func get_expr()->String{
        return expr
    }
    
    func get_expr_pointer()->Int{
        return expr_pointer
    }
    
    func onckick(push_char: String)->Void{
        let before_pointer = String(expr.prefix(expr_pointer))
        let after_pointer = String(expr.suffix(expr.unicodeScalars.count - expr_pointer))
        
        var to_be_added: String
        
        switch push_char {
        case "÷":
            to_be_added="/"
        case "mod":
            fallthrough
        case "sin":
            fallthrough
        case "cos":
            fallthrough
        case "tan":
            fallthrough
        case "logE":
            fallthrough
        case "log2":
            fallthrough
        case "log10":
            to_be_added = push_char + "()"
        default:
            to_be_added = push_char
        }
        
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
        else if(push_char=="BS"){
            //BSが文字として追加されないようにBSは問答無用でここに入る
            if(0<expr_pointer){
                expr = expr.prefix(expr_pointer-1) + after_pointer
                expr_pointer -= 1
            }
        }
        else if(push_char=="◀︎"){
            expr_pointer = expr_pointer==0 ? 0 : expr_pointer-1
        }
        else if(push_char=="▶︎"){
            expr_pointer = expr_pointer==expr.unicodeScalars.count ? expr_pointer : expr_pointer+1
        }
        else{
            expr = before_pointer + to_be_added + after_pointer
            expr_pointer += to_be_added.unicodeScalars.count
        }
    }
    
    func call()->Void{
        //PCalculatorService.calculate(expr)
    }
}
