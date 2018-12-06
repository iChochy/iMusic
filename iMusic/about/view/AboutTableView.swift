//
//  List.swift
//  iMusic
//
//  Created by MLeo on 2018/11/23.
//  Copyright © 2018年 swift. All rights reserved.
//

import UIKit

class AboutTableView: UITableView,UITableViewDelegate,UITableViewDataSource {
    
    let cellID = "cell"
    var logoView:UIImageView!
    var appVersionLabel:UILabel!
    var copyrightLabel:UILabel!
    var touchCellFunction:((_ data:AboutGroup.Detail) -> Void)!
    
    lazy var datas:[AboutGroup]? = AboutDataSource.shared.datas
    
    convenience init(_ perant:UIView) {
        self.init()
        addTableView(perant)
        addTableHeaderView()
        addTableFooterView()
    }
    
    
    private func addTableHeaderView(){
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        addLogo(view)
        addAppVersion(view)
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        tableHeaderView.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: tableHeaderView.centerXAnchor),
            view.topAnchor.constraint(equalTo: tableHeaderView.topAnchor)
            ])
        self.tableHeaderView = tableHeaderView
    }
    
    
    private func addTableFooterView(){
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        addCopyright(view)
        let size = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        tableFooterView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo:tableFooterView.topAnchor),
            view.centerXAnchor.constraint(equalTo: tableFooterView.centerXAnchor)
            ])
        self.tableFooterView = tableFooterView
        
    }
    
    private func addTableView(_ perant:UIView){
        self.frame = perant.frame
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        perant.addSubview(self)
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: perant.topAnchor),
            self.leadingAnchor.constraint(equalTo: perant.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: perant.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: perant.bottomAnchor)
            ])
    }
    
    
    
    private func addLogo(_ perant:UIView){
        logoView = UIImageView(image: UIImage(named: "logo"))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        perant.addSubview(logoView)
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: perant.topAnchor, constant: 20),
            logoView.centerXAnchor.constraint(equalTo: perant.centerXAnchor),
            logoView.widthAnchor.constraint(equalTo: perant.widthAnchor, multiplier: 0.2),
            logoView.heightAnchor.constraint(equalTo: logoView.widthAnchor)
            ])
    }
    
    
    private func addAppVersion(_ perant:UIView){
        appVersionLabel = UILabel()
        appVersionLabel.text = getAppVersion()
        appVersionLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        appVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        perant.addSubview(appVersionLabel)
        NSLayoutConstraint.activate([
            appVersionLabel.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 5),
            appVersionLabel.centerXAnchor.constraint(equalTo: perant.centerXAnchor),
            appVersionLabel.bottomAnchor.constraint(equalTo: perant.bottomAnchor,constant: -10)
            ])
    }
    
    private func addCopyright(_ perant:UIView){
        copyrightLabel = UILabel()
        copyrightLabel.text = Copyright
        copyrightLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        perant.addSubview(copyrightLabel)
        NSLayoutConstraint.activate([
            copyrightLabel.topAnchor.constraint(equalTo: perant.topAnchor,constant: 10),
            copyrightLabel.centerXAnchor.constraint(equalTo: perant.centerXAnchor),
            copyrightLabel.bottomAnchor.constraint(equalTo: perant.bottomAnchor, constant: -10)
            ])
    }
    
    
    private func getAppVersion() -> String?{
        let infoDictionary =  Bundle.main.infoDictionary
        guard let info = infoDictionary else {
            return nil
        }
        return "\(info["CFBundleDisplayName"] ?? "iMusic")V\(info["CFBundleShortVersionString"] ?? 0)\(info["CFBundleVersion"] ?? 0)"
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return datas?.count ?? 0
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let details = datas?[section].details
        return details?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datas?[section].groupName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellID)
            cell?.accessoryType = .disclosureIndicator
        }
        cell?.textLabel?.text = datas?[indexPath.section].details?[indexPath.row].title
        return cell!
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let data = datas?[indexPath.section].details?[indexPath.row]
        touchCellFunction(data!)
    }
    
    
    func touchCellCallback(completion: @escaping (_ data:AboutGroup.Detail) -> Void){
        self.touchCellFunction = completion
    }
    
    
    
}
