//
//  ViewCourseSelection.swift
//  TeachUs
//
//  Created by ios on 3/9/19.
//  Copyright © 2019 TeachUs. All rights reserved.
//

import UIKit

protocol ViewCourseSelectionDelegate {
    func courseViewDismissed()
    func submitSelectedCourses()
}

class ViewCourseSelection: UIView {
    
    @IBOutlet weak var buttonSelectAll: UIButton!
    @IBOutlet weak var buttonDeselectAll: UIButton!
    @IBOutlet weak var buttonClose: UIButton!
    @IBOutlet weak var tableviewCourseList: UITableView!
    @IBOutlet weak var buttonSubmit: UIButton!
    var delegate : ViewCourseSelectionDelegate!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tableviewCourseList.delegate = self
        self.tableviewCourseList.dataSource = self
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSubmit.roundedRedButton()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        self.delegate.courseViewDismissed()
    }
    
    @IBAction func actionSubmitSelectedCourses(_ sender: Any) {
        self.delegate.submitSelectedCourses()
    }
    
    
    
    @IBAction func selectAllCourses(_ sender: Any) {
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        
        
        CollegeClassManager.sharedManager.selectedCourseArray = CollegeClassManager.sharedManager.selectedCourseArray.map({courseSelected in
            courseSelected.isSelected = true
            return courseSelected
        })
        self.tableviewCourseList.reloadData()
    }
    
    @IBAction func deselectAllCoursees(_ sender: Any) {
        self.buttonDeselectAll.makeButtonwith(background: .white, fontColor: .red, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        self.buttonSelectAll.makeButtonwith(background: .white, fontColor: .black, cornerRadius: nil, borderColor: nil, borderWidth: nil)
        
        CollegeClassManager.sharedManager.selectedCourseArray = CollegeClassManager.sharedManager.selectedCourseArray.map({classSelected in
            classSelected.isSelected = false
            return classSelected
        })
        self.tableviewCourseList.reloadData()
    }
    
    func selecCourses(courseIdArray:[String]){
        CollegeClassManager.sharedManager.selectedCourseArray =
        CollegeClassManager.sharedManager.selectedCourseArray.map({mapObj in
            if let courseId = mapObj.collegeCourse?.courseID
            {
                mapObj.isSelected = courseIdArray.contains(courseId)
            }
            return mapObj
        })
    }
    
}

extension ViewCourseSelection:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CollegeClassManager.sharedManager.selectedCourseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .default, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        cell.textLabel?.text = "\(CollegeClassManager.sharedManager.selectedCourseArray[indexPath.row].collegeCourse?.courseName ?? "")"
        
        cell.accessoryType = CollegeClassManager.sharedManager.selectedCourseArray[indexPath.row].isSelected ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CollegeClassManager.sharedManager.selectedCourseArray[indexPath.row].isSelected = !CollegeClassManager.sharedManager.selectedCourseArray[indexPath.row].isSelected
        self.tableviewCourseList.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        CollegeClassManager.sharedManager.selectedCourseArray[indexPath.row].isSelected = !CollegeClassManager.sharedManager.selectedCourseArray[indexPath.row].isSelected
        self.tableviewCourseList.reloadData()
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewCourseSelection", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}

