//
//  Spinner.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 19/07/2023.
//

import SwiftUI

struct Spinner: View {
    var body: some View {
        VStack(spacing: 15) {
            ProgressView()
                .tint(Color.white)
                .controlSize(.large)
            Text(Constants.spinnerMessage)
                .foregroundColor(.white)
            
        }
        .frame(width: 200, height: 200, alignment: .center)
        .background(Color(red: 29/255, green: 24/255, blue: 12/255).opacity(0.5))
        .cornerRadius(15)
    }
}

struct Spinner_Previews: PreviewProvider {
    @State static var show: Bool = true
    static var previews: some View {
        Spinner()
    }
}
