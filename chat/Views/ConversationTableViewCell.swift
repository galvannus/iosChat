//
//  ConversationTableViewCell.swift
//  chat
//
//  Created by Jorge Alejndro Marcial Galvan on 19/11/23.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    //static let id = "ConversationTableViewCellId"
    
    private var userImageView: UIImageView!
    private var userNameLabel: UILabel!
    private var userMessageLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpView()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userImageView.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        //userNameLabel.frame = CGRect(x: userImageView.frame.right + 10, y: 10, width: 100, height: 100)
        userMessageLabel.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
    }
    
    public func configure(with model: String){
        
    }
    
    private func setUpView() {
        userImageView = UIImageView()
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 50
        userImageView.layer.masksToBounds = true
        
        userNameLabel = UILabel()
        userNameLabel.font = .systemFont(ofSize: 21, weight: .semibold)
        
        userMessageLabel = UILabel()
        userMessageLabel.font = .systemFont(ofSize: 19, weight: .regular)
        userMessageLabel.numberOfLines = 0  
    }
    
    private func setUpLayout(){
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }

}
