import Foundation
import UIKit
import SnapKit
import Then

// MARK: - Constants

private enum Constants {
    static var mainTableViewCellIdentifier: String { "MainTableViewCell" }
}

// MARK: - MainViewControllerProtocol

protocol MainViewControllerProtocol: AnyObject {
    func reloadData()
    func showAlert(message: String)
}

// MARK: - MainViewController

class MainViewController: UIViewController {

    // MARK: - Subview Properties

    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = UITableView.automaticDimension
        $0.register(MainTableViewCell.self, forCellReuseIdentifier: Constants.mainTableViewCellIdentifier)
    }

    private lazy var imagePicker = UIImagePickerController().then {
        $0.allowsEditing = true
        $0.delegate = self
    }

    // MARK: - Private Properties

    private let viewModel: MainViewModelProtocol

    // MARK: - Init

    init(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
        setupUI()
        setupConstraints()
    }

    // MARK: - Private Functions

    private func setupUI() {
        view.backgroundColor = .white

        addSubview()
        setupConstraints()
    }

    private func addSubview() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        imagePicker.sourceType = .camera
        present(imagePicker, animated: false, completion: nil)
    }
}

// MARK: - MainViewControllerProtocol

extension MainViewController: MainViewControllerProtocol {
    func reloadData() {
        tableView.reloadData()
    }

    func alert(message: String) {
        showAlert(message: message)
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.mainTableViewCellIdentifier,
            for: indexPath
        ) as? MainTableViewCell
        guard let cell = cell else { return UITableViewCell() }
        cell.setup(with: viewModel.tableData[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.tableData.count - 2 {
            viewModel.fetchData()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(indexPath: indexPath)
        openCamera()
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        imagePicker.dismiss(animated: true, completion: nil)
        viewModel.sendPhoto(info: info)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension MainViewController: UINavigationControllerDelegate {}
