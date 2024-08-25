//
//  SwiftUIView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/11.
//

import SwiftUI

struct TextProgressView: View {
    var text: String
    var value: Float
    var body: some View {
        HStack {
            Text(text).font(.system(size: 50))
            
            ProgressView(value: abs(value), total: 1, label: {
                Text(value.formatted())
            })
        }
        .padding(.horizontal)
    }
}
struct MatchBuildin: View {
    @Environment(HandViewModel.self) private var model
    
    
    var body: some View {
        @Bindable var model = model
        HStack {
            VStack {
                TextProgressView(text: "👆", value: model.leftScores["👆"] ?? 0)
                TextProgressView(text: "✌️", value: model.leftScores["✌️"] ?? 0)
                TextProgressView(text: "✋", value: model.leftScores["✋"] ?? 0)
                TextProgressView(text: "👌", value: model.leftScores["👌"] ?? 0)
                    
                TextProgressView(text: "✊", value: model.leftScores["✊"] ?? 0)
                TextProgressView(text: "🤘", value: model.leftScores["🤘"] ?? 0)
                TextProgressView(text: "🤙", value: model.leftScores["🤙"] ?? 0)
                TextProgressView(text: "🫱🏿‍🫲🏻", value: model.leftScores["🫱🏿‍🫲🏻"] ?? 0)
            }
            .frame(width: 300)
            
            
            VStack(alignment: .center, spacing: 10) {
                Toggle("Start hand tracking and matching", isOn: $model.turnOnImmersiveSpace)
                    .toggleStyle(ButtonToggleStyle())
                    .font(.system(size: 16, weight: .bold))
                    .padding(.bottom, 40)
                
                Toggle("Show hand skeleton", isOn: $model.latestHandTracking.isSkeletonVisible)
                    .toggleStyle(ButtonToggleStyle())
                    .font(.system(size: 16, weight: .bold))
                    .disabled(!model.turnOnImmersiveSpace)
                    .padding(.bottom, 40)
                
                VStack {
                    Text("👆✌️✋👌\n✊🤘🤙🫱🏿‍🫲🏻")
                        .font(.system(size: 60))
                        .padding(.bottom, 20)
                    
                    Text("Try to make the same gesture,\nyou can use left or right hand")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .bold))
                }
                
            }
//            .border(.red, width: 1.0)
            
            VStack {
                TextProgressView(text: "👆", value: model.rightScores["👆"] ?? 0)
                TextProgressView(text: "✌️", value: model.rightScores["✌️"] ?? 0)
                TextProgressView(text: "✋", value: model.rightScores["✋"] ?? 0)
                TextProgressView(text: "👌", value: model.rightScores["👌"] ?? 0)
                
                TextProgressView(text: "✊", value: model.rightScores["✊"] ?? 0)
                TextProgressView(text: "🤘", value: model.rightScores["🤘"] ?? 0)
                TextProgressView(text: "🤙", value: model.rightScores["🤙"] ?? 0)
                TextProgressView(text: "🫱🏿‍🫲🏻", value: model.rightScores["🫱🏿‍🫲🏻"] ?? 0)
            }
            .frame(width: 300)
        }
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
