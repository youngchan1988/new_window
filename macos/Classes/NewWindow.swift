//
//  NewWindow.swift
//  new_window
//
//  Created by YoungChan on 2022/11/29.
//

import FlutterMacOS
import Foundation

class NewWindow: NSObject, NSWindowDelegate {
    private static var globalWindowsId: Int = 0
    
    private let window: NSWindow = .init(contentRect: NSRect(x: 0, y: 0, width: 1024, height: 768), styleMask: [.miniaturizable, .closable, .resizable, .titled], backing: .buffered, defer: false)
      
    private lazy var windowController = NSWindowController(window: window)
    private lazy var id: Int = {
        NewWindow.globalWindowsId += 1
        return NewWindow.globalWindowsId
    }()
    
    private let windowClosable: Bool
    
    private let initialPoint: NSPoint?
    
    private let initialSize: NSSize?
    
    private var eventChannel: NewWindowEventChannel?
    
    open var windowId: Int {
        return id
    }
    
    open weak var delegate: NewWindowDelegate?
    
    // return the window id
    init(point: NSPoint?, size: NSSize?, closable: Bool?) {
        windowClosable = closable ?? true
        initialPoint = point
        initialSize = size
        super.init()
        window.delegate = self
    }
    
    deinit {
        delegate = nil
    }
    
    // open the window
    func open(route: String?, arguments: String?) {
        let project = FlutterDartProject()
         
        project.dartEntrypointArguments = ["context://new_window/\(id)?route=\(route ?? "/")&arguments=\(arguments ?? "")"]
        let viewController = FlutterViewController(project: project)
        
        let plugin = viewController.registrar(forPlugin: "NewWindowPlugin")
        
        eventChannel = NewWindowEventChannel(messenger: plugin.messenger)
        
        NewWindowPlugin.register(with: plugin)
        
        // show in the main window's screen
        let mainWindowScreen = NSApp.mainWindow?.screen ?? NSScreen.main
        let screenPoint = mainWindowScreen?.frame.origin ?? NSPoint.zero
       
        var frameOrigin = initialPoint ?? NSPoint.zero
        frameOrigin = NSPoint(x: frameOrigin.x + screenPoint.x, y: frameOrigin.y + screenPoint.y)
        let frameSize = initialSize ?? NSApp.mainWindow?.frame.size ?? NSSize(width: 1024, height: 760)
        
        let showRect = NSRect(origin: frameOrigin, size: frameSize)
        window.contentViewController = viewController
        window.contentRect(forFrameRect: showRect)
        window.setFrame(showRect, display: true, animate: true)
        
        if initialPoint == nil {
            window.center()
        }
//        window.makeKeyAndOrderFront(self)
        
        windowController.contentViewController = window.contentViewController
        windowController.shouldCascadeWindows = true
        windowController.showWindow(self)
    }
    
    // close the window
    func close() {
//        window.orderOut(self)
//        window.close()
        windowController.close()
        window.close()
    }
    
    func sendMessage(fromWindowId: Int, message: String) -> Bool {
        return eventChannel?.emit(withState: NewWindowState.onMessage, andData: ["fromWindowId": fromWindowId, "message": message]) ?? false
    }
    
    // NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        _ = eventChannel?.emit(withState: NewWindowState.onClose, andData: nil)
        if let flutterViewController = window.contentViewController as? FlutterViewController {
            // 延时释放Engine资源
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                flutterViewController.engine.shutDownEngine()
            }
        }
        delegate?.windowWillClose(id: id)
    }
   
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        let ret = eventChannel?.emit(withState: NewWindowState.shouldClose, andData: nil) ?? false
        if !ret {
            return true
        }
        
        return windowClosable
    }
}

public protocol NewWindowDelegate: NSObjectProtocol {
    func windowWillClose(id: Int)
}

enum NewWindowState {
    case shouldClose
    case onClose
    case onMessage
    
    func toString() -> String {
        switch self {
        case .shouldClose:
            return "shouldClose"
        case .onClose:
            return "willClose"
        case .onMessage:
            return "onMessage"
        }
    }
}
