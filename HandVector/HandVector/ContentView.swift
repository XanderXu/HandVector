//
//  ContentView.swift
//  HandVector
//
//  Created by 许同学 on 2023/9/17.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ContentView: View {
    @Environment(ViewModel.self) private var model

    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    @State private var isStartTimer: Bool = false
    @State private var timeRemaining = 5
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var recordOrMatch = 0
    @State private var isStart = false
    
    // 开始计时方法
    func startTimer() {
        timeRemaining = 5
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        isStartTimer = true
    }
    // 停止计时方法
    func stopTimer() {
        timeRemaining = 5
        timer.upstream.connect().cancel()
        isStartTimer = false
        isStart = false
    }
    
    var body: some View {
        VStack {
            Model3D(named: "Scene", bundle: realityKitContentBundle)

            Toggle("Show Immersive Space", isOn: $showImmersiveSpace)
                .toggleStyle(.button)
                .padding(.top, 20)
            
            Picker("Record or match", selection: $recordOrMatch) {
                Text("Record").tag(0)
                Text("Match").tag(1)
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 300)
            .padding(.top, 20)
            .disabled((!showImmersiveSpace) || isStart)
            
            Toggle("Start!", isOn: $isStart)
                .toggleStyle(.button)
                .padding(.top, 20)
                .disabled(!showImmersiveSpace)

            if recordOrMatch == 0 {
                Text("record count down： \(timeRemaining)")
                    .padding(.top, 20)
                    .onReceive(timer) { input in
                        if !isStartTimer {return}
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            self.stopTimer()
                            model.record()
                        }
                    }
                    .disabled(!showImmersiveSpace)
            } else {
                Text("match rate Left： \(model.matchRateLeft)\nmatch rate Right： \(model.matchRateRight)")
                    .padding(.top, 20)
                    .disabled(!showImmersiveSpace)
            }
            
            
        }
        .padding()
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
                    case .opened:
                        immersiveSpaceIsShown = true
                        isStart = false
                    case .error, .userCancelled:
                        fallthrough
                    @unknown default:
                        immersiveSpaceIsShown = false
                        showImmersiveSpace = false
                    }
                } else if immersiveSpaceIsShown {
                    await dismissImmersiveSpace()
                    immersiveSpaceIsShown = false
                    self.stopTimer()
                    isStart = false
                }
            }
        }
        .onChange(of: isStart) { _, newValue in
            if newValue {
                if recordOrMatch == 0 {
                    self.startTimer()
                } else {
                    //match
                    model.isContinuousMatching = newValue
                }
            } else {
                model.isContinuousMatching = newValue
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
