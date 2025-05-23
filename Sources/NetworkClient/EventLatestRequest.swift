//
//  EventLatestRequest.swift
//  eventpanel-cli
//
//  Created by Sukhanov Evgenii on 23.05.2025.
//

struct EventLatestRequest: Encodable {
    let events: [EventLatestRequestItem]
}

struct EventLatestResponse: Decodable {
    let events: [EventLatestRequestItem]
}
