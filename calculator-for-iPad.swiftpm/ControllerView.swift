//
//  ControllerView.swift
//  calculator-for-iPad
//
//  Created by 紀仁 on 2023/02/14.
//

import SwiftUI

struct ControllerView: View {
    let onclick_closure: (String)->Void
    
    var body: some View {
        GeometryReader { geometry in
            //ここら辺の数字がマジックナンバーになてしまってる。
            if(geometry.size.width < 600){
                VStack
                {
                    OtherKeys(onclick_closure: onclick_closure)
                    MainKeys(onclick_closure: onclick_closure)
                }
            }
            else{
                HStack{
                    OtherKeys(onclick_closure: onclick_closure)
                    MainKeys(onclick_closure: onclick_closure)
                }
            }
        }
    }
}
