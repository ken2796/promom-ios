import Foundation

@MainActor
protocol NameDetailViewModelDelegate: AnyObject {
    func nameDetailViewModelDidUpdate(_ viewModel: NameDetailViewModel)
}

@MainActor
final class NameDetailViewModel {
    struct State {
        var isLoading = false
        var isSaving = false
        var detail: NameDetail?
        var errorMessage: String?
    }

    weak var delegate: NameDetailViewModelDelegate?
    var onFavoriteUpdated: ((NameDetail) -> Void)?
    private(set) var state = State()

    let seedName: String

    private let nameID: String
    private let apiClient: NameSparkAPIClientProtocol

    init(nameID: String, seedName: String, apiClient: NameSparkAPIClientProtocol) {
        self.nameID = nameID
        self.seedName = seedName
        self.apiClient = apiClient
    }

    func viewDidLoad() {
        Task {
            await loadDetail()
        }
    }

    func toggleFavorite() {
        guard state.detail != nil else {
            state.errorMessage = "Load the name detail before saving."
            delegate?.nameDetailViewModelDidUpdate(self)
            return
        }

        Task {
            state.isSaving = true
            state.errorMessage = nil
            delegate?.nameDetailViewModelDidUpdate(self)

            // INTERVIEW TODO:
            // Call the favorite mutation endpoint, update the current detail,
            // and push the updated state back to the results screen.

            state.isSaving = false
            delegate?.nameDetailViewModelDidUpdate(self)
        }
    }

    private func loadDetail() async {
        state.isLoading = true
        state.errorMessage = nil
        delegate?.nameDetailViewModelDidUpdate(self)

        // INTERVIEW TODO:
        // Fetch the name detail payload, surface failure clearly, and decide
        // how you want the empty/detail states to behave while loading.
        _ = apiClient

        state.isLoading = false
        delegate?.nameDetailViewModelDidUpdate(self)
    }
}
