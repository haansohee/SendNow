//
//  String+.swift
//  SendNow
//
//  Created by 한소희 on 3/26/24.
//

import Foundation


extension String {
    func matchRegularExpression(_ pattern: String) -> Bool {
        let range = NSRange(location: 0, length: self.utf16.count)
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return false }
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    var isValidNickname: Bool {
        return self.matchRegularExpression("^[a-zA-Z0-9ㄱ-ㅎㅏ-ㅣ가-힣_]{3,16}$")
    }
    
    var isValidPassword: Bool {
        return self.matchRegularExpression("^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,30}")
    }
    
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}
