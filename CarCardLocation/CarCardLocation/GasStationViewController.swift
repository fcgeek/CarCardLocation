//
//  GasStationViewController.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/15.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RealmSwift

class GasStationViewController: UIViewController {

    private let locationButton = UIButton()
    private let mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white        
        
        let loc = CLLocationCoordinate2DMake(CLLocationDegrees(0), CLLocationDegrees(0))
        PXTLocationManager.shared.delegate = self
        
        let region = MKCoordinateRegion.init(center: loc, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        locationButton.setImage(#imageLiteral(resourceName: "imgLocation"), for: UIControlState())
        locationButton.layer.masksToBounds = true
        locationButton.layer.cornerRadius = 30
        locationButton.layer.borderWidth = 1
        locationButton.layer.borderColor = UIColor.gray.cgColor
        locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        view.addSubview(locationButton)
        locationButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(-defaultMargin)
            make.bottom.equalTo(-view.comp.safeArea.bottom-defaultMargin)
            make.size.equalTo(60)
        }
        GasStationManager.shared.delegate = self
        if let gasStations = (try? Realm())?.objects(GasStationModel.self),
            gasStations.count > 0 {
            GasStationManager.shared.fetchGasStationLocation(nil)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        PXTLocationManager.shared.start()        
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        locationButton.snp.updateConstraints { (make) in
            make.bottom.equalTo(-view.comp.safeArea.bottom-defaultMargin)
        }
    }
    
    @objc private func locationButtonAction() {
        let cityVC = CitySelectViewController()
        cityVC.didSelectCity = { [weak self]city in
            GasStationManager.shared.currentCity = city
            GasStationManager.shared.fetchGasStation(showInView: self?.view)
        }
        let navVC = UINavigationController.init(rootViewController: cityVC)
        present(navVC, animated: true) {}
    }
}

//MARK: - GasStationManagerDelegate
extension GasStationViewController: GasStationManagerDelegate {
    func gasStationManager(_ manager: GasStationManager, didAddGasStation latitude: CLLocationDegrees, longitude: CLLocationDegrees, name: String) {
        let pointAnnotation = MKPointAnnotation()
        let loc = CLLocationCoordinate2DMake(latitude, longitude)
        pointAnnotation.coordinate = loc
        pointAnnotation.title = name
        
        let pointView = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "MKPinAnnotationView")
        pointView.image = #imageLiteral(resourceName: "imgLocation")
        mapView.addAnnotation(pointAnnotation)
    }
    
    func gasStationManagerWillChangeGasStations(_ manager: GasStationManager) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
}

//MARK: - PXTLocationManagerDelegate
extension GasStationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let region = MKCoordinateRegion.init(center: userLocation.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let sheetController = MapHelper.shared.getMapSheet(withTitle: view.annotation?.title ?? "", lat: view.annotation?.coordinate.latitude.toCGFloat, lng: view.annotation?.coordinate.longitude.toCGFloat)
        presentVC(sheetController)
    }
}

//MARK: - PXTLocationManagerDelegate
extension GasStationViewController: PXTLocationManagerDelegate {
    func pxtLocationManagerDidSuccess(_ manager: PXTLocationManager) {
    }
    
    func pxtLocationManagerDidReject(_ manager: PXTLocationManager) {
        
    }
    
    func pxtLocationManager(_ manager: PXTLocationManager, didUnknown reason: String) {
        
    }
    
    func pxtLocationManagerDidAuthSuccess(_ manager: PXTLocationManager) {
        
    }
}
