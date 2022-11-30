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
    
    private let window: NSWindow = .init(contentRect: NSRect(x: 0, y: 0, width: 1024, height: 768), styleMask: [.miniaturizable, .closable, .resizable, .titled, .fullSizeContentView], backing: .buffered, defer: false)
    
    private lazy var windowController = NSWindowController(window: window)
    
    private lazy var id: Int = {
        NewWindow.globalWindowsId += 1
        return NewWindow.globalWindowsId
    }()
    
    private var closable: Bool = true
    
    private var rect: NSRect = .init(x: 0, y: 0, width: 1024, height: 768)
    
    private var eventChannel: NewWindowEventChannel?
    
    open var windowId: Int {
        return id
    }
    
    open weak var delegate: NewWindowDelegate?
    
    // return the window id
    init(rect: NSRect?, closable: Bool?) {
        super.init()
        self.closable = closable ?? true
        self.rect = rect ?? NSRect(x: 0, y: 0, width: 1024, height: 768)
        window.delegate = self
        window.isReleasedWhenClosed = true
    }
    
    deinit {
        delegate = nil
        if let flutterViewController = windowController.contentViewController as? FlutterViewController {
            flutterViewController.engine.shutDownEngine()
        }
    }
    
    // open the window
    func open(route: String?, arguments: String?) {
        let project = FlutterDartProject()
         
        project.dartEntrypointArguments = ["context://new_window/\(id)?route=\(route ?? "/")&arguments=\(arguments ?? "")"]
        let viewController = FlutterViewController(project: project)
        
        let plugin = viewController.registrar(forPlugin: "NewWindowPlugin")
        
        eventChannel = NewWindowEventChannel(messenger: plugin.messenger)
        
        NewWindowPlugin.register(with: plugin)
        
        window.contentViewController = viewController
        window.contentRect(forFrameRect: rect)
        window.setFrame(rect, display: true, animate: true)
        
        windowController.contentViewController = window.contentViewController
        windowController.shouldCascadeWindows = true
        windowController.showWindow(self)
//        window.makeKeyAndOrderFront(nil)
//        NSApp.activate(ignoringOtherApps: true)
    }
    
    // close the window
    func close() {
        windowController.close()
    }
    
    // NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        delegate?.windowWillClose(id: id)
        _ = eventChannel?.emit(withWindowId: id, andState: NewWindowState.onClose)
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        let ret = eventChannel?.emit(withWindowId: id, andState: NewWindowState.shouldClose) ?? false
        if !ret {
            return true
        }
        
        return closable
    }
}

public protocol NewWindowDelegate: NSObjectProtocol {
    func windowWillClose(id: Int)
}

enum NewWindowState {
    case shouldClose
    case onClose
    
    func toString() -> String {
        switch self {
        case .shouldClose:
            return "shouldClose"
        case .onClose:
            return "willClose"
        }
    }
}
