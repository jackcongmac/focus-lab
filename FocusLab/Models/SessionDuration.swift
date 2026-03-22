import Foundation

enum SessionDuration: Int, CaseIterable, Codable {
    case five    = 5
    case ten     = 10
    case fifteen = 15
    case twenty  = 20

    var label: String { "\(rawValue) min" }
    var seconds: TimeInterval { TimeInterval(rawValue) * 60 }
}
