//
//  HomeViewController.swift
//  TeachUs
//
//  Created by ios on 10/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {
    
    var pageMenu : CAPSPageMenu?
    var controllersArray : [UIViewController] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        self.addGradientToNavBarWithMenu()

        //TODO:- Clear the following line of usermanager
        
        UserManager.sharedUserManager.user = LoginUserType.Professor
        self.makeDataSource()

        let parameters: [CAPSPageMenuOption] = [
            .scrollMenuBackgroundColor(UIColor.clear),
            .viewBackgroundColor(UIColor.clear),
            .selectionIndicatorColor(UIColor.clear),
            .unselectedMenuItemLabelColor(UIColor(red: 152.0/255.0, green: 132.0/255.0, blue: 212.0/255.0, alpha: 1.0)),
            .menuItemFont(UIFont(name: "HelveticaNeue", size: 15.0)!),
            .menuHeight(44.0),
            .menuMargin(20.0),
            .selectionIndicatorHeight(0.0),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .selectedMenuItemLabelColor(UIColor.white)
        ]

        // Initialize page menu with controller array, frame, and optional parameters
        let pageMenuFrame = CGRect(x: 0.0, y: 60.0, width: self.view.width(), height: self.view.height())
        pageMenu = CAPSPageMenu(viewControllers: controllersArray, frame: pageMenuFrame, pageMenuOptions: parameters)
        
        // Lastly add page menu as subview of base view controller view
        // or use pageMenu controller in you view hierachy as desired
        self.view.addSubview(pageMenu!.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func makeDataSource(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        switch UserManager.sharedUserManager.user! {
        case .Professor:
            let professorAttendanceVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorAttendance) as! ProfessorAttedanceViewController
            professorAttendanceVC.title = "Attendance"
            professorAttendanceVC.parentNavigationController = self.navigationController
            controllersArray.append(professorAttendanceVC)
            
            let professorSyllabusStatusVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorSyllabusStatus) as! SyllabusStatusListViewController
            professorSyllabusStatusVC.title = "Syllabus Status"
            controllersArray.append(professorSyllabusStatusVC)
            
            
            let professorLogsListVC = storyboard.instantiateViewController(withIdentifier: Constants.viewControllerId.professorLogs) as! ProfessorLogsListViewController
            professorLogsListVC.title = "Logs"
            controllersArray.append(professorLogsListVC)
            
            break
            
        default:
            break;
        }
    }

}
