//
//  ABTest.swift
//  TwitterClone
//
//  Created by Ali Eldeeb on 10/12/22.
//

import Foundation
import Firebase
import FirebaseRemoteConfigSwift

class AbTest {
    static let shared = AbTest()
    var remoteConfig: RemoteConfig
    
    init() {
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
}

