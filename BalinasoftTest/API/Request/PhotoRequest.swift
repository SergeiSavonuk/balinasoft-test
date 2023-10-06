import Foundation
import UIKit

// MARK: PhotoRequest

class PhotoRequest: BaseRequest, Bindable {
    typealias ResponseType = PhotoResponse

    public init(id: Int, photo: UIImage) {
        super .init()
        method = RequestMethod.post

        path = "/photo"
        files = [
            FileRequestInfo(name: "name"): "Савонюк Сергей Владимирович".data(using: .utf8)!,
            FileRequestInfo(name: "photo", fileName: "photo"): photo.pngData()!,
            FileRequestInfo(name: "typeId"): "\(id)".data(using: .utf8)!
        ]
    }
}
