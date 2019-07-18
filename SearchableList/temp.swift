//
//  temp.swift
//  SearchableList
//
//  Created by Anilkumar kotur on 17/07/19.
//  Copyright © 2019 GoJek. All rights reserved.
//

import Foundation
func emojiFlag(regionCode: String) -> String? {
    let code = regionCode.uppercased()
    
    guard Locale.isoRegionCodes.contains(code) else {
        return nil
    }
    
    
    
    var flagString = ""
    for s in code.unicodeScalars {
        guard let scalar = UnicodeScalar(127397 + s.value) else {
            continue
        }
        flagString.append(String(scalar))
    }
    return flagString
}

func countryName(from countryCode: String) -> String {
    if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
        return name
    } else {
        
        return countryCode
    }
}

func someThing() {
    let _ = Locale.isoRegionCodes.forEach { print(countryName(from: $0) + ": " + emojiFlag(regionCode: $0)! + ": " + $0) }
}
