//
//  LectureReportSubjectTableViewCell.swift
//  TeachUs
//
//  Created by ios on 5/12/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit

class LectureReportSubjectTableViewCell: UITableViewCell {

//    @IBOutlet weak var imageViewReportIcon: UIImageView!
//    @IBOutlet weak var labelReportTitle: UILabel!
//    @IBOutlet weak var labelReportDescription: UILabel!

    @IBOutlet weak var imageViewReportIcon: UIImageView!
    @IBOutlet weak var labelReportTitle: UILabel!    
    @IBOutlet weak var labelReportDescription: UILabel!
    @IBOutlet weak var labelSubjectTitle: UILabel!
    @IBOutlet weak var labelSubjectDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}