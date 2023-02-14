//
//  MeowFactsViewController.swift
//  MeowFacts
//
//  Created by Qi Zhan on 2/13/23.
//

import UIKit

class MeowFactsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var meowFactsLabel: UILabel!
    
    lazy var activityView: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)
    var presenter: MeowFactsViewToPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        meowFactsLabel.numberOfLines = 0
        startLoading()
        presenter?.updateView()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapRecognizer)
    }

    @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
        startLoading()
        presenter?.updateView()
    }
    
    private func startLoading() {
        activityView.center = self.view.center
        self.view.addSubview(activityView)
        activityView.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func stopLoading() {
        activityView.stopAnimating()
        view.isUserInteractionEnabled = true
    }
    
}


extension MeowFactsViewController: MeowFactsPresenterToViewProtocol {
    
    // Why @MainActor doesn't work here? only dispatch queue works
    // Is it because of UIViewController?
    func showKitten() {
        let cat = presenter?.getMeowFacts()
        meowFactsLabel.text = cat?.fact
        imageView.image = cat?.image
        stopLoading()
    }
    
    @MainActor
    func showError() {
        
    }
    
}
