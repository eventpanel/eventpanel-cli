import Foundation

enum EventPanelDataType: Codable {
    case string
    case stringList
    case integer
    case integerList
    case date
    case dateList
    case boolean
    case booleanList
    case float
    case floatList
    case object
    case objectList
    case custom(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        
        switch rawValue.uppercased() {
        case "STRING": self = .string
        case "STRING_LIST", "[STRING]": self = .stringList
        case "INTEGER": self = .integer
        case "INTEGER_LIST", "[INTEGER]": self = .integerList
        case "DATE": self = .date
        case "DATE_LIST", "[DATE]": self = .dateList
        case "BOOLEAN": self = .boolean
        case "BOOLEAN_LIST", "[BOOLEAN]": self = .booleanList
        case "FLOAT": self = .float
        case "FLOAT_LIST", "[FLOAT]": self = .floatList
        case "OBJECT": self = .object
        case "OBJECT_LIST", "[OBJECT]": self = .objectList
        default: self = .custom(rawValue)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string: try container.encode("STRING")
        case .stringList: try container.encode("STRING_LIST")
        case .integer: try container.encode("INTEGER")
        case .integerList: try container.encode("INTEGER_LIST")
        case .date: try container.encode("DATE")
        case .dateList: try container.encode("DATE_LIST")
        case .boolean: try container.encode("BOOLEAN")
        case .booleanList: try container.encode("BOOLEAN_LIST")
        case .float: try container.encode("FLOAT")
        case .floatList: try container.encode("FLOAT_LIST")
        case .object: try container.encode("OBJECT")
        case .objectList: try container.encode("OBJECT_LIST")
        case .custom(let value): try container.encode(value)
        }
    }
}
