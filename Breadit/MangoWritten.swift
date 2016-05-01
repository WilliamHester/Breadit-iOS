// Mango code

import UIKit
import Foundation

extension UIView {
    func constrain(constraints: (UIView) -> ()) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        constraints(self)
        return self
    }
    
    func constrainOnViewDidLoad(constraints: (UIView) -> ()) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        Mango.addConstraint(self, closure: constraints)
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

struct Mango {
    private typealias ConstraintClosure = (UIView) -> ()
    private static var constraints = [NSValue: ConstraintClosure]()
    
    static func constrainViews(view: UIView) {
        for subview in view.subviews {
            constrainViews(subview)
        }
        if let closure = constraints[NSValue(nonretainedObject: view)] {
            closure(view)
            constraints.removeValueForKey(NSValue(nonretainedObject: view))
        }
    }
    
    static func constrainViews(viewController: UIViewController) {
        constrainViews(viewController.view)
    }
    
    private static func addConstraint(view: UIView, closure: ConstraintClosure) {
        constraints[NSValue(nonretainedObject: view)] = closure
    }
}
