//
//  RecordAndMatch.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/4/14.
//

import SwiftUI
import HandVector

struct RecordAndMatch: View {
    @Environment(HandViewModel.self) private var model
    @State private var recordIndex = 0
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var countDown = -1
    
    @State private var jsonString: String?
    @State private var showJsonSheet: Bool = false
    
    var progressValue: Float {
        min(1, max(0, Float(countDown) / 3.0 + 0.001))
    }
    
    var body: some View {
        @Bindable var model = model
        VStack(alignment: .center, spacing: 20) {
            Toggle("Start hand tracking", isOn: $model.turnOnImmersiveSpace)
                .toggleStyle(ButtonToggleStyle())
                .font(.system(size: 16, weight: .bold))
                .padding(.bottom, 20)
            
            Toggle("Show hand skeleton", isOn: $model.latestHandTracking.isSkeletonVisible)
                .toggleStyle(ButtonToggleStyle())
                .font(.system(size: 16, weight: .bold))
                .disabled(!model.turnOnImmersiveSpace)
            
            Group {
                Picker("Choose Left or Right hand to recrod", selection: $recordIndex) {
                    Text("Left Hand").tag(0)
                    Text("Right Hand").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 10)
                
                Button {
                    countDown = 3
                } label: {
                    Text("Ready to record")
                        .font(.system(size: 16, weight: .bold))
                }
                .disabled(countDown > -1 || !model.turnOnImmersiveSpace)

                
                Text(verbatim: countDown < 0 ? "..." : "\(countDown)")
                    .animation(.none, value: progressValue)
                    .font(.system(size: 64))
                    .bold()
                    .padding(.bottom, 30)
            }
            
            
            Group {
                HStack {
                    Text("left score:\(model.leftScore)")
                        .frame(width: 200)
                        .accessibilityHidden(true)
                    Text("right score:\(model.rightScore)")
                        .frame(width: 200)
                        .accessibilityHidden(true)
                }
                
                Button {
                    showJsonSheet = true
                } label: {
                    Text("Check recorded json string")
                        .font(.system(size: 16, weight: .bold))
                }
                .disabled(jsonString?.isEmpty ?? true)
                .sheet(isPresented: $showJsonSheet) {
                    VStack {
                        ScrollView {
                            Text(verbatim: jsonString ?? "")
                                .padding(20)
                                .contextMenu {
                                    Button(action: {
                                        UIPasteboard.general.string = jsonString
                                    }) {
                                        Text("Copy")
                                        Image(systemName: "doc.on.doc")
                                    }
                                }
                                .onLongPressGesture { // Add Long Press Gesture
                                    UIPasteboard.general.string = jsonString // Copy to the clipboard
                                }
                        }
                        
                        Button("OK", role: .cancel) {
                            showJsonSheet = false
                        }
                        
                        Text("Long press to copy json string")
                        .padding(.bottom, 20)
                    }
                    .frame(minHeight: 600)
                }
                
            }
            .font(.system(size: 16, weight: .bold))
            .frame(width: 280)
        }
        .frame(width: 400)
        .onReceive(timer) { _ in
            if !model.turnOnImmersiveSpace {
                return
            }
            if countDown > 0 {
                countDown -= 1
            } else if countDown == 0 {
                countDown = -1
                switch recordIndex {
                case 0:
                    if let left = model.latestHandTracking.leftHandVector {
                        let para = HVHandJsonModel.generateJsonModel(name: "left", handVector: left)
                        model.recordHand = left
                        jsonString = para.toJson()
                    }
                case 1:
                    if let right = model.latestHandTracking.rightHandVector {
                        let para = HVHandJsonModel.generateJsonModel(name: "right", handVector: right)
                        model.recordHand = right
                        jsonString = para.toJson()
                    }
                
                default:
                    break
                }
                
            }
        }
        .onAppear {
            if let para = model.recordHand {
                jsonString = para.toJson()
            }
        }
    }
}

#Preview {
    RecordAndMatch()
}
