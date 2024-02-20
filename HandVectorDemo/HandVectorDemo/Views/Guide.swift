//
//  SwiftUIView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/11.
//

import SwiftUI

struct Guide: View {
    @Environment(ViewModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        VStack(spacing: 10) {
            HStack(alignment: .top) {
                Spacer()
                VStack {
                    Text("👌")
                        .font(.system(size: 150))
                        .frame(width: 480)
                    Text("Try to make the same gesture,\nyou can use left or right hand")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 480)
                }
                .padding(.leading, 0)
                .padding(.trailing, 60)
            }
            .padding(.top, 20)
            Group {
                HStack {
                    Image("leftOK")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .accessibilityHidden(true)
                    Image("rightOK")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .accessibilityHidden(true)
                }
                HStack {
                    Text("left score:\(model.leftScore)")
                        .frame(width: 200)
                        .accessibilityHidden(true)
                    Text("right score:\(model.rightScore)")
                        .frame(width: 200)
                        .accessibilityHidden(true)
                }
                
                Toggle("Test with my real hands", isOn: $model.showGuideImmersiveSpace)
                    .toggleStyle(ButtonToggleStyle())
                    .padding(.vertical, 30)
            }
            .font(.system(size: 16, weight: .bold))
            .frame(width: 280)
        }
        .padding(.horizontal, 150)
        .frame(width: 400)
    }
}

#Preview {
    Guide()
        .environment(ViewModel())
        .glassBackgroundEffect(
            in: RoundedRectangle(
                cornerRadius: 32,
                style: .continuous
            )
        )
}
