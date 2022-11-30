import Cocoa
import FlutterMacOS

public class NewWindowPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "new_window", binaryMessenger: registrar.messenger)
        let instance = NewWindowPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    private let windowController = NewWindowController()

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
        case "createWindow":
            guard let arguments = call.arguments as? [String: Any]? else {
                let error = NewWindowError.argumentError(message: "CreateWindow Arguments: arguments must be Dictionary")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            guard let x = arguments?["px"] as? Double? else {
                let error = NewWindowError.argumentError(message: "CreateWindow Arguments: The field 'px' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let y = arguments?["py"] as? Double? else {
                let error = NewWindowError.argumentError(message: "CreateWindow Arguments: The field 'py' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let width = arguments?["width"] as? Double? else {
                let error = NewWindowError.argumentError(message: "CreateWindow Arguments: The field 'width' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let height = arguments?["height"] as? Double? else {
                let error = NewWindowError.argumentError(message: "CreateWindow Arguments: The field 'height' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let closable = arguments?["closable"] as? Bool? else {
                let error = NewWindowError.argumentError(message: "CreateWindow Arguments: The field 'closable' must be Bool")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            let position = NSPoint(x: x ?? 0, y: y ?? 0)
            let size = NSSize(width: width ?? 1024, height: height ?? 768)

            let window = windowController.createWindow(withRect: NSRect(origin: position, size: size), closable: closable)
            result(window.windowId)
        case "showWindow":
            guard let arguments = call.arguments as? [String: Any]? else {
                let error = NewWindowError.argumentError(message: "ShowWindow Arguments: arguments must be Dictionary")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let windowId = arguments?["windowId"] as? Int else {
                let error = NewWindowError.argumentError(message: "ShowWindow Arguments: Lack the 'windowId' field or not Int type")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let route = arguments?["route"] as? String? else {
                let error = NewWindowError.argumentError(message: "ShowWindow Arguments: The field 'route' must be String")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let windowArgs = arguments?["args"] as? String? else {
                let error = NewWindowError.argumentError(message: "ShowWindow Arguments: The field 'args' must be String")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            windowController.showWindow(id: windowId, route: route, arguments: windowArgs)
            result(nil)
        case "closeWindow":
            guard let windowId = call.arguments as? Int else {
                let error = NewWindowError.argumentError(message: "CloseWindow need a window id")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            windowController.closeWindow(id: windowId)
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
