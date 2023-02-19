//
//  ControllerView.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI

struct ControllerView: View {
    @State private var is_main_mode = true
    
    let onclick_closure: (String)->Void
    
    var body: some View {
        GeometryReader { geometry in
            //ここら辺の数字がマジックナンバーになてしまってる。
            if(geometry.size.width < 600){
                if(600 < geometry.size.height){
                    VStack{
                        VStack{
                            OtherKeys(onclick_closure: onclick_closure)
                        }
                        MainKeys(onclick_closure: onclick_closure)
                    }
                }
                else{
                    VStack{
                        Toggle(isOn: $is_main_mode) {
                            Text(is_main_mode ? "Func" : "Num").font(.system(size:24))
                        }.toggleStyle(.button)
                        if(is_main_mode){
                            MainKeys(onclick_closure: onclick_closure)
                        }
                        else{
                            VStack{
                                OtherKeys(onclick_closure: onclick_closure)
                            }
                        }
                    }
                }
                
            }
            else{
                HStack{
                    VStack{
                        OtherKeys(onclick_closure: onclick_closure)
                    }
                    MainKeys(onclick_closure: onclick_closure)
                }
            }
        }
    }
}
