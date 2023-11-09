//
//  ConversationsTableViewCell.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 07/11/23.
//

import UIKit

class ConversationsTableViewCell: UITableViewCell {
    static let id = "ConversationsTableViewCellId"

    var titleLabel: UILabel = UILabel()

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

        // titleLabel.textColor = .systemGreen
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)

        // Agregar nuevos items a la vista y aregar configuracion
        [titleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configuración de los constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    // Configuración de los elementos de la celda
    func setUp(name: String) {
        titleLabel.text = name
    }
}
