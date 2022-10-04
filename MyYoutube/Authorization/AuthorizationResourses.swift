//
//  AuthorizationResourses.swift
//  MyYoutube
//
//  Created by Мария Газизова on 21.09.2022.
//

import GoogleSignIn

class AuthenticationService {
    private let signInConfig = GIDConfiguration(
        clientID: "1027830993615-m1a6imv1lestu56ill9145lo5eoq6hvi.apps.googleusercontent.com")

    static let shared = AuthenticationService()

    var user: GIDGoogleUser?

    typealias AuthHandler = (Result<String?, CustomError>) -> Void

    func authenticate(presenting presentingViewController: UIViewController, completion: @escaping AuthHandler) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig,
                                        presenting: presentingViewController,
                                        hint: nil,
                                        additionalScopes: ["https://www.googleapis.com/auth/youtube"]) { user, error in
            guard error == nil else {
                completion(.failure(CustomError.wrongURL))
                return
            }

            self.user = user
            completion(.success(nil))
        }
    }
}
