//
//  ImageDetailView.swift
//  cekilis
//
//  Created by Ezagor on 10.04.2024.
//


import SwiftUI
import UIKit
import Photos

// Extension to help with associating objects to NSObject subclasses
extension NSObject {
    func setAssociatedObject<T>(_ value: T, associativeKey: UnsafeRawPointer, policy: objc_AssociationPolicy) {
        objc_setAssociatedObject(self, associativeKey, value, policy)
    }
    
    func getAssociatedObject<T>(_ associativeKey: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, associativeKey) as? T
    }
}


