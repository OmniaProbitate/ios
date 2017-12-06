//
//  MKPolygon.swift
//  prkng-ios
//
//  Created by Antonino Urbano on 2015-07-02.
//  Copyright (c) 2015 PRKNG. All rights reserved.
//
import MapKit
import Mapbox

extension MKPolygon {
   
    static func polygonsToRMPolygonAnnotations(_ polygons: [MKPolygon], mapView: RMMapView) -> [RMPolygonAnnotation] {

        var polygonAnnotations = [RMPolygonAnnotation]()
        for polygon in polygons {
            let polygonAnnotation = polygon.polygonToRMPolygonAnnotation(mapView)
            polygonAnnotations.append(polygonAnnotation)
        }
        return polygonAnnotations
    }

    func polygonToRMPolygonAnnotation(_ mapView: RMMapView) -> RMPolygonAnnotation {
        
        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: self.pointCount)
        self.getCoordinates(coordsPointer, range: NSMakeRange(0, self.pointCount))
        var locations: [CLLocation] = []
        for i in 0..<self.pointCount {
            let coord = coordsPointer[i]
            locations.append(CLLocation(latitude: coord.latitude, longitude: coord.longitude))
        }
        
        var interiorRMPolygonAnnotations = [RMPolygonAnnotation]()
        for interiorPolygon in self.interiorPolygons as [MKPolygon]! {
            let interiorPolygonAnnotation = interiorPolygon.polygonToRMPolygonAnnotation(mapView)
            interiorRMPolygonAnnotations.append(interiorPolygonAnnotation)
        }
        
        let polygonAnnotation = RMPolygonAnnotation(mapView: mapView, points: locations, interiorPolygons: interiorRMPolygonAnnotations)
        polygonAnnotation.userInfo = ["type": "polygon"]
        polygonAnnotation.fillColor = Styles.Colors.beige1.colorWithAlphaComponent(0.7)
        polygonAnnotation.lineColor = Styles.Colors.red1
        polygonAnnotation.lineWidth = 4.0

        return polygonAnnotation
    }
    
//    func toMGLPolygon() -> MGLPolygon {
//        let coordsPointer = UnsafeMutablePointer<CLLocationCoordinate2D>.alloc(self.pointCount)
//        self.getCoordinates(coordsPointer, range: NSMakeRange(0, self.pointCount))
//        let mglPolygon = MGLPolygon(coordinates: coordsPointer, count: UInt(self.pointCount))
//        return mglPolygon
//    }
//
//    static func toMGLPolygons(polygons: [MKPolygon]) -> [MGLPolygon] {
//        
//        var mglPolygons = [MGLPolygon]()
//        for polygon in polygons {
//            let mglPolygon = polygon.toMGLPolygon()
//            mglPolygons.append(mglPolygon)
//        }
//        return mglPolygons
//    }
    
    static func invertPolygons(_ polygons: [MKPolygon]) -> MKPolygon {
        
        var worldCorners: [MKMapPoint] = [
            MKMapPoint(x: 0, y: 0),
            MKMapPoint(x: MKMapSizeWorld.width, y: 0),
            MKMapPoint(x: MKMapSizeWorld.width, y: MKMapSizeWorld.height),
            MKMapPoint(x: 0, y: MKMapSizeWorld.height),
            MKMapPoint(x: 0, y: 0)]
        let worldCornersPointer = UnsafeMutablePointer<MKMapPoint>.allocate(capacity: worldCorners.count)
        for i in 0..<worldCorners.count {
            worldCornersPointer[i] = worldCorners[i]
        }
        
        let polygon = MKPolygon(points: worldCornersPointer, count: worldCorners.count, interiorPolygons: polygons)

        return polygon
    }
    
    static func interiorPolygons(_ polygons: [MKPolygon]) -> [MKPolygon] {

        var interiorPolygons = [MKPolygon]()
        for polygon in polygons {
            interiorPolygons += (polygon.interiorPolygons as [MKPolygon]!)
        }
        return interiorPolygons
        
    }
}
