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
                let error = NewWindowError.argumentError(message: "createWindow Arguments: arguments must be Dictionary")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            guard let x = arguments?["px"] as? Double? else {
                let error = NewWindowError.argumentError(message: "createWindow Arguments: The field 'px' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let y = arguments?["py"] as? Double? else {
                let error = NewWindowError.argumentError(message: "createWindow Arguments: The field 'py' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let width = arguments?["width"] as? Double? else {
                let error = NewWindowError.argumentError(message: "createWindow Arguments: The field 'width' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let height = arguments?["height"] as? Double? else {
                let error = NewWindowError.argumentError(message: "createWindow Arguments: The field 'height' must be Double")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let closable = arguments?["closable"] as? Bool? else {
                let error = NewWindowError.argumentError(message: "createWindow Arguments: The field 'closable' must be Bool")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            var point: NSPoint?
            if x != nil, y != nil {
                point = NSPoint(x: x!, y: y!)
            }
            var size: NSSize?
            if width != nil, height != nil {
                size = NSSize(width: width!, height: height!)
            }
            let window = windowController.createWindow(withPoint: point, andSize: size, closable: closable)
            result(window.windowId)
        case "showWindow":
            guard let arguments = call.arguments as? [String: Any]? else {
                let error = NewWindowError.argumentError(message: "showWindow Arguments: arguments must be Dictionary")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let windowId = arguments?["windowId"] as? Int else {
                let error = NewWindowError.argumentError(message: "showWindow Arguments: Lack the 'windowId' field or not Int type")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let route = arguments?["route"] as? String? else {
                let error = NewWindowError.argumentError(message: "showWindow Arguments: The field 'route' must be String")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            guard let windowArgs = arguments?["args"] as? String? else {
                let error = NewWindowError.argumentError(message: "showWindow Arguments: The field 'args' must be String")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }

            windowController.showWindow(id: windowId, route: route, arguments: windowArgs)
            result(nil)
        case "closeWindow":
            guard let windowId = call.arguments as? Int else {
                let error = NewWindowError.argumentError(message: "closeWindow need a window id")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            result(nil)
            windowController.closeWindow(id: windowId)
        case "sendMessage":
            guard let arguments = call.arguments as? [String: Any] else {
                let error = NewWindowError.argumentError(message: "sendMessage Arguments: arguments must be Dictionary!")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            guard let fromWindowId = arguments["fromWindowId"] as? Int else {
                let error = NewWindowError.argumentError(message: "sendMessage Arguments: The field 'fromWindowId' must be Int!")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            guard let toWindowId = arguments["toWindowId"] as? Int else {
                let error = NewWindowError.argumentError(message: "sendMessage Arguments: The field 'toWindowId' must be Int!")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            guard let message = arguments["message"] as? String else {
                let error = NewWindowError.argumentError(message: "sendMessage Arguments: The field 'message' must be String!")
                result(FlutterError(code: error.code, message: error.message, details: nil))
                return
            }
            windowController.sendMessage(fromWindowId: fromWindowId, toWindowId: toWindowId, message: message)

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
