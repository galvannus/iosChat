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
    var kind: MessageKit.MessageKind
    var sender: SenderType
}
