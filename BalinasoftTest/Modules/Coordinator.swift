import UIKit

// MARK: - Coordinator

class Coordinator {

    // MARK: - Private Properties

    private let assembly: Assembly
    private var navigationViewController: UINavigationController?

    // MARK: - Init

    init(assembly: Assembly) {
        self.assembly = assembly
    }

    // MARK: - Public Function

    func start(window: UIWindow) {
        let mainView = assembly.makeMainScreen(output: self)
        navigationViewController = UINavigationController(rootViewController: mainView)
        navigationViewController?.navigationBar.topItem?.title = String()
        navigationViewController?.navigationBar.tintColor = .black

        window.rootViewController = navigationViewController
        window.makeKeyAndVisible()
    }
}

// MARK: MainOutput

extension Coordinator: MainOutput { }

