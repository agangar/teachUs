//
//  HomeTabsViewController.swift
//  TeachUs
//
//  Created by ios on 3/17/18.
//  Copyright © 2018 TeachUs. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomeTabsViewController: ButtonBarPagerTabStripViewController {
    let unselectedColor = UIColor(white: 1.0, alpha: 0.4)
    var controllersArray : [UIViewController] = []
    var parentNavigationController : UINavigationController?

    override func viewDidLoad() {

        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemFont = .boldSystemFont(ofSize: 14)
        settings.style.selectedBarHeight = 0.0
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemsShouldFillAvailiableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        settings.style.buttonBarMinimumInteritemSpacing = 0
        super.viewDidLoad()
        
         changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
         guard changeCurrentIndex == true else { return }
         oldCell?.label.textColor = self?.unselectedColor
         newCell?.label.textColor = .white
         }
         

        self.view.bringSubview(toFront: self.view)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        switch UserManager.sharedUserManager.user! {
        case .professor:
            
            controllersArray.removeAll()
            let professorAttendanceVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorAttendance) as! ProfessorAttedanceViewController
            professorAttendanceVC.title = "Attendance"
            professorAttendanceVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(professorAttendanceVC)
            
            let professorSyllabusStatusVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
            professorSyllabusStatusVC.title = "Syllabus Status"
            professorSyllabusStatusVC.parentNavigationController = self.parentNavigationController
            professorSyllabusStatusVC.userType = .professor
            controllersArray.append(professorSyllabusStatusVC)
            
            let professorLogsListVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorLogs) as! ProfessorLogsListViewController
            professorLogsListVC.title = "My Logs"
            professorLogsListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(professorLogsListVC)
            
            let collegeNoticeClassListVC:CollegeNoticeListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNoticeList) as! CollegeNoticeListViewController
            collegeNoticeClassListVC.title = "Notice"
            collegeNoticeClassListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeNoticeClassListVC)
            
            let collegeNotificationListVC:CollegeNotificationListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNotificationList) as! CollegeNotificationListViewController
            collegeNotificationListVC.title = "Notification"
            collegeNotificationListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeNotificationListVC)


            
            let professorNotes:ProfessorNotesSubjectListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.ProfessorNotesSubjectListViewControllerId) as! ProfessorNotesSubjectListViewController
            professorNotes.title = "Notes"
            professorNotes.parentNavigationController = self.parentNavigationController
            controllersArray.append(professorNotes)

            let requestListVC:ScheduleListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.lecturerScheduleList) as! ScheduleListViewController
            requestListVC.title = "Notes"
            requestListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(requestListVC)
            
            break

            
        case .student:
            controllersArray.removeAll()
            let attendanceVC: StudentAttedanceViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentAttendace) as! StudentAttedanceViewController
            attendanceVC.title = "Attendance"
            attendanceVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(attendanceVC)
            
            let syllabusStatusVC:SyllabusStatusListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
            syllabusStatusVC.title = "Syllabus Status"
            
            syllabusStatusVC.parentNavigationController = self.parentNavigationController
            syllabusStatusVC.userType = .student
            controllersArray.append(syllabusStatusVC)
            
            let professorRating:TeachersRatingViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorRating) as! TeachersRatingViewController
            professorRating.title = "Rating"
            professorRating.parentNavigationController = self.parentNavigationController            
            controllersArray.append(professorRating)
            
            let collegeNoticeClassListVC:CollegeNoticeListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNoticeList) as! CollegeNoticeListViewController
            collegeNoticeClassListVC.title = "Notice"
            collegeNoticeClassListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeNoticeClassListVC)
            
            
            let collegeNotificationListVC:CollegeNotificationListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNotificationList) as! CollegeNotificationListViewController
            collegeNotificationListVC.title = "Notification"
            collegeNotificationListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeNotificationListVC)


            
            let studentNotesVC:StudentNotesListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentNotesList) as! StudentNotesListViewController
            studentNotesVC.title = "Notes"
            studentNotesVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(studentNotesVC)
            
            //StudentsScheduleViewController
            let scheduleVc:StudentsScheduleViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentScheduleListId) as! StudentsScheduleViewController
            scheduleVc.title = "Schedule"
            scheduleVc.isParentsProfileFlow = false
            scheduleVc.parentNavigationController = self.parentNavigationController
            controllersArray.append(scheduleVc)

            break
            
            
        case .parents:
            controllersArray.removeAll()
            let attendanceVC: StudentAttedanceViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentAttendace) as! StudentAttedanceViewController
            attendanceVC.title = "Attendance"
            attendanceVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(attendanceVC)
            
            let syllabusStatusVC:SyllabusStatusListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
            syllabusStatusVC.title = "Syllabus Status"
            
            syllabusStatusVC.parentNavigationController = self.parentNavigationController
            syllabusStatusVC.userType = .parents
            controllersArray.append(syllabusStatusVC)
            
            let collegeNoticeClassListVC:CollegeNoticeListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNoticeList) as! CollegeNoticeListViewController
            collegeNoticeClassListVC.title = "Notice"
            collegeNoticeClassListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeNoticeClassListVC)
            
            
            let collegeNotificationListVC:CollegeNotificationListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNotificationList) as! CollegeNotificationListViewController
            collegeNotificationListVC.title = "Notification"
            collegeNotificationListVC.parentNavigationController = self.parentNavigationController
            controllersArray.append(collegeNotificationListVC)
            
            let scheduleVc:StudentsScheduleViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.studentScheduleListId) as! StudentsScheduleViewController
            scheduleVc.title = "Schedule"
            scheduleVc.isParentsProfileFlow = true
            scheduleVc.parentNavigationController = self.parentNavigationController
            controllersArray.append(scheduleVc)

            break

            
        case .college:
            self.controllersArray.removeAll()
            
            for tab in UserManager.sharedUserManager.allowedCollegeUserTabs{
                switch tab {
                case .atendanceReport: //Attendance (Reports)
                    let collegeAttendanceListVC:CollegeAttendanceListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeAttendanceListViewControllerId) as! CollegeAttendanceListViewController
                    collegeAttendanceListVC.title = "\(tab.titleName)"
                    collegeAttendanceListVC.parentNavigationController = self.parentNavigationController
                    controllersArray.append(collegeAttendanceListVC)
                    
                case .attendanceEvent://Attendance (Events)
                    let eventAttendanceListVc:EventAttendanceListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.EventAttendanceListViewControllerId) as! EventAttendanceListViewController
                    eventAttendanceListVc.title = "\(tab.titleName)"
                    eventAttendanceListVc.parentNavigationController = self.parentNavigationController
                    controllersArray.append(eventAttendanceListVc)
                    
                case .syllabus: //Syllabus
                    if(UserManager.sharedUserManager.appUserCollegeDetails.privilege! ==  "1"){//1-super-admin, 2-admin
                        let collegeSyllabusStatusVC:CollegeSyllabusStatusViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeSyllabusStatusViewControllerId) as! CollegeSyllabusStatusViewController
                        collegeSyllabusStatusVC.title = "\(tab.titleName)"
                        collegeSyllabusStatusVC.parentNavigationController = self.parentNavigationController
                        controllersArray.append(collegeSyllabusStatusVC)
                    }
                    
                case .addRemoveAdmin: //Add/Remove Admin
                    if(UserManager.sharedUserManager.appUserCollegeDetails.privilege! ==  "1"){//1-super-admin, 2-admin
                        
                        let addRemoveAdminVC:AddRemoveAdminViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.AddRemoveAdminViewControllerId) as! AddRemoveAdminViewController
                        addRemoveAdminVC.title = "\(tab.titleName)"
                        addRemoveAdminVC.parentNavigationController = self.parentNavigationController
                        controllersArray.append(addRemoveAdminVC)
                    }
                    
                case .feedbcak: //"Ratings"
                    if(UserManager.sharedUserManager.appUserCollegeDetails.privilege! ==  "1"){
                        let collegeRatingListVC:CollegeClassRatingListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeClassRatingListViewControllerId) as! CollegeClassRatingListViewController
                        collegeRatingListVC.title = "\(tab.titleName)"
                        collegeRatingListVC.parentNavigationController = self.parentNavigationController
                        controllersArray.append(collegeRatingListVC)
                    }
                    
                case .logs: //"Logs"
                    if(UserManager.sharedUserManager.appUserCollegeDetails.privilege! ==  "1"){
                        let collegeLogsListVC:CollegeLogsProfessorListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.CollegeLogsProfessorListViewControllerId) as! CollegeLogsProfessorListViewController
                        collegeLogsListVC.title = "\(tab.titleName)"
                        collegeLogsListVC.parentNavigationController = self.parentNavigationController
                        controllersArray.append(collegeLogsListVC)
                    }
                    
                case .notice: //"Notice"
                    let collegeNoticeClassListVC:CollegeNoticeListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNoticeList) as! CollegeNoticeListViewController
                    collegeNoticeClassListVC.title = "\(tab.titleName)"
                    collegeNoticeClassListVC.parentNavigationController = self.parentNavigationController
                    controllersArray.append(collegeNoticeClassListVC)
                    
                case .notification: //"Notification"
                    if(UserManager.sharedUserManager.appUserCollegeDetails.privilege! ==  "1"){
                        let collegeNotificationListVC:CollegeNotificationListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNotificationList) as! CollegeNotificationListViewController
                        collegeNotificationListVC.title = "\(tab.titleName)"
                        collegeNotificationListVC.parentNavigationController = self.parentNavigationController
                        controllersArray.append(collegeNotificationListVC)
                    }
                    
                case .notes: //"Notes"
                    if(UserManager.sharedUserManager.appUserCollegeDetails.privilege! ==  "1"){
                        let collegeNotesClassListVC:CollegeNotesClassListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeNotesClassList) as! CollegeNotesClassListViewController
                        collegeNotesClassListVC.title = "\(tab.titleName)"
                        collegeNotesClassListVC.parentNavigationController = self.parentNavigationController
                        controllersArray.append(collegeNotesClassListVC)
                    }
                    
                case .request: //"Request" 
                    let requestListVC:ProfileChangeRequestsViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.ProfileChangeRequestsViewControllerId) as! ProfileChangeRequestsViewController
                    requestListVC.title = "\(tab.titleName)"
                    requestListVC.parentNavigationController = self.parentNavigationController
                    controllersArray.append(requestListVC)
                    
                case .scheduler: //"Scheduler"
                    let requestListVC:CollegeSchedulerListViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.collegeScheduler) as! CollegeSchedulerListViewController
                    requestListVC.title = "\(tab.titleName)"
                    requestListVC.parentNavigationController = self.parentNavigationController
                    controllersArray.append(requestListVC)
                case .logout:
                    break
                }
            }
            break
            
        case .exam:
            controllersArray.removeAll()
            
            guard  let examVc: ExamHomeViewController = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.examHomeView) as? ExamHomeViewController else {
                return controllersArray
            }
            examVc.title = "Exam"
            examVc.parentNavigationController = self.parentNavigationController
            controllersArray.append(examVc)
            break
            
        }
        return controllersArray

    }

}
