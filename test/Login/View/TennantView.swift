//
//  TennatView.swift
//  test
//
//  Created by admin on 1/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class TennantView: UIView {
    
    weak var delegate: TennantDelegate?
    var tennants: [Tennant] = []
    
    let loaderView: UIActivityIndicatorView = {
        let loaderView = UIActivityIndicatorView(style: .whiteLarge)
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        loaderView.style = .gray
        loaderView.hidesWhenStopped = true
        return loaderView
    }()
    
    lazy var tennantTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = TennantHeaderView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 40))
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(delegate: TennantDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        
        addSubview(loaderView)
        addSubview(tennantTableView)
        NSLayoutConstraint.activate([
            loaderView.widthAnchor.constraint(equalTo: self.widthAnchor),
            loaderView.heightAnchor.constraint(equalTo: self.heightAnchor),
            
            tennantTableView.widthAnchor.constraint(equalTo: self.widthAnchor),
            tennantTableView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    func loadTennants() {
        loaderView.startAnimating()
        ApiClient.apiClient.getTennants(completion: { [weak self] tennants, error in
            guard let welf = self else { return }
            
            welf.loaderView.stopAnimating()
            
            if let unwrappedError = error {
                welf.delegate?.didHappendError(error: unwrappedError)
                return
            }
            
            if let unwrappedTennants = tennants {
                welf.tennants = unwrappedTennants
                welf.tennantTableView.reloadData()
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TennantView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tennants[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tennants.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didChosingTennant(tennant: tennants[indexPath.row])
    }
}
