//
//  Message.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 08/11/23.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
    var sender: SenderType
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text:
            return "text"
        case .attributedText:
            return "attributed_text"
        case .photo:
            return "photo"
        case .video:
            return "video"
        case .location:
            return "location"
        case .emoji:
            return "emoji"
        case .audio:
            return "audio"
        case .contact:
            return "contact"
        case .linkPreview:
            return "linkPreview"
        case .custom:
            return "custom"
        }
    }
}
