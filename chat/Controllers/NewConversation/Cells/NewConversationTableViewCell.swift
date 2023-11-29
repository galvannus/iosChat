//
//  NewConversationTableViewCell.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 12/11/23.
//

import Foundation
import SDWebImage
import UIKit

class NewConversationTableViewCell: UITableViewCell {
    static let id = "NewConversationTableViewCell"

    private var userImageView: UIImageView = UIImageView()
    private var userNameLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //selectionStyle = .none
        //backgroundColor = .clear
        contentView.backgroundColor = .systemBackground // contentVew la vista general

        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        // Configuración de elementos UI
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 20 // Borde del elemento
        userImageView.clipsToBounds = true // Activar bordes

        userNameLabel.font = .systemFont(ofSize: 14, weight: .semibold)

        [userImageView, userNameLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configuración de los constraints
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            userImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 40),
            userImageView.heightAnchor.constraint(equalToConstant: 40),

            // userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            // userNameLabel.widthAnchor.constraint(equalToConstant: 120),
            // userNameLabel.heightAnchor.constraint(equalToConstant: 40),
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
        ])
    }

    public func configure(with model: SearchResult) {
        self.userNameLabel.text = model.name

        let path = "images/\(model.email)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case let .success(url):
                /* DispatchQueue.main.sync {
                     self?.userImageView.sd_setImage(with: url)
                 } */
                self?.userImageView.sd_setImage(with: url)
            case let .failure(error):
                print("Failed to get image url: \(error)")
            }
        })
    }
}
