// Mango code

import UIKit
import Foundation

extension UIView {
    func constrain(constraints: (UIView) -> ()) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        constraints(self)
        return self
    }

    func add(views: (UIView) -> ()) -> UIView {
        views(self)
        return self
    }
}

extension UILabel {
    var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set(size) {
            self.font = font.fontWithSize(size)
        }
    }
}
