//
//  SelectPlanViewController.swift
//  IVPNClient
//
//  Created by Juraj Hilje on 15/04/2020.
//  Copyright © 2020 IVPN. All rights reserved.
//

import UIKit

class SelectPlanViewController: UITableViewController {
    
    // MARK: - @IBOutlets -
    
    @IBOutlet weak var selectPlanView: SelectPlanView!
    
    // MARK: - Properties -
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        return spinner
    }()
    
    lazy var retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(fetchProducts), for: .touchUpInside)
        button.setTitle("Retry", for: .normal)
        button.sizeToFit()
        button.isHidden = true
        return button
    }()
    
    var displayMode: DisplayMode = .loading {
        didSet {
            switch displayMode {
            case .loading:
                spinner.startAnimating()
                tableView.separatorStyle = .none
                retryButton.isHidden = true
            case .content:
                spinner.stopAnimating()
                tableView.separatorStyle = .singleLine
                retryButton.isHidden = true
            case .error:
                spinner.stopAnimating()
                tableView.separatorStyle = .none
                retryButton.isHidden = false
            }
            
            tableView.reloadData()
        }
    }
    
    var standardService = Service(type: .standard, duration: .month)
    var proService = Service(type: .pro, duration: .month)
    
    // MARK: - View lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigation()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if displayMode == .loading {
            fetchProducts()
        }
    }
    
    // MARK: - Segues -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectStandardPlan" {
            let viewController = segue.destination as! PaymentViewController
            viewController.collection = [.standard(.monthly), .standard(.yearly)]
        }
        
        if segue.identifier == "selectProPlan" {
            let viewController = segue.destination as! PaymentViewController
            viewController.collection = [.pro(.monthly), .pro(.yearly)]
        }
    }
    
    // MARK: - Private methods -
    
    private func initNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icon-arrow-left"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(backButtonPressed(sender:)), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc private func backButtonPressed(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        tableView.separatorStyle = .none
        view.addSubview(spinner)
        view.addSubview(retryButton)
        spinner.bb.centerX().centerY(-80)
        retryButton.bb.centerX().centerY(-80)
    }
    
    @objc private func fetchProducts() {
        displayMode = .loading
        
        IAPManager.shared.fetchProducts { [weak self] products, error in
            guard let self = self else { return }
            
            if error != nil {
                self.showAlert(title: "iTunes Store error", message: "Cannot connect to iTunes Store")
                self.displayMode = .error
                return
            }
            
            if products != nil {
                self.updateSubscriptions()
                self.displayMode = .content
            }
        }
    }
    
    private func updateSubscriptions() {
        selectPlanView.standardPriceLabel.text = "\(standardService.priceText()) / \(standardService.durationText())"
        selectPlanView.proPriceLabel.text = "\(proService.priceText()) / \(proService.durationText())"
    }
    
}

// MARK: - UITableViewDelegate -

extension SelectPlanViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard displayMode == .content else {
            return 0
        }
        
        return tableView.rowHeight
    }
    
}

extension SelectPlanViewController {
    
    enum DisplayMode {
        case loading
        case content
        case error
    }
    
}
