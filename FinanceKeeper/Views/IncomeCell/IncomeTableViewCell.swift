//
//  IncomeTableViewCell.swift
//  FinanceKeeper
//
//  Created by Влад Бокин on 01.08.2022.
//

import UIKit

class IncomeTableViewCell: UITableViewCell {

  
    @IBOutlet weak var catergoryLabelOutlet: UILabel!
    
    @IBOutlet weak var dataLabelOutlet: UILabel!
    
    @IBOutlet weak var moneyLabelOutlet: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
