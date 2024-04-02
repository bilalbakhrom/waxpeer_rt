//
//  HomeViewController.swift
//  WaxpeerRT
//
//  Created by Bilal Bakhrom on 2024-04-02.
//

import SwiftUI
import AppColors
import AppBaseController

final class HomeViewController: BaseViewController {
    // MARK: - Properties
    
    private let viewModel: HomeViewModel
    
    private lazy var rootView: UIView = {
        let swiftUIView = HomeView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        return hostingController.view
    }()
    
    // MARK: - Initialization
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .modulePrimaryBackground
        setNavigationBar(title: "Marketplace")
        bind()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
    
    // MARK: - Binding
    
    override func bind() {
        viewModel
            .itemPublisher
            .debounce(for: .seconds(0.001), scheduler: RunLoop.main)
            .assign(to: &viewModel.$debouncedItems)
        
        viewModel
            .$debouncedItems
            .receive(on: RunLoop.main)
            .sink { [weak self] items in
                guard let self else { return }
                let count = items.count
                setNavigationBar(title: "Marketplace", subtitle: "\(count) items")
            }
            .store(in: &subscriptions)
    }
    
    // MARK: - Layout
    
    override func embedSubviews() {
        view.addSubview(rootView)
    }
    
    override func activateSubviewsConstraints() {
        NSLayoutConstraint.activate([
            rootView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rootView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rootView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
