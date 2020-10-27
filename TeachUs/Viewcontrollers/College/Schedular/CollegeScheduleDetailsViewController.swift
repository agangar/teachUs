//
//  CollegeScheduleDetailsViewController.swift
//  TeachUs
//
//  Created by iOS on 12/09/20.
//  Copyright © 2020 TeachUs. All rights reserved.
//

import UIKit

class CollegeScheduleDetailsViewController: BaseViewController {

    @IBOutlet weak var tableviewScheduleDetails: UITableView!
    var scheduleDetails:ClassScheduleDetails?
    var arrayDataSource = [ScheduleDetailDataSource]()
    var schedule : Schedule!
    
    let locale = NSLocale.current
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    private var currentToDate:String? = ""
    private var currentFromDate:String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBar()
        tableviewScheduleDetails.register(UINib(nibName: "ScheduleDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.schdeduleDetailsCellId)
        tableviewScheduleDetails.register(UINib(nibName: "ScheduleDateTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.scheduleDetailsDateCellId)
        tableviewScheduleDetails.register(UINib(nibName: "AddNewScheduleTableViewCell", bundle: nil), forCellReuseIdentifier: Constants.CustomCellId.collegeAddNewSchedule)

        tableviewScheduleDetails.dataSource = self
        tableviewScheduleDetails.delegate  = self
        tableviewScheduleDetails.estimatedRowHeight = 44.0
        tableviewScheduleDetails.rowHeight = UITableViewAutomaticDimension
        tableviewScheduleDetails.addSubview(refreshControl)
        getScheduleDetails(between: Date().getDateString(format: "YYYY-MM-dd"), Date().addDays(7).getDateString(format: "YYYY-MM-dd"))
    }
    
    func makeDataSource(){
        arrayDataSource.removeAll()
        
        let addbuttonDs = ScheduleDetailDataSource(detailsCell: .AddSchedule, detailsObject: nil)
        arrayDataSource.append(addbuttonDs)
        
        for schedule in self.scheduleDetails?.schedules ?? [] {
            let dateString = schedule.date?.getDateDisplayString()
            let dateDs = ScheduleDetailDataSource(detailsCell: .ScheduleDate, detailsObject: dateString)
            arrayDataSource.append(dateDs)
            
            for details in schedule.scheduleDetails ?? [] {
                let scheduleDS = ScheduleDetailDataSource(detailsCell: .SchdeuleDetails, detailsObject: details)
                arrayDataSource.append(scheduleDS)
            }
        }
        
        self.tableviewScheduleDetails.reloadData()
    }
    
    @IBAction func actionDatePicker(_ sender: Any) {
        // DatePicker //datePickerVcId
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController:SchedularDatePickerViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.scheduleDatePickerVc) as! SchedularDatePickerViewController
        detailsViewController.modalPresentationStyle = .custom
        slideInTransitioningDelegate.direction = .bottom
        slideInTransitioningDelegate.disableCompactHeight = true
        detailsViewController.transitioningDelegate = slideInTransitioningDelegate
        detailsViewController.modalPresentationStyle = .custom
        detailsViewController.delegate = self
        present(detailsViewController, animated: true, completion: nil)
        
    }
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        //self.datePicker.resignFirstResponder()
        datePicker.isHidden = true
        self.toolBar.isHidden = true


    }

    @objc func cancelClick() {
        datePicker.isHidden = true
        self.toolBar.isHidden = true

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.segues.toAddNewSchedule {
            if let destinationVc = segue.destination as? AddNewScheduleViewController {
                guard let classId = schedule.classId , let className = schedule.scheduleClass else { return }
                destinationVc.scheduleData = SchedularData(classId: classId, className: className)
            }
        }
    }
    
}

extension CollegeScheduleDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = arrayDataSource[indexPath.section]
        
        switch dataSource.cellType {
        case .AddSchedule:
            let cell:AddNewScheduleTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.collegeAddNewSchedule, for: indexPath)  as! AddNewScheduleTableViewCell
            cell.delegate = self
            cell.selectionStyle = .none
            
            return cell

        case .ScheduleDate:
            let cell:ScheduleDateTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.scheduleDetailsDateCellId, for: indexPath)  as! ScheduleDateTableViewCell
            let dateString = dataSource.attachedObject as? String ?? "NA"
            cell.labelDate.text = dateString
            cell.selectionStyle = .none
            return cell
            
        case .SchdeuleDetails:
            let cell:ScheduleDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: Constants.CustomCellId.schdeduleDetailsCellId, for: indexPath)  as! ScheduleDetailsTableViewCell
            guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail else { return UITableViewCell() }
            cell.setUpCell(details: scheduleObj, cellType: .lectureDetails)
            cell.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .none:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableviewScheduleDetails.width(), height: 15))
        footerView.backgroundColor = UIColor.clear
        return footerView
    }
    
}

extension CollegeScheduleDetailsViewController: AddNewScheduleDelegate {
    func addNewSchdule() {
        self.performSegue(withIdentifier: Constants.segues.toAddNewSchedule, sender: self)
    }
}

extension CollegeScheduleDetailsViewController: ScheduleDetailCellDelegate{
    func actionDeleteSchedule(_ sender: ButtonWithIndexPath) {
        guard let indexPath = sender.indexPath else {
            return
        }
        
        
        let dataSource = arrayDataSource[indexPath.section]
        guard let scheduleObj = dataSource.attachedObject as? ScheduleDetail else { return }
        
        self.deleteSchedule(for: scheduleObj)
        
        self.showAlertWithTitleAndCompletionHandlers("Delete Schedule!",
                                                     alertMessage: "Are you sure you want to delete this schedule",
                                                     okButtonString: "YES",
                                                     canelString: "CANCEL",
                                                     okAction: { self.deleteSchedule(for: scheduleObj) },
                                                     cancelAction: {} )
    }
    
    func actionEditSchedule(_ sender: ButtonWithIndexPath) {
        
        
        
        
        #if DEBUG
        self.showAlertWithTitle("DEBUG MESSAGE", alertMessage: "Implement this: actionEditSchedule")
        #endif
    }
    
    func actionJoinSchedule(_ sender: ButtonWithIndexPath) {
        #if DEBUG
        self.showAlertWithTitle("DEBUG MESSAGE", alertMessage: "Implement this: actionJoinSchedule")
        #endif
    }
    
    
}

extension CollegeScheduleDetailsViewController: DatePickerDelegate {
    func dateSelected(from fromDate: Date, to toDate: Date) {
        getScheduleDetails(between: fromDate.getDateString(format: "YYYY-MM-dd"), toDate.getDateString(format: "YYYY-MM-dd"))
    }
    
    
}

extension CollegeScheduleDetailsViewController {
    func getScheduleDetails(between toDate:String, _ fromDate:String) {
        self.currentToDate = toDate
        self.currentFromDate = fromDate
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.collegeScheduleDetails
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "class_id" : schedule.classId ?? "",
            "to_date" : toDate,
            "from_date" : fromDate        ]
        
        manager.apiPostWithDataResponse(apiName: "Get College Schedules Details", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self else { return }
            do{
                let decoder = JSONDecoder()
                self.scheduleDetails = try decoder.decode(ClassScheduleDetails.self, from: response)
                if !(self.scheduleDetails?.schedules?.isEmpty ?? true) {
                    self.makeDataSource()
                }
            } catch let error{
                print("err", error)
            }
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
    func deleteSchedule(for schedule: ScheduleDetail) {
        guard let scheduleId = schedule.attendanceScheduleId else {
            return
        }
        let manager = NetworkHandler()
        manager.url = URLConstants.CollegeURL.deleteScheduleDelete
        let parameters = [
            "college_code" : "\(UserManager.sharedUserManager.appUserCollegeDetails.college_code!)",
            "attendance_schedule_id" : scheduleId
        ]
        
        LoadingActivityHUD.showProgressHUD(view: UIApplication.shared.keyWindow!)
        manager.apiPostWithDataResponse(apiName: "Delete Schedule", parameters:parameters, completionHandler: { [weak self] (result, code, response)  in
            LoadingActivityHUD.hideProgressHUD()
            guard let `self` = self,
                let toDate = self.currentToDate,
                let fromDate = self.currentFromDate
                else { return }
            self.getScheduleDetails(between: toDate, fromDate)
        }) { (error, code, message) in
            print(message)
            LoadingActivityHUD.hideProgressHUD()
        }
    }
    
}