//
//  VirtualCurrency_BriefConentView.swift
//  XYYHTools
//
//  Created by 细雨湮痕 on 2020/4/6.
//  Copyright © 2020 io.xiyuyanhen. All rights reserved.
//

import SwiftUI

struct VirtualCurrency_BriefConentView: View {
    
    var body: some View {
        
        ZStack {
            
            Image("BackgroundImage").aspectRatio(contentMode: .fit)
            
            VStack {
                
                Spacer()
                
                Text("细雨湮痕的工具箱")
                    .foregroundColor(Color("Main"))
                    .font(.title)
                    .fontWeight(.bold).padding(.bottom, 25)
            }
            
        }.frame(width: ScreenWidth(), height: ScreenHeight(), alignment: .bottom)
    }
}

struct VirtualCurrency_BriefConentView_Previews: PreviewProvider {
    static var previews: some View {
        
        VirtualCurrency_BriefConentView()
    }
}
