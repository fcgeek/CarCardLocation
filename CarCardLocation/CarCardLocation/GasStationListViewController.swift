//
//  GasStationListViewController.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/16.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift

class GasStationListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let tableView = UITableView()
    private var city: CityModel!
    private var gasStations: [GasStationModel] = []
    
    init(city: CityModel) {
        super.init(nibName: nil, bundle: nil)
        self.city = city
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = city.name
        GasStationManager.shared.currentCity = city
        // Do any additional setup after loading the view.
        JSHelper.shared.getCurrentGasStations(inView: view) { [weak self](gasStations) in
            self?.gasStations = gasStations
            self?.tableView.reloadData()
        }
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.rowHeight = 48
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.tableFooterView = UIView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let realm = try? Realm()
        guard realm?.object(ofType: GasStationModel.self, forPrimaryKey: gasStations[indexPath.row].address) == nil else { return }
        CLGeocoder().geocodeAddressString("\(city.name ?? "")\(gasStations[indexPath.row].address)", completionHandler: { [weak self](placemarks, error) in
            guard let gasStation = self?.gasStations[indexPath.row] else { return }
            if error == nil {
                guard let coordinate = placemarks?.first?.location?.coordinate else { return }
                gasStation.latitude = coordinate.latitude
                gasStation.longitude = coordinate.longitude
                gasStation.cityName = self?.city?.name ?? ""
                try? realm?.write {
                    realm?.add(gasStation, update: true)
                }
                self?.gasStations.append(gasStation)
                GasStationManager.shared.delegate?.gasStationManager(GasStationManager.shared, didAddGasStation: gasStation.latitude, longitude: gasStation.longitude, name: gasStation.name)
                tableView.reloadData()
            } else {
                print("\(self?.city?.name ?? "")\(gasStation.address)")
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        let realm = try? Realm()
        cell.textLabel?.text = "\(indexPath.row) -- \(realm?.object(ofType: GasStationModel.self, forPrimaryKey: gasStations[indexPath.row].address) != nil ? "✅" : "") -- \(gasStations[indexPath.row].region) -- \(gasStations[indexPath.row].address)"
        return cell
    }
}
