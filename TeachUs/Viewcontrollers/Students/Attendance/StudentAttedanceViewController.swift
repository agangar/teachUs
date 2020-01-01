//
//  StudentAttedanceViewController.swift
//  TeachUs
//
//  Created by ios on 11/2/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import ObjectMapper
import XLPagerTabStrip

class StudentAttedanceViewController: BaseViewController {
    var parentNavigationController : UINavigationController?
    @IBOutlet weak var viewAttendanceMonth: UIView!
    @IBOutlet weak var labelLectureCount: UILabel!
    @IBOutlet weak var buttonDropDown: UIButton!
    @IBOutlet weak var labelMonthType: UILabel!
    @IBOutlet weak var tableViewStudentAttendance: UITableView!
    @IBOutlet weak var viewHeaderBackground: UIView!
    
    var tableDataSource:[StudentAttendanceCellDatasource]! = []
    var arrayDataSource:StudentAttendance!
    var selectedSubjectAttendance:SubjectAttendance!
    let monthDropdown = DropDown()
    var monthArray: [String]{
        var tempStringArray = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-yyyy"
        for i in 0..<12 {
            let nextMonth = Calendar.current.date(byAdding: .month, value: -i, to: Date())
            let nextmonthString  = dateFormatter.string(from: nextMonth!)
            tempStringArray.append(nextmonthString)
        }
        tempStringArray.insert("Overall", at: 0)
        return tempStringArray
    }

    //----------------------->For college Flow <------------------------//
    var enrolledStudentObj:EnrolledStudentDetail?
    var isCollegeFlow:Bool = false
    
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        isCollegeFlow ?  getAttendanceForCollege(0) : getAttendance(0)
        if isCollegeFlow{
            self.addGradientToNavBar()
        }
        self.tableViewStudentAttendance.register(UINib(nibName: "SyllabusStatusTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId)
        self.tableViewStudentAttendance.delegate = self
        self.tableViewStudentAttendance.dataSource = self
        self.tableViewStudentAttendance.alpha = 0.0
        self.tableViewStudentAttendance.addSubview(refreshControl)
        self.setUpDropDown()
        self.requestAppReview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func refresh(sender: AnyObject) {
        isCollegeFlow ? getAttendanceForCollege(0) : getAttendance(0)
        super.refresh(sender: sender)
        }
    
    func getAttendance(_ forMonth:Int){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        var strYear = dateFormatter.string(from: date)
        var strMonth = "0"
        
        if forMonth > 0
        {
            let dateString = self.monthArray[forMonth]
            dateFormatter.dateFormat = "MMM-yyyy"
            let dattObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "YYYY"
            strYear = dateFormatter.string(from: dattObj!)
            dateFormatter.dateFormat = "M"
            strMonth = dateFormatter.string(from: dattObj!)
        }
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        var parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "year":"\(strYear)",
            "month":"\(strMonth)"
        ]
        
    
        if UserManager.sharedUserManager.user! == .parents{
            manager.url = URLConstants.ParentsURL.getClassAttendance
            parameters["email"] = UserManager.sharedUserManager.appUserCollegeDetails.studentEmail ?? ""
        }else{            
            manager.url = URLConstants.StudentURL.getClassAttendance
        }
        manager.apiPost(apiName: " Get user Attendance for month \(strMonth)", parameters:parameters, completionHandler: { (result, code, response) in
            if(forMonth == 0){
                self.labelMonthType.text = "Overall"
            }
            LoadingActivityHUD.hideProgressHUD()
            self.arrayDataSource = Mapper<StudentAttendance>().map(JSON: response)
            self.arrayDataSource.subjectAttendance.sort(by: { $0.subjectName! < $1.subjectName! })
            self.arrayDataSource.eventAttendance.sort(by: { $0.eventName! < $1.eventName! })
            self.setUpView()
            self.makeDataSource()
            self.setUserAccessToken()

        }) { (error, code, message) in
            print(message)
            self.setUserAccessToken()
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    func getAttendanceForCollege(_ forMonth:Int)
    {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY"
        var strYear = dateFormatter.string(from: date)
        var strMonth = "0"
        
        if forMonth > 0
        {
            let dateString = self.monthArray[forMonth]
            dateFormatter.dateFormat = "MMM-yyyy"
            let dattObj = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "YYYY"
            strYear = dateFormatter.string(from: dattObj!)
            dateFormatter.dateFormat = "M"
            strMonth = dateFormatter.string(from: dattObj!)
        }
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.colleegStudentattendanceFlow
        let parameters = [
            "college_code":"\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "year":"\(strYear)",
            "month":"\(strMonth)",
            "email":enrolledStudentObj?.studentEmail ?? ""
        ]
        
        manager.apiPost(apiName: " Get user Collge Attendance for month \(strMonth)", parameters:parameters, completionHandler: { (result, code, response) in
            if(forMonth == 0){
                self.labelMonthType.text = "Overall"
            }
            LoadingActivityHUD.hideProgressHUD()
            self.arrayDataSource = Mapper<StudentAttendance>().map(JSON: response)
            self.arrayDataSource.subjectAttendance.sort(by: { $0.subjectName! < $1.subjectName! })
            self.arrayDataSource.eventAttendance.sort(by: { $0.eventName! < $1.eventName! })
            self.setUpView()
            self.makeDataSource()
            self.setUserAccessToken()
            
        }) { (error, code, message) in
            print(message)
            self.setUserAccessToken()
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    
    
    func makeDataSource(){
        UIView.animate(withDuration: 0.2) {
            self.tableViewStudentAttendance.contentOffset = .zero
            self.tableViewStudentAttendance.layoutIfNeeded()
        }
        self.tableDataSource.removeAll()
        for subject in self.arrayDataSource.subjectAttendance{
            let tempDataSource = StudentAttendanceCellDatasource(cellType: .ClassAttendance, object: subject)
            self.tableDataSource.append(tempDataSource)
        }
        
        for event in self.arrayDataSource.eventAttendance{
            let tempDataSource = StudentAttendanceCellDatasource(cellType: .EventAttendance, object: event)
            self.tableDataSource.append(tempDataSource)
        }
        self.tableViewStudentAttendance.reloadData()
        self.showTableView()
    }
    
    
    func setUpDropDown(){
        self.monthDropdown.anchorView = self.viewAttendanceMonth
        self.monthDropdown.bottomOffset = CGPoint(x: 0, y: monthDropdown.height())
        self.monthDropdown.dataSource = monthArray
        self.monthDropdown.selectionAction = { [unowned self] (index, item) in
            self.labelMonthType.text = "\(item)"
            self.isCollegeFlow ? self.getAttendanceForCollege(index) : self.getAttendance(index)
        }
        DropDown.appearance().backgroundColor = UIColor.white
    }

    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(StudentAttedanceViewController.showMonthPicker))
        tap.numberOfTapsRequired = 1
        self.viewAttendanceMonth.addGestureRecognizer(tap)
        
        self.labelLectureCount.text = "\(self.arrayDataSource.overallPercenage!)%  ( \(self.arrayDataSource.totalPresentCount!)/\(self.arrayDataSource.totalLecture!) )"
        self.viewHeaderBackground.alpha = self.arrayDataSource.subjectAttendance.count > 0 ? 1 : 0
        
    }
    
    func showTableView(){
        self.tableViewStudentAttendance.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 0.3) {
            self.tableViewStudentAttendance.alpha = 1.0
            self.tableViewStudentAttendance.transform = CGAffineTransform.identity
        }
    }
    
    @objc func showMonthPicker(){
        monthDropdown.show()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toStudentAttendanceDetails{
            if let destinationVc:StudentAttendanceDetailsViewController = (segue.destination as? StudentAttendanceDetailsViewController){
                destinationVc.selectedStudentAttendance = self.selectedSubjectAttendance
                destinationVc.isCollegeFlow = self.isCollegeFlow
                destinationVc.enrolledStudentObj = self.enrolledStudentObj
            }
        }
    }
}

extension StudentAttedanceViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.tableDataSource != nil){
            return 1
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.tableDataSource != nil){
            return self.tableDataSource.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableViewStudentAttendance.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //***have reused the syllabus-details cell***
        let cell:SyllabusStatusTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.SyllabusStatusTableViewCellId, for: indexPath) as! SyllabusStatusTableViewCell

        let dataSource:StudentAttendanceCellDatasource = self.tableDataSource[indexPath.section]
        switch dataSource.attendanceCellType! {
        case .ClassAttendance:
            let cellData:SubjectAttendance = dataSource.attachedObject as! SubjectAttendance
            cell.labelSubject.text = cellData.subjectName
            cell.labelNumberOfLectures.text = "\(cellData.percentage!)%"
            cell.labelAttendancePercent.text = "\(cellData.presentCount!)/\(cellData.totalCount!)"
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            
        case .EventAttendance:
            let cellData:EventAttendance = dataSource.attachedObject as! EventAttendance
            cell.labelSubject.text = cellData.eventName
            cell.labelNumberOfLectures.text = "NA"
            cell.labelAttendancePercent.text = "\(cellData.eventAttendance)"
            cell.selectionStyle = .none
            return cell
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataSource:StudentAttendanceCellDatasource = self.tableDataSource[indexPath.section]
        switch dataSource.attendanceCellType! {
        case .ClassAttendance:
            self.selectedSubjectAttendance = dataSource.attachedObject as? SubjectAttendance
            
        case .EventAttendance:break
        }
        self.performSegue(withIdentifier: Constants.segues.toStudentAttendanceDetails, sender: self)
    }
}

extension StudentAttedanceViewController:IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Attendance")
    }
}