//
//  StatusInfoView.swift
//  MamaBear
//
//  Created by Brandon Plaster on 11/9/15.
//  Copyright © 2015 CTSplashThat. All rights reserved.
//

import UIKit

class StatusInfoView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var statusColorView: UIView!
    @IBOutlet var statusLabel: UILabel!
    
    convenience init(frame: CGRect, status: String, color: UIColor){
        self.init(frame: frame)
        autoresizingMask = UIViewAutoresizing.FlexibleWidth

        xibSetup(status, color: color)
    }
    
    func xibSetup(status: String, color: UIColor) {
        contentView = loadViewFromNib()
        
        contentView.frame = bounds
        statusColorView.backgroundColor = color
        statusLabel.text = status
        
        addSubview(contentView)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "StatusInfoView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
}
