//
//  SignInButton.swift
//  MyYoutube
//
//  Created by Мария Газизова on 28.09.2022.
//

import UIKit

enum Signing {
    case signIn
    case signOut

    func getIcon() -> UIImage? {
        switch self {
        case .signIn:
            return UIImage(named: "signIn.png")
        case .signOut:
            return UIImage(named: "signOut.png")
        }
    }
}

class SignInButton: UIButton {
    let icon = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(icon)
        setSignInIcon()
        icon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 30),
            icon.heightAnchor.constraint(equalToConstant: 30),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSignInIcon() {
        icon.image = Signing.signIn.getIcon()?.withTintColor(.white)
    }

    func setSignOutIcon() {
        icon.image = Signing.signOut.getIcon()?.withTintColor(.white)
    }
}
