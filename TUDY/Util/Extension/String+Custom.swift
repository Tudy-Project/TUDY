//
//  String+Custom.swift
//  TUDY
//
//  Created by neuli on 2022/05/31.
//

import Foundation

extension String {
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
