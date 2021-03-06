//
//  DrawerViewController.swift
//  Breadit
//
//  Created by William Hester on 4/30/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import UIKit

class NavigationDrawerViewController: UIViewController, UIGestureRecognizerDelegate,
		UINavigationControllerDelegate, NavigationDelegate {
    
    private static let size: CGFloat = 40
    
    var contentController: UIViewController!
    var drawerController: NavigationViewController!
    
    var drawer: UIView!
    var content: UIView!
    var drawerRightConstraint: NSLayoutConstraint!
    var contentLeftConstraint: NSLayoutConstraint!
    var startTranslation: CGFloat = 0
    var isOpen: Bool = false {
        willSet {
            if isOpen {
                drawerController.stopSearching()
            }
        }
        didSet {
            animateDrawer(0.3)
            content.userInteractionEnabled = !isOpen
        }
    }
    var enabled: Bool = true
    var drawerWidth: CGFloat {
        get {
            return self.view.frame.width - NavigationDrawerViewController.size
        }
    }
    var drawerOffset: CGFloat {
        get {
            return drawerWidth / 2
        }
    }
    var currentPlace: NavigationPlace = .Subreddit("")
    
    init(contentViewController: UIViewController, drawerViewController: NavigationViewController) {
        super.init(nibName: nil, bundle: nil)

        self.contentController = contentViewController
        self.drawerController = drawerViewController
        self.drawerController.delegate = self
        
        self.addChildViewController(self.contentController)
        self.addChildViewController(self.drawerController)
        
        if let navigationController = contentController as? UINavigationController {
            navigationController.delegate = self
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        uiView { v in
            v.addSubview(self.drawerController.view)
            self.drawer = self.drawerController.view.constrain { v in
                self.drawerRightConstraint = v.rightAnchor.constraintEqualToAnchor(
                    self.view.leftAnchor,
                    constant: -self.drawerOffset
                )
                self.drawerRightConstraint.active = true
                v.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor,
                    	constant: -NavigationDrawerViewController.size).active = true
                v.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
                v.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
            }
            self.drawer.frame = self.makeDrawerFrame()

            v.addSubview(self.contentController.view)
            self.content = self.contentController.view.constrain { v in
                self.contentLeftConstraint = v.leftAnchor.constraintEqualToAnchor(self.view.leftAnchor)
                self.contentLeftConstraint.active = true
                v.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
                v.topAnchor.constraintEqualToAnchor(self.view.topAnchor).active = true
                v.bottomAnchor.constraintEqualToAnchor(self.view.bottomAnchor).active = true
            }
            
            // Make the shadow
            self.content.add { v in
                v.layer.shadowPath = UIBezierPath(rect: v.bounds).CGPath
                v.layer.shadowRadius = 4
                v.layer.shadowOffset = CGSizeMake(0, 5)
                v.layer.shadowColor = UIColor.blackColor().CGColor
                v.layer.shadowOpacity = 0.5
            }
        }

        let gestureRecognizer = UIPanGestureRecognizer(target: self,
        		action: #selector(NavigationDrawerViewController.moveDrawer(_:)))
        gestureRecognizer.cancelsTouchesInView = true
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self,
       			action: #selector(NavigationDrawerViewController.drawerSwiped(_:)))
        swipeRecognizer.delegate = self
        view.addGestureRecognizer(swipeRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
      			action: #selector(NavigationDrawerViewController.drawerTapped(_:)))
        tapGestureRecognizer.delegate = self
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        setScrollsToTop(view.subviews[0], set: false)
        setScrollsToTop(view.subviews[1], set: true)
    }
    
    func setScrollsToTop(view: UIView, set: Bool) {
        if let scrollView = view as? UIScrollView {
            scrollView.scrollsToTop = set
        }
        for subView in view.subviews {
            setScrollsToTop(subView, set: set)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    private func makeDrawerFrame() -> CGRect {
        return CGRect(x: 0, y: 0,
                width: drawerWidth,
        		height: view.frame.height)
    }
    
    func toggleDrawer(obj: AnyObject) {
        isOpen = !isOpen
    }
    
    func animateDrawer(duration: Double) {
        let end = drawerWidth
        UIView.animateWithDuration(duration) {
            if self.isOpen {
                self.drawerRightConstraint.constant = end
                self.contentLeftConstraint.constant = end
            } else {
                self.drawerRightConstraint.constant = self.drawerOffset
                self.contentLeftConstraint.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return enabled && gestureRecognizer.locationInView(view).x <
            	NavigationDrawerViewController.size + content.frame.origin.x
    }
    
    // MARK: - TapGestureRecognizer
    
    func drawerTapped(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.locationInView(view)
        if isOpen && location.x > drawerWidth {
            isOpen = false
        }
    }
    
    // MARK: - PanGestureRecognizer
    
    func moveDrawer(gestureRecognizer: UIPanGestureRecognizer) {
        switch (gestureRecognizer.state) {
        case .Began:
            startTranslation = contentLeftConstraint.constant
        case .Changed:
            moveDrawerBy(gestureRecognizer.translationInView(view).x)
        case .Ended:
            animateToEnd(gestureRecognizer.translationInView(view).x)
        default:
            break
        }
    }
    
    func moveDrawerBy(translation: CGFloat) {
        let trans = min(max(startTranslation + translation, 0), view.frame.width)
        drawerRightConstraint.constant = min((trans / 2 + drawerOffset), drawerWidth)
        contentLeftConstraint.constant = trans
    }
    
    func animateToEnd(translation: CGFloat) {
        let trans = startTranslation + translation
        let openPercent = trans / (view.frame.width - NavigationDrawerViewController.size)
        isOpen = openPercent > 0.5
    }
    
    // MARK: - SwipeGestureRecognizer
    
    func drawerSwiped(gestureRecognizer: UISwipeGestureRecognizer) {
        switch (gestureRecognizer.state) {
        case .Began:
            startTranslation = gestureRecognizer.locationInView(view).x
        case .Ended:
            animateSwipe(gestureRecognizer.direction)
        default:
            break
        }
    }
    
    func animateSwipe(direction: UISwipeGestureRecognizerDirection) {
        isOpen = direction == .Right
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController,
    		didShowViewController viewController: UIViewController, animated: Bool) {
        enabled = navigationController.viewControllers[0] == viewController
    }
    
    // MARK: - UINavigationControllerDelegate
    
    func navigationController(navigationController: UINavigationController,
    		willShowViewController viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count > 1 {
            return
        }
        let menuButton = UIBarButtonItem(title: "Menu", style: .Plain, target: self,
        		action: #selector(NavigationDrawerViewController.toggleDrawer(_:)))

        viewController.navigationItem.setLeftBarButtonItem(menuButton, animated: false)
    }
    
    // MARK: - NavigationDelegate
    
    func didNavigateTo(place: NavigationPlace) {
        switch place {
        case .Search(let query):
            var vc: ListingViewController
            if let submissionVC = contentController.childViewControllers[0] as? ListingViewController {
                vc = submissionVC
            } else {
                vc = ListingViewController()
                contentController = UINavigationController(rootViewController: vc)
            }
            vc.listingStore = SubmissionStore(searchQuery: query)
        case .Subreddit(let displayName):
            var vc: ListingViewController
            if let submissionVC = contentController.childViewControllers[0] as? ListingViewController {
                vc = submissionVC
            } else {
                vc = ListingViewController()
                contentController = UINavigationController(rootViewController: vc)
            }
            vc.listingStore = SubmissionStore(subredditDisplay: displayName)
        case .Account:
            break
        case .Friends:
            break
        case .Inbox:
            break
        case .Settings:
            let vc = UINavigationController(rootViewController: LoginViewController())
            vc.navigationBar.barStyle = .Black
            vc.modalTransitionStyle = .CoverVertical
        	presentViewController(vc, animated: true, completion: nil)
        case .Submit:
            break
        }
        isOpen = false
    }
    
}
