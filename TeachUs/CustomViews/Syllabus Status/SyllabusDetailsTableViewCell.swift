//
//  SyllabusDetailsTableViewCell.swift
//  TeachUs
//
//  Created by ios on 11/19/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class SyllabusDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var labelChapterNumber: UILabel!
    @IBOutlet weak var labelChapterDetails: UILabel!
    @IBOutlet weak var imageViewStatus: UIImageView!    
    @IBOutlet weak var viewSeperator: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
