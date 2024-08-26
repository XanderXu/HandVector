//
//  HandVectorView.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/4/14.
//

import SwiftUI

struct HandVectorView: View {
    @State private var selectedModule: Module = .matchAllBuiltinHands
    
    @Environment(HandViewModel.self) private var model
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        NavigationSplitView {
            List(Module.allCases) { module in
                Button(action: {
                    selectedModule = module
                }, label: {
                    Text(module.name)
                })
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 8)
                        .background(Color.clear)
                        .foregroundColor((module == selectedModule) ? Color.teal.opacity(0.3) : .clear)
                )
                
            }
            .navigationTitle("Hand Vector Demo")
        } detail: {
            switch selectedModule {
            case .matchAllBuiltinHands:
                MatchAllBuiltin()
                    .navigationTitle(selectedModule.name)
            case .recordAndMatchHand:
                RecordAndMatch()
                    .navigationTitle(selectedModule.name)
            case .calculateFingerShape:
                FingerShape()
                    .navigationTitle(selectedModule.name)
            }
            
        }
        .frame(minWidth: 800, minHeight: 500)
        .onChange(of: selectedModule) { _, newValue in
            Task {
                if model.turnOnImmersiveSpace {
                    model.turnOnImmersiveSpace = false
                }
            }
        }
        .onChange(of: model.turnOnImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: selectedModule.immersiveId)
                } else {
                    await dismissImmersiveSpace()
                    model.reset()
                }
            }
        }
    }
}

#Preview {
    HandVectorView()
}
