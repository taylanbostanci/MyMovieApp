//
//  ActivityIndicator.swift
//  MyMovieApp
//
//  Created by Taylan Bostanci on 5.04.2021.
//

import UIKit

fileprivate var containerView : UIView!
fileprivate var alertView : UIView!
fileprivate var indicatorView : UIView!

extension UIViewController {
    
    func hideActivityIndicator() {
        DispatchQueue.main.async {
            containerView?.removeFromSuperview()
            alertView?.removeFromSuperview()
            indicatorView?.removeFromSuperview()
            containerView = nil
            alertView = nil
            indicatorView = nil
        }
    }
}
