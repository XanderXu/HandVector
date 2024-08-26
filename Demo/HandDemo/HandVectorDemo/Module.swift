/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The modules that the app can present.
*/


import Foundation
import SwiftUI

/// A description of the modules that the app can present.
enum Module: String, Identifiable, CaseIterable, Equatable {
    case matchAllBuiltinHands
    case recordAndMatchHand
    case calculateFingerShape
    
    var id: Self { self }
    var name: LocalizedStringKey {
        LocalizedStringKey(rawValue)
    }

    var immersiveId: String {
        self.rawValue + "ID"
    }

}
