//
//  HandVectorView.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/4/14.
//

import SwiftUI

struct HandVectorView: View {
    @State private var selectedModule: Module = .matchBuildin
    
    @Environment(HandViewModel.self) private var model
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        NavigationSplitView {
            List(Module.allCases) { module in
                Button(action: {
                    selectedModule = module
                }, label: {
                    Text(module.rawValue)
                })
//                .buttonStyle((module == selectedModule) ? .borderedProminent : .borderless)
//                .buttonStyle(.borderless)
                
            }
            .navigationTitle("Hand Vector Demo")
        } detail: {
            switch selectedModule {
            case .matchBuildin:
                MatchBuildin()
                    .navigationTitle(selectedModule.name)
            case .recordNew:
                Text(selectedModule.rawValue)
                    .navigationTitle(selectedModule.name)
            case .matchNew:
                Text(selectedModule.rawValue)
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
