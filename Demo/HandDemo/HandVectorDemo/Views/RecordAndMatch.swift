//
//  RecordAndMatch.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/4/14.
//

import SwiftUI
import HandVector

struct RecordAndMatch: View {
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
                
                
                
                Group {
                    Picker("Choose Left or Right hand to recrod", selection: $recordIndex) {
                        Text("Left Hand").tag(0)
                        Text("Right Hand").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.bottom, 20)
                    .frame(width: 300)
                    
                    
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
//                .border(.green, width: 1.0)
                
                
                Group {
                    HStack {
                        
                        Text("left score:\(model.averageAndEachLeftScores?.average.formatted(.number.precision(.fractionLength(4))) ?? "0")")
                            .frame(width: 150)
                        Text("right score:\(model.averageAndEachRightScores?.average.formatted(.number.precision(.fractionLength(4))) ?? "0")")
                            .frame(width: 150)
                    }
                    .padding(.bottom, 30)
                    
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
                                    .padding()
                            }
                            
                            HStack(spacing: 10) {
                                Button(action: {
                                    showJsonSheet = false
                                }) {
                                    Text("OK")
                                    Image(systemName: "xmark.circle")
                                }
                                
                                Button(action: {
                                    UIPasteboard.general.string = jsonString
                                }) {
                                    Text("Copy")
                                    Image(systemName: "doc.on.doc")
                                }
                            }
                            .padding(.vertical)
                        }
                        .frame(minHeight: 600)
                    }
                    
                }
                .font(.system(size: 16, weight: .bold))
//                .border(.green, width: 1.0)
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
            if let hand = model.recordHand {
                let para = HVHandJsonModel.generateJsonModel(name: hand.chirality.codableName.rawValue, handVector: hand)
                jsonString = para.toJson()
            }
        }
    }
}

#Preview {
    RecordAndMatch()
}
