import SwiftUI

/*
 https://stackoverflow.com/questions/69354864/emptyview-is-not-showing-in-ios-15-xcode-13
 */

internal struct TargetView: View {

    var body: some View {
        if #available(iOS 15.0, *) {
            Spacer()
                .frame(width: 0.0, height: 0.0)
        } else {
            EmptyView()
        }
    }
}
