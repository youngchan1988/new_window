//
//  NewWindowController.swift
//  new_window
//
//  Created by YoungChan on 2022/11/29.
//

import FlutterMacOS
import Foundation

class NewWindowController: NSObject, NewWindowDelegate {
    private static var windows = [Int: NewWindow]()
   
    func createWindow(withRect rect: NSRect?, closable: Bool?) -> NewWindow {
        let window = NewWindow(rect: rect, closable: closable)
        window.delegate = self
        NewWindowController.windows[window.windowId] = window
        
        return window
    }
    
    func showWindow(id: Int, route: String?, arguments: String?) {
        let window = NewWindowController.windows[id]
        window?.open(route: route, arguments: arguments)
    }
    
    func closeWindow(id: Int) {
        let window = NewWindowController.windows[id]
        window?.close()
        NewWindowController.windows.removeValue(forKey: id)
    }
    
    func isWindowExist(id: Int) -> Bool {
        return NewWindowController.windows[id] != nil
    }
    
    // NewWindowDelegate
    func windowWillClose(id: Int) {
        NewWindowController.windows.removeValue(forKey: id)
    }
}
