//
//  BaseExtensions.swift
//  TestCoreData
//
//  Created by Maksym Vitovych on 24.06.2021.
//

import UIKit
//import SDWebImage

extension UIStoryboard {
    enum Storyboard {
        case tabBarViewController
        
        var title: String {
            return String(describing: self).firstUppercased
        }
    }
    
    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.title, bundle: nil)
    }
    
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T {
        let id = NSStringFromClass(T.self).components(separatedBy: ".").last!
        return self.instantiateViewController(withIdentifier: id) as! T
    }
}

extension Float {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIViewController {
    static var fromStoryboard: Self {
        let selfName = NSStringFromClass(self).components(separatedBy: ".").last!
        let storyboard = UIStoryboard(name: selfName, bundle: nil)
        let customViewController = storyboard.instantiateViewController(withIdentifier: selfName) as! Self
        
        return customViewController
    }
    
    class func instance(_ storyboard: UIStoryboard.Storyboard) -> Self {
        
        let storyboard = UIStoryboard(storyboard: storyboard)
        let viewController = storyboard.instantiateViewController(self)
        
        return viewController
    }
    
    class func fromNib<T: UIViewController>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func showErrorAlert(title: String, message: String) {
        self.showAlert(title: title, message: message)
    }
    
    func showAlert(title: String?, message: String?, customActions: [UIAlertAction] = [], completion: (() -> Void)? = nil) {
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            if customActions.isEmpty {
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in completion?() })
            } else {
                for action in customActions {
                    alert.addAction(action)
                }
            }
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension UINavigationController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(vc, animated: animated)
        }
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! T
    }
    
    class var identifier: String {
        return String(describing: self)
    }
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))

        self.layer.add(animation, forKey: "position")
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: cell.identifier, for: indexPath) as! T
    }
    
    func registerCell<T: UITableViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: T.identifier, bundle: nil), forCellReuseIdentifier: T.identifier)
    }
}

extension UICollectionView {
    func dequeueCell<T: UICollectionViewCell>(_ cell: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: cell.identifier, for: indexPath) as! T
    }
    
    func registerCell<T: UICollectionViewCell>(_ cell: T.Type) {
        self.register(UINib(nibName: cell.identifier, bundle: nil), forCellWithReuseIdentifier: cell.identifier)
    }
    
    func dequeueHeader<T: UICollectionReusableView>(_ header: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: header.identifier, for: indexPath) as! T
    }
    
    func dequeueFooter<T: UICollectionReusableView>(_ header: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: header.identifier, for: indexPath) as! T
    }
    
    func registerHeader<T: UICollectionReusableView>(_ view: T.Type) {
        return self.register(UINib(nibName: view.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: view.identifier)
    }
    
    func registerFooter<T: UICollectionReusableView>(_ view: T.Type) {
        self.register(UINib(nibName: view.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: view.identifier)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(for font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    var htmlAttributedString: NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let str = try? NSMutableAttributedString(
                data: data,
                options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
                documentAttributes: nil) else { return nil }
        return str
    }
    
    func format(_ arguments: CVarArg...) -> String {
        let args = arguments.map {
            if let arg = $0 as? Int { return String(arg) }
            if let arg = $0 as? Float { return String(arg) }
            if let arg = $0 as? Double { return String(arg) }
            if let arg = $0 as? Int64 { return String(arg) }
            if let arg = $0 as? String { return String(arg) }
            if let arg = $0 as? Character { return String(arg) }
            if let arg = $0 as? CGFloat { return String(Int(arg)) }

            return "(null)"
        } as [CVarArg]
        
        return String.init(format: self, arguments: args)
    }
}

extension NSNotification.Name {
    static let internetReachability = Notification.Name("internetReachability")
}

// Using extension give us advantage of replacing the library with other ones with ease.
//protocol ImageLoadable {
//    func setImage(from url: URL, completion: ((UIImage) -> Void)?)
//}

//extension ImageLoadable where Self: UIImageView {
//
//    func setImage(from url: URL, completion: ((UIImage) -> Void)? = nil) {
//        self.sd_setImage(with: url, completed: nil)
//    }
//
//    func setImageWithOutPlaceholder(from url: URL, completion: ((UIImage) -> Void)? = nil) {
//        self.sd_setImage(with: url, completed: nil)
//    }
//
//    func setImage(from url: URL, placeholder: UIImage) {
//        self.sd_setImage(with: url, placeholderImage: placeholder)
//    }
//}
//
//extension UIImageView: ImageLoadable {}

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

