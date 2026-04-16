import Foundation

@MainActor
protocol NameSparkViewModelDelegate: AnyObject {
    func nameSparkViewModelDidUpdate(_ viewModel: NameSparkViewModel)
}

@MainActor
final class NameSparkViewModel {
    struct State {
        var selectedGender: NameGender?
        var selectedOrigins: Set<NameOrigin> = []
        var startingLetter = ""
        var isLoading = false
        var hasPerformedSearch = false
        var results: [NameSearchResult] = []
        var errorMessage: String?
    }

    weak var delegate: NameSparkViewModelDelegate?
    private(set) var state = State()

    private let apiClient: NameSparkAPIClientProtocol

    init(apiClient: NameSparkAPIClientProtocol) {
        self.apiClient = apiClient
    }

    func viewDidLoad() {
        delegate?.nameSparkViewModelDidUpdate(self)
    }

    var isFindButtonEnabled: Bool {
        state.selectedGender != nil || !state.selectedOrigins.isEmpty || !state.startingLetter.isEmpty
    }

    func setGender(at index: Int) {
        switch index {
        case 1:
            state.selectedGender = .girl
        case 2:
            state.selectedGender = .boy
        case 3:
            state.selectedGender = .unisex
        default:
            state.selectedGender = nil
        }

        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func toggleOrigin(_ origin: NameOrigin) {
        if state.selectedOrigins.contains(origin) {
            state.selectedOrigins.remove(origin)
        } else {
            state.selectedOrigins.insert(origin)
        }

        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func updateStartingLetter(_ rawValue: String) {
        state.startingLetter = rawValue
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()
            .prefix(1)
            .description

        delegate?.nameSparkViewModelDidUpdate(self)
    }

    func result(at indexPath: IndexPath) -> NameSearchResult? {
        guard state.results.indices.contains(indexPath.row) else { return nil }
        return state.results[indexPath.row]
    }

    func findNames() {
        // INTERVIEW TODO:
        // Build a request from the selected filters, call the backend search
        // route, and make loading/error/empty states explicit. This is also a
        // good place to decide how you want to handle overlapping searches.
        _ = apiClient
        state.hasPerformedSearch = true
        state.errorMessage = "Starter shell only. Implement the NameSpark search flow."
        delegate?.nameSparkViewModelDidUpdate(self)
    }
}
