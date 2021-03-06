//
//  ProxyService.swift
//  Potatso
//
//  Created by LEI on 12/28/15.
//  Copyright © 2015 TouchingApp. All rights reserved.
//

import Foundation
import Async
import PotatsoModel
import Appirater
import PotatsoLibrary

class VPN {
    
    static func switchVPN(group: ConfigurationGroup, completion: ((ErrorType?) -> Void)? = nil) {
        let defaultUUID = Manager.sharedManager.defaultConfigGroup.uuid
        let isDefault = defaultUUID == group.uuid
        if !isDefault
        {
            Manager.sharedManager.stopVPN()
            Async.main(after: 1) {
                _switchDefaultVPN(group, completion: completion)
            }
        }
        else
        {
            _switchDefaultVPN(group, completion: completion)
        }
    }

    // 一个group对象包含了shadossock连接的配置信息：服务器信息、过滤条件、名字、是否全局等
    private static func _switchDefaultVPN(group: ConfigurationGroup, completion: ((ErrorType?) -> Void)? = nil) {
        do {
            try Manager.sharedManager.setDefaultConfigGroup(group)
        }catch{
            Async.main{
                completion?(error)
            }
        }
        
        
        Manager.sharedManager.switchVPN { (manager, error) in
            if let _ = manager
            {
                Async.background(after: 2, block: { () -> Void in
                    Appirater.userDidSignificantEvent(false)
                })
            }
            Async.main
            {
                completion?(error)
            }
        }
    }
    
}
