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
                    DisplayView(get_expr_closure: get_expr,set_expr:  set_expr,get_expr_pointer_closure: get_expr_pointer, get_calc_results: get_calc_results, reset_calc_results: reset_calc_results, replacing_symbols: replacing_symbols)
                    ControllerView(onclick_closure: onckick)
                }.padding()
            }
            else{
                VStack{
                    DisplayView(get_expr_closure: get_expr,set_expr: set_expr,  get_expr_pointer_closure: get_expr_pointer, get_calc_results: get_calc_results, reset_calc_results: reset_calc_results, replacing_symbols: replacing_symbols)
                    ControllerView(onclick_closure: onckick)
                }.padding()
            }
        }
    }
    
    func set_expr(value: String)->Void{
        expr = value
        expr_pointer = value.unicodeScalars.count
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
        
        // 括弧をつけるリスト
        let parentheses_list = ["√","abs","sin","cos","tan","arcsin","arccos","arctan","ln","log","sin⁻¹","cos⁻¹","tan⁻¹"]
        
        if parentheses_list.contains(push_char) {
            expr_pointer -= 1
            to_be_added = push_char + "()"
        }
        else{
            to_be_added = push_char
            //もしこれが括弧ならポインターを移動する
            if(push_char=="()"){
                expr_pointer -= 1
            }
        }
        
        // =が押されたら式を評価するけど、ちょっと記憶をどうするかを考える
        if(push_char=="="){
            let result_str=call()
            if(result_str != ""){
                expr = result_str
                expr_pointer = result_str.unicodeScalars.count
            }
        }
        else if(push_char=="AC"){
            expr = ""
            expr_pointer = 0
        }
        else if(push_char=="⌫"){
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
    
    public func replacing_symbols(expr: String)->String{
        let replace_list = [["÷","/",],["×","*",],["sin⁻¹","arcsin",],["cos⁻¹","arccos",],["tan⁻¹","arctan",],]
        var expr_string = expr
        
        replace_list.forEach { pair in
            expr_string = expr_string.replacingOccurrences(of: pair[0], with: pair[1])
        }

        return expr_string
    }
    
    func call()->String{
        let calc_result: Number = calculatorService.calculate(rawExpression: replacing_symbols(expr: expr))
        let calc_result_string = calc_result.toDisplayString()
        let value_expr: String = expr+"="+calc_result_string
        if(calc_result_string != ""){
            calc_results.append(value_expr)

        }
        return calc_result.toReal().toDisplayString()
    }
}
