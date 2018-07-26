//
//  PermissionGroup.swift
//  permission_handler
//
//  Created by Maurits van Beusekom on 25/07/2018.
//

import Foundation

enum PermissionGroup : String, Codable {
    case calendar = "calendar"
    case camera = "camera"
    case contacts = "contacts"
    case location = "location"
    case locationAlways = "locationAlways"
    case locationWhenInUse = "locationWhenInUse"
    case mediaLibrary = "mediaLibrary"
    case microphone = "microphone"
    case photos = "photos"
    case reminders = "reminders"
    case sensors = "sensors"
    case speech = "speech"
}
