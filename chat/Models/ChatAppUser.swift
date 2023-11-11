//
//  ChatAppUser.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 29/10/23.
//

import Foundation

struct ChatAppUser{
    let firstName: String
    let lastName: String
    let emailAdress: String
    
    var safeEmail: String{
        var safeEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
    var profilePictureFileName: String{
        return "\(safeEmail)_profile_picture.png"
    }
}
