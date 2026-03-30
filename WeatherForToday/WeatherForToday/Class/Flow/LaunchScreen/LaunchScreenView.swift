//
//  LaunchScreenView.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class LaunchScreenView: UIViewController {
    private var viewModel: LaunchScreenViewModel?
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        viewModel?.viewDidLoad()
    }
    
    func set(_ viewModel: LaunchScreenViewModel) {
        self.viewModel = viewModel
        bind(viewModel)
    }
}

private extension LaunchScreenView {
    
    func bind(_ viewModel: LaunchScreenViewModel) {
        
    }
}
