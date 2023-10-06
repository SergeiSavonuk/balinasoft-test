import Foundation
import UIKit

// MARK: - Assembly

class Assembly {

    // MARK: - PhotoRequestService

    lazy var photoServise: PhotoRequestService = {
        PhotoRequestServiceImpl()
    }()

    // MARK: - InfoRequestService

    lazy var infoServise: InfoRequestService = {
        InfoRequestServiceImpl()
    }()

    // MARK: - Public Function

    func makeMainScreen(output: MainOutput) -> UIViewController {
        let viewModel = MainViewModel(output: output, infoService: infoServise, photoService: photoServise)
        let view = MainViewController(viewModel: viewModel)
        viewModel.view = view
        return view
    }
}
