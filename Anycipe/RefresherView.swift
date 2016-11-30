//
//  RefresherView.swift
//  Anycipe
//
//  Created by Vitaly on 27.11.16.
//  Copyright © 2016 Vitaly. All rights reserved.
//

import UIKit
import Refresher


class RefresherView: UIView, PullToRefreshViewDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelTitle: UILabel!
    
    
    func pullToRefreshAnimationDidStart(_ view: PullToRefreshView) {
        activityIndicator.startAnimating()
        labelTitle.text = "Загрузка..."
    }
    
    func pullToRefreshAnimationDidEnd(_ view: PullToRefreshView) {
        activityIndicator.stopAnimating()
        labelTitle.text = ""
    }
    
    func pullToRefresh(_ view: PullToRefreshView, progressDidChange progress: CGFloat) {
        
    }
    
    func pullToRefresh(_ view: PullToRefreshView, stateDidChange state: PullToRefreshViewState) {
        
        switch state {
        case .loading:
            labelTitle.text = "Загрузка..."
        case .pullToRefresh:
            labelTitle.text = "Pull to refresh"
        case .releaseToRefresh:
            labelTitle.text = "Release to refresh"
        }
    }
}
