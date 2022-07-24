//
//  ChoosenCitiesTableViewCell.swift
//  weatherAppTest
//
//  Created by sem1 on 24.07.22.
//

import UIKit

class ChoosenCitiesTableViewCell: UITableViewCell {
    
    static var reuseID: String {
        String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
