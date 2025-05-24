struct EventLatestRequest: Encodable {
    let events: [EventLatestRequestItem]
}

struct EventLatestResponse: Decodable {
    let events: [EventLatestRequestItem]
}
