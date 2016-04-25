// Generated code by Mango

import UIKit


extension UIView {
    
    internal func addChild(view: UIView) {
        addSubview(view)
    }
    
    func uiView(views: (UIView) -> ()) -> UIView {
        let view = UIView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiToolbar(views: (UIToolbar) -> ()) -> UIToolbar {
        let view = UIToolbar()
        views(view)
        addChild(view)
        return view
    }
    
    func uiPickerView(views: (UIPickerView) -> ()) -> UIPickerView {
        let view = UIPickerView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiControl(views: (UIControl) -> ()) -> UIControl {
        let view = UIControl()
        views(view)
        addChild(view)
        return view
    }
    
    func uiSwitch(views: (UISwitch) -> ()) -> UISwitch {
        let view = UISwitch()
        views(view)
        addChild(view)
        return view
    }
    
    func uiSegmentedControl(views: (UISegmentedControl) -> ()) -> UISegmentedControl {
        let view = UISegmentedControl()
        views(view)
        addChild(view)
        return view
    }
    
    func uiSlider(views: (UISlider) -> ()) -> UISlider {
        let view = UISlider()
        views(view)
        addChild(view)
        return view
    }
    
    func uiRefreshControl(views: (UIRefreshControl) -> ()) -> UIRefreshControl {
        let view = UIRefreshControl()
        views(view)
        addChild(view)
        return view
    }
    
    func uiTextField(views: (UITextField) -> ()) -> UITextField {
        let view = UITextField()
        views(view)
        addChild(view)
        return view
    }
    
    func uiStepper(views: (UIStepper) -> ()) -> UIStepper {
        let view = UIStepper()
        views(view)
        addChild(view)
        return view
    }
    
    func uiDatePicker(views: (UIDatePicker) -> ()) -> UIDatePicker {
        let view = UIDatePicker()
        views(view)
        addChild(view)
        return view
    }
    
    func uiPageControl(views: (UIPageControl) -> ()) -> UIPageControl {
        let view = UIPageControl()
        views(view)
        addChild(view)
        return view
    }
    
    func uiButton(views: (UIButton) -> ()) -> UIButton {
        let view = UIButton()
        views(view)
        addChild(view)
        return view
    }
    
    func uiCollectionReusableView(views: (UICollectionReusableView) -> ()) -> UICollectionReusableView {
        let view = UICollectionReusableView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiCollectionViewCell(views: (UICollectionViewCell) -> ()) -> UICollectionViewCell {
        let view = UICollectionViewCell()
        views(view)
        addChild(view)
        return view
    }
    
    func uiInputView(views: (UIInputView) -> ()) -> UIInputView {
        let view = UIInputView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiWebView(views: (UIWebView) -> ()) -> UIWebView {
        let view = UIWebView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiWindow(views: (UIWindow) -> ()) -> UIWindow {
        let view = UIWindow()
        views(view)
        addChild(view)
        return view
    }
    
    func uiScrollView(views: (UIScrollView) -> ()) -> UIScrollView {
        let view = UIScrollView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiTableView(views: (UITableView) -> ()) -> UITableView {
        let view = UITableView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiCollectionView(views: (UICollectionView) -> ()) -> UICollectionView {
        let view = UICollectionView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiTextView(views: (UITextView) -> ()) -> UITextView {
        let view = UITextView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiTableViewCell(views: (UITableViewCell) -> ()) -> UITableViewCell {
        let view = UITableViewCell()
        views(view)
        addChild(view)
        return view
    }
    
    func uiVisualEffectView(views: (UIVisualEffectView) -> ()) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiActivityIndicatorView(views: (UIActivityIndicatorView) -> ()) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiLabel(views: (UILabel) -> ()) -> UILabel {
        let view = UILabel()
        views(view)
        addChild(view)
        return view
    }
    
    func uiTabBar(views: (UITabBar) -> ()) -> UITabBar {
        let view = UITabBar()
        views(view)
        addChild(view)
        return view
    }
    
    func uiTableViewHeaderFooterView(views: (UITableViewHeaderFooterView) -> ()) -> UITableViewHeaderFooterView {
        let view = UITableViewHeaderFooterView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiStackView(views: (UIStackView) -> ()) -> UIStackView {
        let view = UIStackView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiSearchBar(views: (UISearchBar) -> ()) -> UISearchBar {
        let view = UISearchBar()
        views(view)
        addChild(view)
        return view
    }
    
    func uiPopoverBackgroundView(views: (UIPopoverBackgroundView) -> ()) -> UIPopoverBackgroundView {
        let view = UIPopoverBackgroundView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiImageView(views: (UIImageView) -> ()) -> UIImageView {
        let view = UIImageView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiProgressView(views: (UIProgressView) -> ()) -> UIProgressView {
        let view = UIProgressView()
        views(view)
        addChild(view)
        return view
    }
    
    func uiNavigationBar(views: (UINavigationBar) -> ()) -> UINavigationBar {
        let view = UINavigationBar()
        views(view)
        addChild(view)
        return view
    }
    
}

extension UIViewController {
    
    func uiView(views: (UIView) -> ()) {
        self.view.uiView(views)
    }
    
    func uiToolbar(views: (UIToolbar) -> ()) {
        self.view.uiToolbar(views)
    }
    
    func uiPickerView(views: (UIPickerView) -> ()) {
        self.view.uiPickerView(views)
    }
    
    func uiControl(views: (UIControl) -> ()) {
        self.view.uiControl(views)
    }
    
    func uiSwitch(views: (UISwitch) -> ()) {
        self.view.uiSwitch(views)
    }
    
    func uiSegmentedControl(views: (UISegmentedControl) -> ()) {
        self.view.uiSegmentedControl(views)
    }
    
    func uiSlider(views: (UISlider) -> ()) {
        self.view.uiSlider(views)
    }
    
    func uiRefreshControl(views: (UIRefreshControl) -> ()) {
        self.view.uiRefreshControl(views)
    }
    
    func uiTextField(views: (UITextField) -> ()) {
        self.view.uiTextField(views)
    }
    
    func uiStepper(views: (UIStepper) -> ()) {
        self.view.uiStepper(views)
    }
    
    func uiDatePicker(views: (UIDatePicker) -> ()) {
        self.view.uiDatePicker(views)
    }
    
    func uiPageControl(views: (UIPageControl) -> ()) {
        self.view.uiPageControl(views)
    }
    
    func uiButton(views: (UIButton) -> ()) {
        self.view.uiButton(views)
    }
    
    func uiCollectionReusableView(views: (UICollectionReusableView) -> ()) {
        self.view.uiCollectionReusableView(views)
    }
    
    func uiCollectionViewCell(views: (UICollectionViewCell) -> ()) {
        self.view.uiCollectionViewCell(views)
    }
    
    func uiInputView(views: (UIInputView) -> ()) {
        self.view.uiInputView(views)
    }
    
    func uiWebView(views: (UIWebView) -> ()) {
        self.view.uiWebView(views)
    }
    
    func uiWindow(views: (UIWindow) -> ()) {
        self.view.uiWindow(views)
    }
    
    func uiScrollView(views: (UIScrollView) -> ()) {
        self.view.uiScrollView(views)
    }
    
    func uiTableView(views: (UITableView) -> ()) {
        self.view.uiTableView(views)
    }
    
    func uiCollectionView(views: (UICollectionView) -> ()) {
        self.view.uiCollectionView(views)
    }
    
    func uiTextView(views: (UITextView) -> ()) {
        self.view.uiTextView(views)
    }
    
    func uiTableViewCell(views: (UITableViewCell) -> ()) {
        self.view.uiTableViewCell(views)
    }
    
    func uiVisualEffectView(views: (UIVisualEffectView) -> ()) {
        self.view.uiVisualEffectView(views)
    }
    
    func uiActivityIndicatorView(views: (UIActivityIndicatorView) -> ()) {
        self.view.uiActivityIndicatorView(views)
    }
    
    func uiLabel(views: (UILabel) -> ()) {
        self.view.uiLabel(views)
    }
    
    func uiTabBar(views: (UITabBar) -> ()) {
        self.view.uiTabBar(views)
    }
    
    func uiTableViewHeaderFooterView(views: (UITableViewHeaderFooterView) -> ()) {
        self.view.uiTableViewHeaderFooterView(views)
    }
    
    func uiStackView(views: (UIStackView) -> ()) {
        self.view.uiStackView(views)
    }
    
    func uiSearchBar(views: (UISearchBar) -> ()) {
        self.view.uiSearchBar(views)
    }
    
    func uiPopoverBackgroundView(views: (UIPopoverBackgroundView) -> ()) {
        self.view.uiPopoverBackgroundView(views)
    }
    
    func uiImageView(views: (UIImageView) -> ()) {
        self.view.uiImageView(views)
    }
    
    func uiProgressView(views: (UIProgressView) -> ()) {
        self.view.uiProgressView(views)
    }
    
    func uiNavigationBar(views: (UINavigationBar) -> ()) {
        self.view.uiNavigationBar(views)
    }
    
}

extension UIStackView {
    override internal func addChild(view: UIView) {
        addArrangedSubview(view)
    }
}