//
//  ServiceApiStruct.swift
//  DadPat
//
//  Created by 吴思 on 5/15/18.
//  Copyright © 2018 吴思. All rights reserved.
//

import Foundation

//"/resource/batch/list/summary.do"
struct serviceBatch : Codable
{
    let batchId: String;
    let batchSource: String;
    let batchDesc: String?;
    let coverImage: String;
    let coverMd5: String;
    
}

struct serviceBatchListSummaryResponse : Codable
{
    let success: Bool;
    let data: [serviceBatch];
}

//"/resource/card/list.do?batchId="

struct serviceAudio: Codable
{
    let resId: String;
    let attUrl: String;
    let md5: String;
}

struct serviceImage: Codable
{
    let attUrl: String;
    let md5: String;
}

struct serviceCard: Codable
{
    let rfId: Int;
    let resourceId: String;
    let ownerId: String;
    let coverImage: serviceImage?;
    let handDrawImage: serviceImage?;
    let headImage: serviceImage?;
    let audios: [serviceAudio]?;
    let pronAudio: serviceAudio?;
    let descAudio: serviceAudio?;
}

struct serviceCardListResponse : Codable
{
    let success: Bool;
    let data: [serviceCard];
}
