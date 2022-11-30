//
//  NewWindowError.swift
//  new_window
//
//  Created by YoungChan on 2022/11/30.
//

import Foundation

class NewWindowError: NSObject {
    private var errorCode: NewWindowErrorCode?

    private var errorMessage: String?

    open var code: String {
        return errorCode?.toString() ?? ""
    }

    open var message: String? {
        return errorMessage
    }

    init(withCode code: NewWindowErrorCode, andMessage message: String) {
        super.init()
        errorCode = code
        errorMessage = message
    }

    static func argumentError(message: String) -> NewWindowError {
        return NewWindowError(withCode: NewWindowErrorCode.argumentError, andMessage: message)
    }

    static func createWindowError(message: String) -> NewWindowError {
        return NewWindowError(withCode: NewWindowErrorCode.createWindowError, andMessage: message)
    }
}

enum NewWindowErrorCode {
    case argumentError
    case createWindowError

    func toString() -> String {
        switch self {
        case .argumentError:
            return "40"
        case .createWindowError:
            return "100"
        }
    }
}
