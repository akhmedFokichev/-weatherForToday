//
//  MainScreenViewModel.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import RxRelay
import RxSwift

enum MainScreenState {
    case initialization
    case loading(url: String)
    case reload(url: String)
    case didFinish
}

final class MainScreenViewModel {
    
    let state = BehaviorRelay<MainScreenState>(value: .initialization)
    
    private var reloadCount = 0
    
    func viewDidLoad() {
    }
    
}

private extension MainScreenViewModel {
    
}
