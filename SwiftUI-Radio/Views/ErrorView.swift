//
//  ErrorView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 24/07/2023.
//

import SwiftUI

struct ErrorView: View {
    
    var onUpdateTapped: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 15) {
            Text(Constants.notFoundMessage)
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold))
            Image.antennaSlashed
                .font(.system(size: 40, weight: .bold))
            Button(Constants.updateButtonTitle) {
                onUpdateTapped?()
            }
            .font(.system(size: 30, weight: .bold))
        }
        .foregroundColor(Color(hex: Utilities.defaultTheme.secondColor))
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
