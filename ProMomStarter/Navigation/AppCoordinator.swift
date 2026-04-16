import UIKit

@MainActor
final class AppCoordinator {
    private let navigationController: UINavigationController
    private let environment: AppEnvironment

    init(navigationController: UINavigationController, environment: AppEnvironment) {
        self.navigationController = navigationController
        self.environment = environment
    }

    func start() {
        let viewModel = NameSparkViewModel(apiClient: environment.apiClient)
        let viewController = NameSparkViewController(viewModel: viewModel)

        viewController.onSelectResult = { [weak self] result in
            self?.showDetail(for: result)
        }

        navigationController.setViewControllers([viewController], animated: false)
    }

    private func showDetail(for result: NameSearchResult) {
        let viewModel = NameDetailViewModel(
            nameID: result.id,
            seedName: result.name,
            apiClient: environment.apiClient
        )
        let viewController = NameDetailViewController(viewModel: viewModel)

        // INTERVIEW TODO:
        // Once favorite mutations are implemented, decide how to propagate the
        // updated state back into the results screen.
        navigationController.pushViewController(viewController, animated: true)
    }
}
