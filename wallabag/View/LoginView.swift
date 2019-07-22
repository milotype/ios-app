//
//  LoginView.swift
//  wallabag
//
//  Created by Marinel Maxime on 19/07/2019.
//

import SwiftUI
import Combine


class LoginHandler: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    
    var isValid: Bool = false {
        didSet {
            didChange.send()
            if (isValid) {
                //WallabagUserDefaults.password = password
            }
        }
    }
    
    var login: String = "" {
        didSet {
            validate()
        }
    }
    var password: String = "" {
        didSet {
            validate()
        }
    }
    
    private func validate() {
        isValid = !login.isEmpty && !password.isEmpty
    }
}

struct LoginView: View {
    @ObjectBinding var loginHandler = LoginHandler()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Form {
            Section(header: Text("Login")) {
                TextField($loginHandler.login).onAppear {
                    self.loginHandler.login = WallabagUserDefaults.login
                }
            }
            Section(header: Text("Passwod")) {
                SecureField($loginHandler.password)
            }
            Button("Login") {
                self.appState.registred = true
            }.disabled(!loginHandler.isValid)
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
#endif