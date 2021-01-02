//
//  CloudKey.swift
//
//  Created by William Bradley on 1/2/21.
//

import Foundation

fileprivate let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
fileprivate let bundleIdentifier: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as! String

func getCloudKey(_ name: String) -> String {
    return "\(bundleIdentifier).\(version).\(name)"
}

func getCloudData<T>(_ name: String, _ fallback: T) -> T where T: Decodable {
    if let data = NSUbiquitousKeyValueStore.default.data(forKey: getCloudKey(name)) {
        if let typedData = try? JSONDecoder().decode(T.self, from: data) {
            return typedData
        }
    }
    return fallback
}

func setCloudData<T>(_ name: String, _ value: T) where T: Encodable {
    // TODO: consider a version that throws upon failure.
    if let data = try? JSONEncoder().encode(value) {
        NSUbiquitousKeyValueStore.default.set(data, forKey: getCloudKey(name))
    }
}
