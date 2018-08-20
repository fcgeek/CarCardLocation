//
//  CitySelectViewController.swift
//  CarCardLocation
//
//  Created by liujianlin on 2018/8/15.
//  Copyright © 2018年 liujianlin. All rights reserved.
//

import UIKit

class CitySelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var areas: [AreaModel] = []
    private let tableView = UITableView()
    var didSelectCity: ((_ city: CityModel)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "城市列表"
        view.backgroundColor = UIColor.white
        setupTableView()
        JSHelper.shared.getAreas(inView: view, success: { [weak self](areas) in
            self?.areas = areas
            self?.tableView.reloadData()
            
        }, finally: nil)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(backButtonAction))
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true, completion: nil)
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
//        guard let city = areas[indexPath.section].citys?[indexPath.row] else { return }
//        navigationController?.pushViewController(GasStationListViewController(city: city), animated: true)
        dismiss(animated: true) { [weak self] in
            guard let city = self?.areas[indexPath.section].citys?[indexPath.row] else { return }
            self?.didSelectCity?(city)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return areas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return areas[section].citys?.count ?? 0
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return areas.map({$0.name})
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return areas[section].name
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = areas[indexPath.section].citys?[indexPath.row].name
        return cell
    }
}
