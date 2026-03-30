//
//  MainScreen.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import RxSwift
import RxCocoa

final class MainScreenView: UIViewController {
    private var viewModel: MainScreenViewModel?
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel?.viewDidLoad()
    }
    
    func set(_ viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        bind(viewModel)
    }
}

private extension MainScreenView {
    func bind(_ viewModel: MainScreenViewModel) {
        
    }
}
