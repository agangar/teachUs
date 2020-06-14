//
//  NotificationCenter.swift
//  TeachUs
//
//  Created by ios on 10/24/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let notificationLoginSuccess         = Notification.Name("loginSuccess")
    static let notificationOfflineUploadSuccess = Notification.Name("offlineDataUploaded")
    static let notificationBellCountUpdate      = Notification.Name("bellIconDataUpdated")
    static let performNotificationNavigation    = Notification.Name("performNotificationNavigation")
    static let eventDeleted                     = Notification.Name("eventDeleted")
    static let showHideAdmissionButton          = Notification.Name("showHideNotification")

}
