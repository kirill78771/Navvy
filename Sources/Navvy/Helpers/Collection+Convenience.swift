import Foundation
import Combine

extension Collection where Element: Publisher {
    func serialize() -> AnyPublisher<Element.Output, Element.Failure>? {
        guard let firstPublisher = self.first else { return nil }
        return self.dropFirst().reduce(firstPublisher.eraseToAnyPublisher()) {
            $0.append($1).eraseToAnyPublisher()
        }
    }
}
