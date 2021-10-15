import Foundation

public protocol ShowViewModel {
    var canDelete: Bool { get }
    var isDummy: Bool { get }
    var name: String { get }
    var firstAirDateYear: String? { get }
    var posterURL: URL? { get }
    var progress: Float { get }
    var numberOfNewEpisodes: Int { get }

    func tap()
    func delete()
}
