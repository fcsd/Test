//
//  TennatHeaderView.swift
//  test
//
//  Created by admin on 1/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TennantHeaderView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(16)
        label.textColor = .white
        label.text = "Select tennant"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        backgroundColor = .blue

        addView()
    }
    
    func addView() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
