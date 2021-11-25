//
//  UserActivityType.swift
//  IVPN iOS app
//  https://github.com/ivpn/ios-app
//
//  Created by Juraj Hilje on 2019-05-23.
//  Copyright (c) 2020 Privatus Limited.
//
//  This file is part of the IVPN iOS app.
//
//  The IVPN iOS app is free software: you can redistribute it and/or
//  modify it under the terms of the GNU General Public License as published by the Free
//  Software Foundation, either version 3 of the License, or (at your option) any later version.
//
//  The IVPN iOS app is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
//  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
//  details.
//
//  You should have received a copy of the GNU General Public License
//  along with the IVPN iOS app. If not, see <https://www.gnu.org/licenses/>.
//

import Foundation

enum UserActivityType {
    static let Connect = "net.ivpn.clients.ios.Connect"
    static let Disconnect = "net.ivpn.clients.ios.Disconnect"
    static let AntiTrackerEnable = "net.ivpn.clients.ios.AntiTracker.enable"
    static let AntiTrackerDisable = "net.ivpn.clients.ios.AntiTracker.disable"
    static let CustomDNSEnable = "net.ivpn.clients.ios.CustomDNS.enable"
    static let CustomDNSDisable = "net.ivpn.clients.ios.CustomDNS.disable"
}
