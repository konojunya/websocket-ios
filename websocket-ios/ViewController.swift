//
//  ViewController.swift
//  websocket-ios
//
//  Created by konojunya on 2017/07/06.
//  Copyright © 2017年 konojunya. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBAction func send(_ sender: Any) {
        self.socket.emit("from_client","oppai!")
    }
    
    let socketURL = URL(string: "")
    var dataList:NSMutableArray!
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.dataList = NSMutableArray()
        
        socket = SocketIOClient(socketURL: self.socketURL!)
        socket.on("connect") { data, ack in
            print("socket connected!")
        }
        socket.on("disconnect") { data, ack in
            print("socket disconnected!")
        }
        
        socket.on("from_server") { data, emitter in
            if let message = data as? [String] {
                print(message[0])
                self.dataList.insert(message[0], at: 0)
                self.tableView.reloadData()
            }
        }
        socket.connect()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = self.dataList[indexPath.row] as? String
        
        return cell
    }

}

