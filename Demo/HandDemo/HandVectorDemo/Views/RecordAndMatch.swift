//
//  RecordAndMatch.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/4/14.
//

import SwiftUI

struct RecordAndMatch: View {
    @Environment(HandViewModel.self) private var model
    @State private var recordIndex = 0
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var countDown = -1
    var progressValue: Float {
        min(1, max(0, Float(countDown) / 3.0 + 0.001))
    }
    var body: some View {
        @Bindable var model = model
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 20) {
            Toggle("Start hand tracking", isOn: $model.turnOnImmersiveSpace)
                .toggleStyle(ButtonToggleStyle())
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 20)
            
            
            Picker("Choose Left or Right hand to recrod", selection: $recordIndex) {
                Text("Left Hand").tag(0)
                Text("Right Hand").tag(1)
                Text("Both Hands").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.bottom, 20)
            
            Button {
                countDown = 3
            } label: {
                Text("Read to record")
                    .font(.system(size: 16, weight: .bold))
            }

            
            Text(verbatim: "\(countDown < 0 ? 3 : countDown)")
                .animation(.none, value: progressValue)
                .font(.system(size: 64))
                .bold()
            Group {
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
        .onReceive(timer) { _ in
            if countDown > 0 {
                countDown -= 1
            } else if countDown == 0 {
                countDown = -1
                switch recordIndex {
                case 0:
                    break
                case 1:
                    break
                case 2:
                    break
                default:
                    break
                }
                
            }
        }
    }
}

#Preview {
    RecordAndMatch()
}
