//
//  TableViewCell.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 01/11/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let id = "TableViewCell"

    var titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        contentView.backgroundColor = .systemBackground // contentVew la vista general

        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpView() {
        // Configuración de elementos UI

        //titleLabel.textColor = .systemGreen
        titleLabel.font = .systemFont(ofSize: 16, weight: .regular)

        // Agregar nuevos items a la vista y aregar configuracion
        [titleLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    public func setUp(with viewModel: ProfileViewModel){
        titleLabel.text = viewModel.title
        switch viewModel.viewModelType {
        case .info:
            // Configuración de los constraints
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            ])
        case .logout:
            titleLabel.textColor = .red
            //titleLabel.textAlignment = .center
            // Configuración de los constraints
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            ])
        }
    }
}
