import Foundation
import Generics

public struct Show {
    public typealias ID = GenericIdentifier<Show, Int>

    public let id: ID
    public let name: String
    public let firstAirDate: Date?
    public let posterURL: URL?
}
