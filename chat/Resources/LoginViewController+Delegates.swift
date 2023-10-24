//
//  LoginViewController+Delegates.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 23/10/23.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTapped()
        }

        return true
    }
}
