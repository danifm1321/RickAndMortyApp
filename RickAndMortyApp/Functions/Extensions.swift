//
//  Extensions.swift
//  RickAndMortyApp
//
//  Created by IT DEV ES on 6/9/23.
//

import Foundation
import SwiftUI

extension View {
    
    //Allows changing a view property depending on a boolean condition
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition { transform(self) }
        else { self }
    }
    
    func buttonStyle() -> some View {
        return self.padding().background(.cyan).cornerRadius(10)
    }
}
