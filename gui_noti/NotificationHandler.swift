//
//  NotificationHandler.swift
//  Sensor
//
//  Created by 𝐶. on 2024-11-26.
//

import Foundation
import UserNotifications

class NotificationHandler {
    // Request notification permissions
    func askPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Notification permissions granted.")
            } else if let error = error {
                print("Permission error: \(error.localizedDescription)")
            }
        }
    }
    
    // Send a Notification Immediately
    func sendNotification(title: String, body: String) {
        // Notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.interruptionLevel = .timeSensitive // Make the notification prioritized

        // Create a request without a trigger to send the notification immediately
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        
        // Add the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification sent immediately: \(title)")
            }
        }
    }
}

