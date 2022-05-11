//
//  ListTableViewCell.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//

import UIKit

protocol ListTableViewCellProtocol {
    func setupTitle(_ title: String)
}

class ListTableViewCell: UITableViewCell {
    // MARK: - @IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension ListTableViewCell: ListTableViewCellProtocol {
    func setupTitle(_ title: String) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.titleLabel.text = title
        }
    }
}
