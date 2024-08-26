//
//  FingerShape.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/8/26.
//

import SwiftUI

struct FingerShape: View {
    struct TextProgressView: View {
        var text: String
        var value: Float
        var body: some View {
            HStack {
                Text(text)
                    .font(.system(size: 20))
                    .frame(width: 120)
                
                ProgressView(value: abs(value), total: 1, label: {
                    Text(value.formatted())
                })
            }
            .padding()
        }
    }
    @Environment(HandViewModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        HStack {
            VStack {
                let leftScores = model.averageAndEachLeftScores
                TextProgressView(text: "thumb", value: leftScores?.eachFinger[.thumb] ?? 0)
                TextProgressView(text: "indexFinger", value: leftScores?.eachFinger[.indexFinger] ?? 0)
                TextProgressView(text: "middleFinger", value: leftScores?.eachFinger[.middleFinger] ?? 0)
                TextProgressView(text: "ringFinger", value: leftScores?.eachFinger[.ringFinger] ?? 0)
                TextProgressView(text: "littleFinger", value: leftScores?.eachFinger[.littleFinger] ?? 0)
            }
            .frame(width: 350)
            
            
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
                
                
            }
            //            .border(.red, width: 1.0)
            
            
            VStack {
                let rightScores = model.averageAndEachRightScores
                TextProgressView(text: "thumb", value: rightScores?.eachFinger[.thumb] ?? 0)
                TextProgressView(text: "indexFinger", value: rightScores?.eachFinger[.indexFinger] ?? 0)
                TextProgressView(text: "middleFinger", value: rightScores?.eachFinger[.middleFinger] ?? 0)
                TextProgressView(text: "ringFinger", value: rightScores?.eachFinger[.ringFinger] ?? 0)
                TextProgressView(text: "littleFinger", value: rightScores?.eachFinger[.littleFinger] ?? 0)
            }
            .frame(width: 350)
        }
    }
}

#Preview {
    FingerShape()
}
