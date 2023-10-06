import Foundation
import UIKit

// MARK: - Constants

private enum Constants {
    static var nameTextColor: UIColor { .black }
    static var nameTextSize: CGFloat { 14 }
    static var mainImageSize: CGFloat { 60 }
}

// MARK: - MainTableViewCell

class MainTableViewCell: UITableViewCell {

    // MARK: Public Properties

    var model: MainTableViewCellModel?

    // MARK: - Subview Properties

    private lazy var nameLabel = UILabel().then {
        $0.textColor = Constants.nameTextColor
        $0.font.withSize(Constants.nameTextSize)
    }
    private lazy var mainImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Functions

    func setup(with model: MainTableViewCellModel) {
        self.model = model

        nameLabel.text = model.name
        mainImageView.download(from: model.imageUrl)
        
    }

    // MARK: - Private Functions

    private func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(mainImageView)
    }

    private func setupConstraints() {
        mainImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(Space.space4)
            $0.leading.equalToSuperview().inset(Space.space24)
            $0.size.equalTo(Constants.mainImageSize)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(mainImageView.snp.trailing).offset(Space.space24)
            $0.centerY.equalToSuperview()
        }
    }
}
