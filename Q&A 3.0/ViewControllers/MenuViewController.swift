//
//  MenuViewController.swift
//  Q&A 3.0
//
//  Created by Inna Litvinenko on 4/17/20.
//  Copyright © 2020 Inna Litvinenko. All rights reserved.
//

import UIKit

enum MenuType: Int {
    case toAsk
    case answQ
    case nAnswQ
    case fav
}

class MenuViewController: UITableViewController {
    
    var didTapMenuType: ((MenuType)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let menuType = MenuType(rawValue: indexPath.row)
            else { return }
        dismiss(animated: true) { [weak self] in
            self?.didTapMenuType?(menuType)
        }
    }

}
