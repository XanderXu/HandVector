//
//  SwiftUIView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/11.
//

import SwiftUI

struct MatchBuildin: View {
    @Environment(HandViewModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 10) {
            Toggle("Start hand tracking and matching", isOn: $model.turnOnImmersiveSpace)
                .toggleStyle(ButtonToggleStyle())
                .font(.system(size: 16, weight: .bold))
            
            VStack {
                Text("👌")
                    .font(.system(size: 100))
                    .frame(width: 480)
                Text("Try to make the same gesture,\nyou can use left or right hand")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 480)
            }
            
            
            Group {
                HStack {
                    Text("👌")
                        .scaleEffect(x: -1, y: 1, anchor: .center)
                        .font(.system(size: 150))
                        .frame(width: 200, height: 200)
                    
                    Text("👌")
                        .font(.system(size: 150))
                        .frame(width: 200, height: 200)
                        
                }
                HStack {
                    Text("left score:\(model.leftScore)")
                        .frame(width: 200)
                        .accessibilityHidden(true)
                    Text("right score:\(model.rightScore)")
                        .frame(width: 200)
                        .accessibilityHidden(true)
                }
                
                
            }
            .font(.system(size: 16, weight: .bold))
            .frame(width: 280)
        }
        .frame(width: 400)
    }
    
}

#Preview {
    MatchBuildin()
        .environment(HandViewModel())
        .glassBackgroundEffect(
            in: RoundedRectangle(
                cornerRadius: 32,
                style: .continuous
            )
        )
}
