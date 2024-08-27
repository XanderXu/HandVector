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
                    .font(.system(size: 16))
                    .frame(width: 80)
//                    .border(.yellow, width: 1)
                
                ProgressView(value: abs(value), total: 1, label: {
                    Text(value.formatted())
                        .font(.system(size: 10))
                })
            }
//            .border(.black, width: 1)
        }
    }
    @Environment(HandViewModel.self) private var model
    
    var body: some View {
        @Bindable var model = model
        HStack(spacing: 10) {
            VStack {
                let fingerShapes = model.leftFingerShapes
                Spacer()
                HStack {
                    Text("thumb").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.thumb]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.thumb]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.thumb]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.thumb]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.thumb]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("index").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.indexFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.indexFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.indexFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.indexFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.indexFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("middle").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.middleFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.middleFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.middleFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.middleFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.middleFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("ring").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.ringFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.ringFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.ringFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.ringFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.ringFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("little").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.littleFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.littleFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.littleFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.littleFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.littleFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
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
                let fingerShapes = model.rightFingerShapes
                Spacer()
                HStack {
                    Text("thumb").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.thumb]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.thumb]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.thumb]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.thumb]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.thumb]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("index").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.indexFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.indexFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.indexFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.indexFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.indexFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("middle").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.middleFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.middleFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.middleFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.middleFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.middleFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("ring").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.ringFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.ringFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.ringFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.ringFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.ringFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
                
                HStack {
                    Text("little").frame(width: 65)
                    VStack {
                        TextProgressView(text: "fullCurl", value: fingerShapes[.littleFinger]?.fullCurl ?? 0)
                        TextProgressView(text: "baseCurl", value: fingerShapes[.littleFinger]?.baseCurl ?? 0)
                        TextProgressView(text: "tipCurl", value: fingerShapes[.littleFinger]?.tipCurl ?? 0)
                        TextProgressView(text: "pinch", value: fingerShapes[.littleFinger]?.pinch ?? 0)
                        TextProgressView(text: "spread", value: fingerShapes[.littleFinger]?.spread ?? 0)
                    }
                }
                .background()
                Spacer()
            }
            .frame(width: 350)
        }
    }
}

#Preview {
    FingerShape()
}
