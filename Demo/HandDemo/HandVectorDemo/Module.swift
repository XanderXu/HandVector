/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The modules that the app can present.
*/


import Foundation

/// A description of the modules that the app can present.
enum Module: String, Identifiable, CaseIterable, Equatable {
    case matchBuildin
    case recordNew
    case matchNew
    
    var id: Self { self }
    var name: String { rawValue.capitalized }

    var immersiveId: String {
        self.rawValue + "ID"
    }

}
