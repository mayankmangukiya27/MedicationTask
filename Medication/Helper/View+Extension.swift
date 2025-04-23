//
//  View+Extension.swift
//  Medication
//
//  Created by MAC on 22/04/25.
//

import Foundation
import SwiftUI

// Rounded corner helper
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


func showToast(message: String) {
    // Example for showing a simple toast, adjust as per your implementation
    let toastLabel = UILabel()
    toastLabel.text = message
    toastLabel.textColor = .white
    toastLabel.backgroundColor = .black
    toastLabel.alpha = 1.0
    toastLabel.numberOfLines = 0
    toastLabel.textAlignment = .center
    toastLabel.font = UIFont.systemFont(ofSize: 14)
    toastLabel.layer.cornerRadius = 10
    toastLabel.clipsToBounds = true
    // Customize toast position and duration
    if let window = UIApplication.shared.keyWindow {
        window.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toastLabel.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toastLabel.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -50),
            toastLabel.widthAnchor.constraint(lessThanOrEqualToConstant: window.frame.width - 30)
        ])
        
        UIView.animate(withDuration: 0.70, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0
        }, completion: { _ in
            toastLabel.removeFromSuperview()
        })
    }
}
