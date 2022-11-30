//
//  NewWindowChannel.swift
//  new_window
//
//  Created by YoungChan on 2022/11/30.
//

import FlutterMacOS
import Foundation

class NewWindowChannel: NSObject, FlutterStreamHandler {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "new_window", binaryMessenger: registrar.messenger)
        let instance = NewWindowPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    init(messenger: FlutterBinaryMessenger) {
        super.init()
        let channel = FlutterMethodChannel(name: "new_window", binaryMessenger: messenger)
        
    }
    
    // FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        <#code#>
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        <#code#>
    }
}
