//
//  NewConversationTableViewCell.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 12/11/23.
//

import Foundation
import UIKit

class NewConversationTableViewCell: UITableViewCell {
    static let id = "NewConversationTableViewCell"

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

        titleLabel.textColor = .systemGreen
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)

        // Agregar nuevos items a la vista y aregar configuracion
        [titleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // Configuración de los constraints
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    // Configuración de los elementos de la celda
    func setUp(name: String) {
        titleLabel.text = name
    }
}
