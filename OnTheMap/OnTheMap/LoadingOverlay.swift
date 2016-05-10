//
//  LoadingOverlay.swift
//  OnTheMap
//
//  Created by Jeff Schmitz on 5/10/16.
//  Copyright © 2016 Jeff Schmitz. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay{
    
    var backgroundView : UIView!
    let boundingBoxView : UIView!
    
    var overlayView : UIView!
    var activityIndicatorView : UIActivityIndicatorView!
    var messageLabel : UILabel!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init(){
        backgroundView = UIView(frame: CGRectZero)
        backgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        boundingBoxView = UIView(frame: CGRectZero)
        boundingBoxView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        boundingBoxView.layer.cornerRadius = 12.0
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        
        messageLabel = UILabel(frame: CGRectZero)
        messageLabel.font = UIFont.boldSystemFontOfSize(UIFont.labelFontSize())
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = .Center
        messageLabel.shadowColor = UIColor.blackColor()
        messageLabel.shadowOffset = CGSizeMake(0.0, 1.0)
        messageLabel.numberOfLines = 0
        
    }
    
    public func showOverlay(view: UIView, message: String! = "") {
        
        backgroundView.frame.size.width = UIScreen.mainScreen().bounds.width
        backgroundView.frame.size.height = UIScreen.mainScreen().bounds.height
        backgroundView.frame.origin.x = 0
        backgroundView.frame.origin.y = 0
        
        boundingBoxView.frame.size.width = 160.0
        boundingBoxView.frame.size.height = 160.0
        boundingBoxView.frame.origin.x = ceil((view.bounds.width / 2.0) - (boundingBoxView.frame.width / 2.0))
        boundingBoxView.frame.origin.y = ceil((view.bounds.height / 2.0) - (boundingBoxView.frame.height / 2.0))
        
        activityIndicatorView.frame.origin.x = ceil((view.bounds.width / 2.0) - (activityIndicatorView.frame.width / 2.0))
        activityIndicatorView.frame.origin.y = ceil((view.bounds.height / 2.0) - (activityIndicatorView.frame.height / 2.0))
        
        messageLabel.text = message
        
        let messageLabelSize = messageLabel.sizeThatFits(CGSizeMake(160.0 - 20.0 * 2.0, CGFloat.max))
        messageLabel.frame.size.width = messageLabelSize.width
        messageLabel.frame.size.height = messageLabelSize.height
        messageLabel.frame.origin.x = ceil((view.bounds.width / 2.0) - (messageLabel.frame.width / 2.0))
        messageLabel.frame.origin.y = ceil(activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + ((boundingBoxView.frame.height - activityIndicatorView.frame.height) / 4.0) - (messageLabel.frame.height / 2.0))
        
        view.addSubview(backgroundView)
        view.addSubview(boundingBoxView)
        view.addSubview(activityIndicatorView)
        view.addSubview(messageLabel)
        
        activityIndicatorView.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicatorView.stopAnimating()
        
        messageLabel.removeFromSuperview()
        activityIndicatorView.removeFromSuperview()
        boundingBoxView.removeFromSuperview()
        backgroundView.removeFromSuperview()
    }
    
    
}