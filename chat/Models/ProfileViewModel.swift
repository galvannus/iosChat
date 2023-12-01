//
//  ProfileViewModel.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 30/11/23.
//

import Foundation

struct ProfileViewModel {
    let viewModelType: ProfileViewModelType
    let title: String
    let handler: (() -> Void)?
}

enum ProfileViewModelType {
    case info, logout
}
