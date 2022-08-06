//
//  NewExpenseTableViewCell.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 06.08.2022.
//

import UIKit

class NewExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabelOutlet: UILabel!
    @IBOutlet weak var dateLabelOutlet: UILabel!
    @IBOutlet weak var expenseLabelOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
