//
//  ipAddress.swift
//  om-17
//
//  Created by Charlie Giannis on 2023-06-07.
//

import Foundation


func updateGlobalIPAddress(with newValue: String) {
    UserDefaults.standard.set(newValue, forKey: "globalIPAddress")
}

func globalIPAddress() -> String {
    let defaultIP: String = UserDefaults.standard.string(forKey: "globalIPAddress") ?? ""
    if (defaultIP == "") {
        return ""
    } else {
        return defaultIP
    }
}
