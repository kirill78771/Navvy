import SwiftUI
import Combine

//extension Collection where Element: Publisher {
//    func serialize() -> AnyPublisher<Element.Output, Element.Failure>? {
//        guard let start = self.first else { return nil }
//        return self.dropFirst().reduce(start.eraseToAnyPublisher()) {
//            $0.append($1).eraseToAnyPublisher()
//        }
//    }
//}

//extension Collection where Element: Publisher {
//
//    func serialize() -> AnyPublisher<Element.Output, Element.Failure>? {
//        // If the collection is empty, we can't just create an arbititary publisher
//        // so we return nil to indicate that we had nothing to serialize.
//        if isEmpty { return nil }
//
//        // We know at this point that it's safe to grab the first publisher.
//        let first = self.first!
//
//        // If there was only a single publisher then we can just return it.
//        if count == 1 { return first.eraseToAnyPublisher() }
//
//        // We're going to build up the output starting with the first publisher.
//        var output = first.eraseToAnyPublisher()
//
//        // We iterate over the rest of the publishers (skipping over the first.)
//        for publisher in self.dropFirst() {
//            // We build up the output by appending the next publisher.
//            output = output.append(publisher).eraseToAnyPublisher()
//        }
//
//        return output
//    }
//}


extension Router {
    
    public func presentSheet(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .presentation(SheetPresenter.presentationType),
            with: screenType,
            completion: completion
        )
    }

    @available(iOS 14, *)
    public func presentOverFullScreen(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .presentation(FullScreenCoverPresenter.presentationType),
            with: screenType,
            completion: completion
        )
    }

    public func navigationLink(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .presentation(NavigationLinkPresenter.presentationType),
            with: screenType,
            completion: completion
        )
    }
    
    public func dismiss(
        _ screenType: ScreenType,
        completion: (() -> Void)? = nil
    ) {
        self.perform(
            navigation: .dismiss,
            with: screenType,
            completion: completion
        )
    }

    internal func dismissAsFuture(_ screenType: ScreenType) -> Future<Void, Never> {
        return Future() { promise in
            print("start \(screenType)")
            self.dismiss(screenType) {
                promise(Result.success(()))
            }
        }
    }

    public func dismiss(
        _ screenTypes: [ScreenType],
        completion: (() -> Void)? = nil
    ) {
//        let futures = screenTypes
//            .map { dismissAsFuture($0) }
//            .red
//        self.canl = futures
//            .reduce(()) { res, future in }
//            .sink { _ in
//                print("finish")
//            }

//        self.canl = Publishers.Sequence<[Future<Void, Never>], Error>(sequence: futures)
//            .flatMap { $0 }
//            .sink(receiveCompletion: {_ in}, receiveValue: { _ in})
//            .sink(receiveCompletion: { _ in }, receiveValue: {_ in })

//        self.canl = Publishers.Sequence(sequence: screenTypes.map { dismissAsFuture($0) })
//                .flatMap(maxPublishers: .max(1)) { $0 }
//                .eraseToAnyPublisher()
//            .sink { _ in
//                print("finished")
//            } receiveValue: { _ in
//
//            }

//        self.canl = screenTypes.map { dismissAsFuture($0) }.serialize()?.sink(receiveCompletion: { _ in
//            print("D")
//        }, receiveValue: { _ in
//            print("finish")
//        })

//        self.canl = screenTypes.map { dismissAsFuture($0) }.dropFirst().reduce(collection.first!) {
//            return $0.append($1).eraseToAnyPublisher()
//        }

//        self.canl = dismissAsFuture(screenTypes[0])
//            .handleEvents(receiveOutput: {_ in print("finished \(screenTypes[0])")})
//            .flatMap {
//                self.dismissAsFuture(screenTypes[1])
//            }
//            .handleEvents(receiveOutput: {_ in print("finished \(screenTypes[1])")})
//            .flatMap {
//                self.dismissAsFuture(screenTypes[2])
//            }
//            .handleEvents(receiveOutput: {_ in print("finished \(screenTypes[2])")})
//            .sink { _ in
//                print("finish all")
//            }
//        let abcv = dismissAsFuture(screenTypes[0])
//            .handleEvents(receiveOutput: {_ in print("finished 1")})
//            .flatMap {
//                self.dismissAsFuture(screenTypes[1])
//            }
//            .handleEvents(receiveOutput: {_ in print("finished 2")})
//            .flatMap {
//                self.dismissAsFuture(screenTypes[2])
//            }

//        let futures = screenTypes.map { dismissAsFuture($0) }

//        self.canl = futures
//            .publisher
//            .flatMap{ $0.handleEvents(receiveOutput: {_ in print("finished 2")}) }
//            .sink { _ in
//                print("finish")
//            }

//        self.canl = futures
//            .publisher
//            .flatMap(maxPublishers: .max(1), { $0 })
//            .sink { _ in
//                print("finish")
//            }

//        dispatchQueue.async {
            for (index, screenType) in screenTypes.enumerated() {
//                print("start \(screenType)")
                self.dismiss(screenType) {
                    if index == screenTypes.count - 1 {
                        completion?()
                    }
//                    print("finished \(screenType)")
//                    self.semaphore.signal()
                }
//                self.semaphore.wait()
            }
        }
    }

    public func dismissLast(completion: (() -> Void)? = nil) {
        guard let screenType = stack.last?.screenType else {
            assertionFailure("Stack shouldn't be empty")
            return
        }
        self.perform(
            navigation: .dismiss,
            with: screenType,
            completion: completion
        )
    }
}
