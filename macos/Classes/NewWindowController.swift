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
   
    func createWindow(withPoint point: NSPoint?, andSize size: NSSize?, closable: Bool = true, showTitleBar: Bool = true) -> NewWindow {
        let window = NewWindow(point: point, size: size, closable: closable, showTitleBar: showTitleBar)
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
    }
    
    func isWindowExist(id: Int) -> Bool {
        return NewWindowController.windows[id] != nil
    }
    
    func setTitle(id: Int, title: String) {
        let window = NewWindowController.windows[id]
        window?.setTitle(title: title)
    }
  
    func sendMessage(fromWindowId: Int, toWindowId: Int, message: String) -> Bool {
        let window = NewWindowController.windows[toWindowId]
        return window?.sendMessage(fromWindowId: fromWindowId, message: message) ?? false
    }
    
    // NewWindowDelegate
    func windowWillClose(id: Int) {
        NewWindowController.windows.removeValue(forKey: id)
    }
}
