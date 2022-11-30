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
    
    func emit(withWindowId id: Int, andState state: NewWindowState) -> Bool {
        guard let eventSink = eventSink else {
            return false
        }
        eventSink(["id": id, "state": state.toString()])
        return true
    }
    
    // FlutterStreamHandler
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
