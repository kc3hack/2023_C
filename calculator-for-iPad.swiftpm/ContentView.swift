import SwiftUI
import CalculatorCore

struct ContentView: View {
    @State private var expr = ""
    @State private var expr_pointer: Int = 0
    @State private var calc_results: [String] = []
    private let date: Date = Date()
    private let calculatorService: PCalculatorService = CalculatorService()
    private let userDefaultsService: PUserDefaultsService = UserDefaultsService()
    
    var body: some View {
        GeometryReader { geometry in
            //もし横長モードなら右側に計算用テンキー(右利き優位なので設定で左に変えれたら便利)
            if(1000<geometry.size.width){
                HStack{
                    DisplayView(get_expr_closure: get_expr,set_expr:  set_expr,get_expr_pointer_closure: get_expr_pointer, get_calc_results: get_calc_results, reset_calc_results: reset_calc_results)
                    ControllerView(onclick_closure: onckick)
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding()
            }
            else if(geometry.size.width < 400){
                VStack{
                    DisplayView(get_expr_closure: get_expr,set_expr: set_expr,  get_expr_pointer_closure: get_expr_pointer, get_calc_results: get_calc_results, reset_calc_results: reset_calc_results)
                    OtherKeys(onclick_closure: onckick)
                    MainKeys(onclick_closure: onckick)
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding()
            }
            else{
                VStack{
                    DisplayView(get_expr_closure: get_expr,set_expr: set_expr,  get_expr_pointer_closure: get_expr_pointer, get_calc_results: get_calc_results, reset_calc_results: reset_calc_results)
                    ControllerView(onclick_closure: onckick)
                }.frame(maxWidth: .infinity, maxHeight: .infinity).padding()
                
            }
        }
    }
    
    func set_expr(value: String)->Void{
        expr = value
    }
    
    func get_expr()->String{
        return expr
    }
    
    func get_expr_pointer()->Int{
        return expr_pointer
    }
    
    func get_calc_results()->[String]{
        return calc_results
    }
    
    func reset_calc_results(){
        calc_results.removeAll()
    }
    
    func onckick(push_char: String)->Void{
        let before_pointer = String(expr.prefix(expr_pointer))
        let after_pointer = String(expr.suffix(expr.unicodeScalars.count - expr_pointer))
        
        var to_be_added: String
        
        switch push_char {
        case "√":
            fallthrough
        case "abs":
            fallthrough
        case "sin":
            fallthrough
        case "cos":
            fallthrough
        case "tan":
            fallthrough
        case "arcsin":
            fallthrough
        case "arccos":
            fallthrough
        case "arctan":
            fallthrough
        case "ln":
            fallthrough
        case "log":
            //カーソルがカッコの中に来るようにする。
            expr_pointer -= 1
            to_be_added = push_char + "()"
        default:
            to_be_added = push_char
        }
        
        // =が押されたら式を評価するけど、ちょっと記憶をどうするかを考える
        if(push_char=="="){
            if(call()){
                expr = ""
                expr_pointer = 0
            }
            else{
                //エラー処理
            }
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
    
    func call()->Bool{
        let calc_result: Number = calculatorService.calculate(rawExpression: expr.replacingOccurrences(of: "÷", with: "/").replacingOccurrences(of: "×", with: "*"))
        let calc_result_string = calc_result.toDisplayString()
        let value_expr: String = expr+"="+calc_result_string
        if(calc_result_string==""){
            return false
        }
        
        calc_results.append(value_expr)
        return true
    }
}
