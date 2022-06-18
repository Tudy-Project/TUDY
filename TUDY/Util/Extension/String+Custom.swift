//
//  String+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/31.
//

import Foundation

extension String {

    func projectDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        let cur = Date()
        
        guard let distanceDay = Calendar.current.dateComponents([.day], from: date, to: cur).day else { return "" }
        if 0 < distanceDay {
            return "\(distanceDay)일 전"
        }
        
        guard let distanceHour = Calendar.current.dateComponents([.hour], from: date, to: cur).hour else { return "" }
        if 0 < distanceHour {
            return "\(distanceHour)시간 전"
        }
        
        guard let distanceMinute = Calendar.current.dateComponents([.hour], from: date, to: cur).hour else { return "" }
        
        return "\(distanceMinute)분 전"
    }

    func chatListDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let monthDayFormatter = DateFormatter()
        monthDayFormatter.dateFormat = "M월 d일"
        let hourMinuteFormatter = DateFormatter()
        hourMinuteFormatter.dateFormat = "a h:mm"
        
        guard let date = dateFormatter.date(from: self) else { fatalError() }
        let cur = Date()
        
        guard let distanceDay = Calendar.current.dateComponents([.day], from: date, to: cur).day else { return "" }
        if 1 == distanceDay {
            return "어제"
        } else if 1 < distanceDay {
            return monthDayFormatter.string(from: date)
        }
        
        guard let distanceHour = Calendar.current.dateComponents([.hour], from: date, to: cur).hour else { return "" }
        if 0 < distanceHour {
            return "\(distanceHour)시간 전"
        }
        
        return hourMinuteFormatter.string(from: date)
    }
    
    func chatChangedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        return dateFormatter.string(from: date)
    }
    
    func subwayLineName() -> String {
        switch self {
        case "01호선":
            return "one"
        case "02호선":
            return "two"
        case "03호선":
            return "three"
        case "04호선":
            return "four"
        case "05호선":
            return "five"
        case "06호선":
            return "six"
        case "07호선":
            return "seven"
        case "08호선":
            return "eight"
        case "09호선":
            return "nine"
        case "수인분당선":
            return "suinbundang"
        case "인천선":
            return "incheon"
        case "인천2호선":
            return "incheon2"
        case "경의선":
            return "kyungEu"
        case "공항철도":
            return "airport"
        case "신분당선":
            return "shinbundang"
        case "경춘선":
            return "kyungchun"
        case "의정부경전철":
            return "euijungbu"
        case "용인경전철":
            return "yonginkyungjuncheol"
        case "경강선":
            return "kyungkang"
        case "우이신설경전철":
            return "uie"
        case "서해선":
            return "seohae"
        case "김포도시철도":
            return "kimpo"
        case "신림선":
            return "shinrim"
        default:
            break
        }
        return ""
    }
}
