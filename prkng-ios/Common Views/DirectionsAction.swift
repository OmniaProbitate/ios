//
//  DirectionsAction.swift
//  prkng-ios
//
//  Created by Antonino Urbano on 2015-10-02.
//  Copyright © 2015 PRKNG. All rights reserved.
//

import UIKit

class DirectionsAction {
    
    static let prkng_directions_monitor = "prkng_directions_monitor"
    
    static func perform(onViewController viewController: UIViewController, withCoordinate coordinate: CLLocationCoordinate2D, shouldCallback: Bool) {
        
        let coordinateString = String(stringInterpolationSegment: coordinate.latitude) + "," + String(stringInterpolationSegment: coordinate.longitude)
        
        let appleMapsURLString = "http://maps.apple.com/?saddr=Current%20Location&daddr=" + coordinateString
        
        let googleMapsURLString = "comgooglemaps-x-callback://?saddr=&daddr=" + coordinateString + "&x-success=ng.prk.prkng-ios://?returningFromGoogleMaps=true&x-source=Prkng"
        
        let supportsGoogleMaps = UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!)
        
        if shouldCallback {
            //set up a region monitored
            self.removeDirectionRegionMonitoring()
            let delegate = UIApplication.shared.delegate as! AppDelegate
            let region = CLCircularRegion(center: coordinate, radius: 100, identifier: self.prkng_directions_monitor)
            delegate.locationManager.startMonitoring(for: region)
        }

        if supportsGoogleMaps {
            
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "directions".localizedString, message: "directions_app_message".localizedString, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "directions_google_maps_message".localizedString, style: .default, handler: { (alert) -> Void in
                    UIApplication.shared.openURL(URL(string: googleMapsURLString)!)
                }))
                alert.addAction(UIAlertAction(title: "directions_apple_maps_message".localizedString, style: .default, handler: { (alert) -> Void in
                    UIApplication.shared.openURL(URL(string: appleMapsURLString)!)
                }))
                alert.addAction(UIAlertAction(title: "cancel".localizedString, style: .cancel, handler: nil))
                viewController.present(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
                //TODO: PUT SOMETHING HERE FOR IOS 7
            }
            
        } else {
            
            UIApplication.shared.openURL(URL(string: appleMapsURLString)!)
            
        }

    }
    
    static func removeDirectionRegionMonitoring() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        for monitoredRegion in delegate.locationManager.monitoredRegions as! Set<CLCircularRegion> {
            if monitoredRegion.identifier.range(of: self.prkng_directions_monitor) != nil {
                delegate.locationManager.stopMonitoring(for: monitoredRegion)
            }
        }

    }
    
    static func isDirectionRegionMonitoring() -> Bool {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        for monitoredRegion in delegate.locationManager.monitoredRegions as! Set<CLCircularRegion> {
            if monitoredRegion.identifier.range(of: self.prkng_directions_monitor) != nil {
                return true
            }
        }
        
        return false
    }
    
    static func handleDirectionRegionEntered() {
        self.removeDirectionRegionMonitoring()
        
        //next create the alert
        let alert = UILocalNotification()
        alert.alertBody = "return_to_app".localizedString
        alert.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.presentLocalNotificationNow(alert)
    }
}
