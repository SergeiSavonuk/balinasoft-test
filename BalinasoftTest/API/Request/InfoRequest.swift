import Foundation

// MARK: InfoRequest

class InfoRequest: BaseRequest, Bindable {
    typealias ResponseType = InfoResponse

    public init(page: Int) {
        super .init()
        method = RequestMethod.get

        path = "/photo/type"
        queryParams = [
            "page": page
        ]
    }
}
