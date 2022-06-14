//
//  Job.swift
//  TUDY
//
//  Created by neuli on 2022/05/29.
//

import Foundation

struct Job {
    var jobType: JobType
    var detailJob: [DetailJob]
}

enum JobType: String {
    case programmer = "개발자"
    case designer = "디자이너"
}

enum DetailJob: String {
    case frontend = "프론트엔드"
    case backend = "백엔드"
    case Android
    case iOS
    case uxui = "UX/UI"
    case graphicDesign = "그래픽디자인"
    case branding = "브랜딩"
    case motionGraphic3D = "3D/모션그래픽"
}

struct Jobs {
    static let allJobs = [
        Job(jobType: .programmer, detailJob: [.frontend]),
        Job(jobType: .programmer, detailJob: [.backend]),
        Job(jobType: .programmer, detailJob: [.Android]),
        Job(jobType: .programmer, detailJob: [.iOS]),
        Job(jobType: .designer, detailJob: [.uxui]),
        Job(jobType: .designer, detailJob: [.graphicDesign]),
        Job(jobType: .designer, detailJob: [.branding]),
        Job(jobType: .designer, detailJob: [.motionGraphic3D])
    ]
    
    static let programmerJobs = [
        Job(jobType: .programmer, detailJob: [.frontend]),
        Job(jobType: .programmer, detailJob: [.backend]),
        Job(jobType: .programmer, detailJob: [.Android]),
        Job(jobType: .programmer, detailJob: [.iOS])
    ]
    
    static let designerJobs = [
        Job(jobType: .designer, detailJob: [.uxui]),
        Job(jobType: .designer, detailJob: [.graphicDesign]),
        Job(jobType: .designer, detailJob: [.branding]),
        Job(jobType: .designer, detailJob: [.motionGraphic3D])
    ]
    
    static let allJobTypes: [JobType] = [
        JobType.programmer,
        JobType.designer
    ]
    
    static let allProgrammersJobs: [DetailJob] = [
        .frontend,
        .backend,
        .Android,
        .iOS
    ]
    
    static let allDesignerJobs: [DetailJob] = [
        .uxui,
        .graphicDesign,
        .branding,
        .motionGraphic3D
    ]
}
