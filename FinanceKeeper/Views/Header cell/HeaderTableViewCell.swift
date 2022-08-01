//
//  HeaderTableViewCell.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 01.08.2022.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var totalBalanceOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
