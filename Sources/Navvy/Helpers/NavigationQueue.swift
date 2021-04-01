import Foundation

final class NavigationQueue {
    
    typealias Operation = (_ completion: @escaping () -> Void) -> Void

    private var operations = [Operation]()
    
    func perform(_ operation: @escaping Operation) {
        let shouldStart = operations.isEmpty
        operations.append(operation)
        if shouldStart {
            performNextOperation()
        }
    }

    private func performNextOperation() {
        guard !operations.isEmpty else { return }
        let operation = operations.removeFirst()
        operation { [weak self] in
            self?.performNextOperation()
        }
    }
}
