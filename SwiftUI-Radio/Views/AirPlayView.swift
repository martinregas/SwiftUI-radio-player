//
//  AirPlayView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 24/07/2023.
//

import SwiftUI
import AVKit

struct AirPlayView: UIViewRepresentable {
    
    private let routePickerView = AVRoutePickerView()
    
    var color: Color = .white

    func makeUIView(context: UIViewRepresentableContext<AirPlayView>) -> UIView {
        UIView()
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AirPlayView>) {
        routePickerView.tintColor = UIColor(color.opacity(0.4))
        routePickerView.activeTintColor = UIColor(color)
        routePickerView.backgroundColor = .clear
        routePickerView.contentMode = .scaleAspectFill
        routePickerView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(routePickerView)

        NSLayoutConstraint.activate([
            routePickerView.topAnchor.constraint(equalTo: uiView.safeAreaLayoutGuide.topAnchor, constant: -10),
            routePickerView.leadingAnchor.constraint(equalTo: uiView.safeAreaLayoutGuide.leadingAnchor, constant: -10),
            routePickerView.bottomAnchor.constraint(equalTo: uiView.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            routePickerView.trailingAnchor.constraint(equalTo: uiView.safeAreaLayoutGuide.trailingAnchor, constant: 10)
        ])
    }
    
    func showAirPlayMenu() {
        for view: UIView in routePickerView.subviews {
            if let button = view as? UIButton {
                button.sendActions(for: .touchUpInside)
                break
            }
        }
    }
}
