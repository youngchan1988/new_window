//
//  NewWindowChannel.swift
//  new_window
//
//  Created by YoungChan on 2022/11/30.
//

import FlutterMacOS
import Foundation

class NewWindowEventChannel: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    init(messenger: FlutterBinaryMessenger) {
        super.init()
        let channel = FlutterEventChannel(name: "new_window_event", binaryMessenger: messenger)
        channel.setStreamHandler(self)
    }
    
    deinit {
        eventSink = nil
    }
    
    func emit(withState state: NewWindowState, andData userData: [String: Any]?) -> Bool {
        guard let eventSink = eventSink else {
            return false
        }
        var data = ["state": state.toString()] as [String: Any]
        if userData != nil {
            data["userData"] = userData
        }
        eventSink(data)
        return true
    }
    
    // FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        print("EventChannel onListen: \(arguments)")
        
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
