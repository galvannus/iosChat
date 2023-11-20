//
//  ConversationsTableViewCell.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 07/11/23.
//

import UIKit
import SDWebImage

class ConversationsTableViewCell: UITableViewCell {
    static let id = "ConversationsTableViewCellId"

    private var userImageView: UIImageView = UIImageView()
    private var userNameLabel: UILabel = UILabel()
    private var userMessageLabel: UILabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .white // contentVew la vista general

        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        // Configuración de elementos UI
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 50
        userImageView.layer.masksToBounds = true
        userImageView.layer.cornerRadius = 30 // Borde del elemento
        userImageView.clipsToBounds = true // Activar bordes
        userImageView.backgroundColor = .blue

        userNameLabel.font = .systemFont(ofSize: 21, weight: .semibold)

        userMessageLabel.font = .systemFont(ofSize: 19, weight: .regular)
        userMessageLabel.numberOfLines = 0

        [userImageView, userNameLabel, userMessageLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configuración de los constraints
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            userImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60),

            userNameLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 9),
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor),
            userNameLabel.widthAnchor.constraint(equalToConstant: 100),
            userNameLabel.heightAnchor.constraint(equalToConstant: 40),

            userMessageLabel.bottomAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            // userMessageLabel.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor, constant: 9)
        ])
    }

    public func configure(with model: Conversation) {
        self.userMessageLabel.text = model.latestMessage.message
        self.userNameLabel.text = model.name
        
        let path = "images/\(model.otherUserEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
            switch result {
            case .success(let url):
                print(url)
                DispatchQueue.main.sync {
                    self?.userImageView.sd_setImage(with: url)
                }
                print("Reload.")
            case .failure(let error):
                print("Failed to get image url: \(error)")
            }
        })
    }
}
