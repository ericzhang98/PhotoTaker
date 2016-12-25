//
//  KeychainManager.swift
//  PhotoTaker
//
//  Created by Eric Zhang on 12/24/16.
//  Copyright © 2016 Eric Zhang. All rights reserved.
//

import Foundation

public enum KeychainError:Error {
    case InvalidInput                      // If the value cannot be encoded as NSData
    case OperationUnimplemented         // -4 | errSecUnimplemented
    case InvalidParam                     // -50 | errSecParam
    case MemoryAllocationFailure         // -108 | errSecAllocate
    case TrustResultsUnavailable         // -25291 | errSecNotAvailable
    case AuthFailed                       // -25293 | errSecAuthFailed
    case DuplicateItem                   // -25299 | errSecDuplicateItem
    case ItemNotFound                    // -25300 | errSecItemNotFound
    case ServerInteractionNotAllowed    // -25308 | errSecInteractionNotAllowed
    case DecodeError                      // - 26275 | errSecDecode
    case Unknown(Int)                    // Another error code not defined
}

/* Adds, deletes, and queries keychain data */
public struct KeychainManager {
 
    static func mapResultCode(result:OSStatus) -> KeychainError? {
        switch result {
        case 0:
            return nil
        case -4:
            return .OperationUnimplemented
        case -50:
            return .InvalidParam
        case -108:
            return .MemoryAllocationFailure
        case -25291:
            return .TrustResultsUnavailable
        case -25293:
            return .AuthFailed
        case -25299:
            return .DuplicateItem
        case -25300:
            return .ItemNotFound
        case -25308:
            return .ServerInteractionNotAllowed
        case -26275:
            return .DecodeError
        default:
            return .Unknown(result.hashValue)
        }
    }
    
    public static func addData(imageKey:String, imageData:Data) {
        let queryAdd:[String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: imageKey as AnyObject,
            kSecValueData as String: imageData as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        
        let resultCode:OSStatus = SecItemAdd(queryAdd as CFDictionary, nil)
        
        if let err = mapResultCode(result: resultCode) {
            print("KeychainManager: Error " + err.localizedDescription)
        }
        else {
            print("KeychainManager: Successfully added data")
        }
    }
    
    public static func deleteData(itemKey:String) {
        let queryDelete:[String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject
        ]
        
        let resultCode:OSStatus = SecItemDelete(queryDelete as CFDictionary)
        
        if let err = mapResultCode(result: resultCode) {
            print("KeychainManager: Error " + err.localizedDescription)
        }
        else {
            print("KeychainManager: Successfully deleted data")
        }
    }
    
    public static func queryData(itemKey:String) -> Data{
        let queryLoad:[String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var retrievedData: AnyObject?
        let resultCode:OSStatus = SecItemCopyMatching(queryLoad as CFDictionary, &retrievedData)
        
        if let err = mapResultCode(result: resultCode) {
            print("KeychainManager: Error " + err.localizedDescription)
        }
        else {
            print("KeychainManager: Successfully queried data")
        }
        
        return retrievedData as! Data
    }
}
