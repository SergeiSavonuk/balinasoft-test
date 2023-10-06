import Foundation
import UIKit


private enum Constants {
    static var successAlertMessage: String { "Фото успешно отправлено!" }
    static var errorAlertMessage: String { "Что-то пошло не так" }
}

// MARK: - MainViewModelProtocol

protocol MainViewModelProtocol {
    var tableData: [MainTableViewCellModel] { get }
    func didSelectCell(indexPath: IndexPath)
    func sendPhoto(info: [UIImagePickerController.InfoKey: Any])
    func fetchData()
}

// MARK: - MainViewModel

class MainViewModel {

    // MARK: - Public Properties

    var tableData = [MainTableViewCellModel]()
    weak var view: MainViewControllerProtocol?

    // MARK: - Private Properties

    private weak var output: MainOutput?
    private let infoService: InfoRequestService
    private let photoService: PhotoRequestService

    private var nextPage: Int? = .zero
    private var currentCellId: Int = .zero

    // MARK: - Init

    init(
        output: MainOutput,
        infoService: InfoRequestService,
        photoService: PhotoRequestService
    ) {
        self.output = output
        self.infoService = infoService
        self.photoService = photoService
    }
    
    // MARK: - Private Functions

    private func makeTableData(data: InfoResponse) {
        guard let content = data.content else { return }
        tableData.append(contentsOf: content.compactMap {
            MainTableViewCellModel(
                id: $0.id ?? .zero,
                name: $0.name.orEmpty(),
                imageUrl: $0.image.orEmpty()
            )
        })
        view?.reloadData()
    }
}

// MARK: - MainViewModelProtocol

extension MainViewModel: MainViewModelProtocol {
    func fetchData() {
        guard let nextPage = nextPage else { return }
        infoService.fetchInfo(
            page: nextPage,
            completion: { [weak self] result in
                
                guard let self else { return }
                switch result {
                case let .value(value):
                    makeTableData(data: value.object)
                    guard
                        let content = value.object.content,
                        !content.isEmpty
                    else {
                        self.nextPage = nil
                        return
                    }
                    self.nextPage = (value.object.page ?? .zero) + 1
                    
                case let .error(error):
                    print(error)
                }
            }
        )
    }

    func sendPhoto(info: [UIImagePickerController.InfoKey: Any]) {
        let selectedImage: UIImage
        if let cropImage = info[.editedImage] as? UIImage {
            selectedImage = cropImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        } else {
            return
        }

        photoService.sendPhoto(
            id: currentCellId,
            photo:selectedImage,
            completion: { [weak self] result in
                
                guard let self else { return }
                switch result {
                case .value(_):
                    view?.showAlert(message: Constants.successAlertMessage)
                    
                case .error(_):
                    view?.showAlert(message: Constants.errorAlertMessage)
                }
            }
        )
    }

    func didSelectCell(indexPath: IndexPath) {
        currentCellId = tableData[indexPath.row].id
    }
}
