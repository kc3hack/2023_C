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
            if(geometry.size.width<360||1000<geometry.size.width){
                VStack
                {
                    OtherKeys(onclick_closure: onclick_closure)
                    MainKeys(onclick_closure: onclick_closure)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else{
                HStack{
                    OtherKeys(onclick_closure: onclick_closure)
                    MainKeys(onclick_closure: onclick_closure)
                }.frame(maxWidth: .infinity, maxHeight: 360)
            }
        }
    }
}
