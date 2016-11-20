//
//  CustomImageView.swift
//  Vietlott
//
//  Created by CongTruong on 11/20/16.
//  Copyright © 2016 congtruong. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
    let progressIndicatorView = CircularLoaderView(frame: CGRect.zero)
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(self.progressIndicatorView)
        progressIndicatorView.frame = bounds
        progressIndicatorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func setImageWith(_ url: URL) {
        sd_setImage(with: url, placeholderImage: nil, options: .cacheMemoryOnly, progress: {
            [weak self]
            (receivedSize, expectedSize) -> Void in
            // Update progress here
            self!.progressIndicatorView.progress = CGFloat(receivedSize)/CGFloat(expectedSize)
        }) {
            [weak self]
            (image, error, _, _) -> Void in
            // Reveal image here
            self!.progressIndicatorView.reveal()
        }
    }

}
