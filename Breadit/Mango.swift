// Generated code by Mango

import UIKit


extension UIView {
    
    internal func addChild(view: UIView) {
        addSubview(view)
    }
    
    func uiView(views: (UIView) -> ()) -> UIView {
        let view = UIView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiToolbar(views: (UIToolbar) -> ()) -> UIToolbar {
        let view = UIToolbar()
        addChild(view)
        views(view)
        return view
    }
    
    func uiPickerView(views: (UIPickerView) -> ()) -> UIPickerView {
        let view = UIPickerView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiControl(views: (UIControl) -> ()) -> UIControl {
        let view = UIControl()
        addChild(view)
        views(view)
        return view
    }
    
    func uiSwitch(views: (UISwitch) -> ()) -> UISwitch {
        let view = UISwitch()
        addChild(view)
        views(view)
        return view
    }
    
    func uiSegmentedControl(views: (UISegmentedControl) -> ()) -> UISegmentedControl {
        let view = UISegmentedControl()
        addChild(view)
        views(view)
        return view
    }
    
    func uiSlider(views: (UISlider) -> ()) -> UISlider {
        let view = UISlider()
        addChild(view)
        views(view)
        return view
    }
    
    func uiRefreshControl(views: (UIRefreshControl) -> ()) -> UIRefreshControl {
        let view = UIRefreshControl()
        addChild(view)
        views(view)
        return view
    }
    
    func uiTextField(views: (UITextField) -> ()) -> UITextField {
        let view = UITextField()
        addChild(view)
        views(view)
        return view
    }
    
    func uiStepper(views: (UIStepper) -> ()) -> UIStepper {
        let view = UIStepper()
        addChild(view)
        views(view)
        return view
    }
    
    func uiDatePicker(views: (UIDatePicker) -> ()) -> UIDatePicker {
        let view = UIDatePicker()
        addChild(view)
        views(view)
        return view
    }
    
    func uiPageControl(views: (UIPageControl) -> ()) -> UIPageControl {
        let view = UIPageControl()
        addChild(view)
        views(view)
        return view
    }
    
    func uiButton(views: (UIButton) -> ()) -> UIButton {
        let view = UIButton()
        addChild(view)
        views(view)
        return view
    }
    
    func uiCollectionReusableView(views: (UICollectionReusableView) -> ()) -> UICollectionReusableView {
        let view = UICollectionReusableView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiCollectionViewCell(views: (UICollectionViewCell) -> ()) -> UICollectionViewCell {
        let view = UICollectionViewCell()
        addChild(view)
        views(view)
        return view
    }
    
    func uiInputView(views: (UIInputView) -> ()) -> UIInputView {
        let view = UIInputView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiWebView(views: (UIWebView) -> ()) -> UIWebView {
        let view = UIWebView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiWindow(views: (UIWindow) -> ()) -> UIWindow {
        let view = UIWindow()
        addChild(view)
        views(view)
        return view
    }
    
    func uiScrollView(views: (UIScrollView) -> ()) -> UIScrollView {
        let view = UIScrollView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiTableView(views: (UITableView) -> ()) -> UITableView {
        let view = UITableView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiCollectionView(views: (UICollectionView) -> ()) -> UICollectionView {
        let view = UICollectionView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiTextView(views: (UITextView) -> ()) -> UITextView {
        let view = UITextView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiTableViewCell(views: (UITableViewCell) -> ()) -> UITableViewCell {
        let view = UITableViewCell()
        addChild(view)
        views(view)
        return view
    }
    
    func uiVisualEffectView(views: (UIVisualEffectView) -> ()) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiActivityIndicatorView(views: (UIActivityIndicatorView) -> ()) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiLabel(views: (UILabel) -> ()) -> UILabel {
        let view = UILabel()
        addChild(view)
        views(view)
        return view
    }
    
    func uiTabBar(views: (UITabBar) -> ()) -> UITabBar {
        let view = UITabBar()
        addChild(view)
        views(view)
        return view
    }
    
    func uiTableViewHeaderFooterView(views: (UITableViewHeaderFooterView) -> ()) -> UITableViewHeaderFooterView {
        let view = UITableViewHeaderFooterView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiStackView(views: (UIStackView) -> ()) -> UIStackView {
        let view = UIStackView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiSearchBar(views: (UISearchBar) -> ()) -> UISearchBar {
        let view = UISearchBar()
        addChild(view)
        views(view)
        return view
    }
    
    func uiPopoverBackgroundView(views: (UIPopoverBackgroundView) -> ()) -> UIPopoverBackgroundView {
        let view = UIPopoverBackgroundView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiImageView(views: (UIImageView) -> ()) -> UIImageView {
        let view = UIImageView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiProgressView(views: (UIProgressView) -> ()) -> UIProgressView {
        let view = UIProgressView()
        addChild(view)
        views(view)
        return view
    }
    
    func uiNavigationBar(views: (UINavigationBar) -> ()) -> UINavigationBar {
        let view = UINavigationBar()
        addChild(view)
        views(view)
        return view
    }
    
}

extension UIViewController {
    
    func uiView(views: (UIView) -> ()) {
        let view = UIView()
        self.view = view
        views(view)
    }
    
    func uiToolbar(views: (UIToolbar) -> ()) {
        let view = UIToolbar()
        self.view = view
        views(view)
    }
    
    func uiPickerView(views: (UIPickerView) -> ()) {
        let view = UIPickerView()
        self.view = view
        views(view)
    }
    
    func uiControl(views: (UIControl) -> ()) {
        let view = UIControl()
        self.view = view
        views(view)
    }
    
    func uiSwitch(views: (UISwitch) -> ()) {
        let view = UISwitch()
        self.view = view
        views(view)
    }
    
    func uiSegmentedControl(views: (UISegmentedControl) -> ()) {
        let view = UISegmentedControl()
        self.view = view
        views(view)
    }
    
    func uiSlider(views: (UISlider) -> ()) {
        let view = UISlider()
        self.view = view
        views(view)
    }
    
    func uiRefreshControl(views: (UIRefreshControl) -> ()) {
        let view = UIRefreshControl()
        self.view = view
        views(view)
    }
    
    func uiTextField(views: (UITextField) -> ()) {
        let view = UITextField()
        self.view = view
        views(view)
    }
    
    func uiStepper(views: (UIStepper) -> ()) {
        let view = UIStepper()
        self.view = view
        views(view)
    }
    
    func uiDatePicker(views: (UIDatePicker) -> ()) {
        let view = UIDatePicker()
        self.view = view
        views(view)
    }
    
    func uiPageControl(views: (UIPageControl) -> ()) {
        let view = UIPageControl()
        self.view = view
        views(view)
    }
    
    func uiButton(views: (UIButton) -> ()) {
        let view = UIButton()
        self.view = view
        views(view)
    }
    
    func uiCollectionReusableView(views: (UICollectionReusableView) -> ()) {
        let view = UICollectionReusableView()
        self.view = view
        views(view)
    }
    
    func uiCollectionViewCell(views: (UICollectionViewCell) -> ()) {
        let view = UICollectionViewCell()
        self.view = view
        views(view)
    }
    
    func uiInputView(views: (UIInputView) -> ()) {
        let view = UIInputView()
        self.view = view
        views(view)
    }
    
    func uiWebView(views: (UIWebView) -> ()) {
        let view = UIWebView()
        self.view = view
        views(view)
    }
    
    func uiWindow(views: (UIWindow) -> ()) {
        let view = UIWindow()
        self.view = view
        views(view)
    }
    
    func uiScrollView(views: (UIScrollView) -> ()) {
        let view = UIScrollView()
        self.view = view
        views(view)
    }
    
    func uiTableView(views: (UITableView) -> ()) {
        let view = UITableView()
        self.view = view
        views(view)
    }
    
    func uiCollectionView(views: (UICollectionView) -> ()) {
        let view = UICollectionView()
        self.view = view
        views(view)
    }
    
    func uiTextView(views: (UITextView) -> ()) {
        let view = UITextView()
        self.view = view
        views(view)
    }
    
    func uiTableViewCell(views: (UITableViewCell) -> ()) {
        let view = UITableViewCell()
        self.view = view
        views(view)
    }
    
    func uiVisualEffectView(views: (UIVisualEffectView) -> ()) {
        let view = UIVisualEffectView()
        self.view = view
        views(view)
    }
    
    func uiActivityIndicatorView(views: (UIActivityIndicatorView) -> ()) {
        let view = UIActivityIndicatorView()
        self.view = view
        views(view)
    }
    
    func uiLabel(views: (UILabel) -> ()) {
        let view = UILabel()
        self.view = view
        views(view)
    }
    
    func uiTabBar(views: (UITabBar) -> ()) {
        let view = UITabBar()
        self.view = view
        views(view)
    }
    
    func uiTableViewHeaderFooterView(views: (UITableViewHeaderFooterView) -> ()) {
        let view = UITableViewHeaderFooterView()
        self.view = view
        views(view)
    }
    
    func uiStackView(views: (UIStackView) -> ()) {
        let view = UIStackView()
        self.view = view
        views(view)
    }
    
    func uiSearchBar(views: (UISearchBar) -> ()) {
        let view = UISearchBar()
        self.view = view
        views(view)
    }
    
    func uiPopoverBackgroundView(views: (UIPopoverBackgroundView) -> ()) {
        let view = UIPopoverBackgroundView()
        self.view = view
        views(view)
    }
    
    func uiImageView(views: (UIImageView) -> ()) {
        let view = UIImageView()
        self.view = view
        views(view)
    }
    
    func uiProgressView(views: (UIProgressView) -> ()) {
        let view = UIProgressView()
        self.view = view
        views(view)
    }
    
    func uiNavigationBar(views: (UINavigationBar) -> ()) {
        let view = UINavigationBar()
        self.view = view
        views(view)
    }
    
}

extension UIStackView {
    override internal func addChild(view: UIView) {
        addArrangedSubview(view)
    }
}
