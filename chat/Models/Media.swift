//
//  Media.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 23/11/23.
//

import Foundation
import MessageKit

struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
