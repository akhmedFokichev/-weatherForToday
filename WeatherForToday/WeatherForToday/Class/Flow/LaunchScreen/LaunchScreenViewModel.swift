//
//  LaunchScreenViewModel.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import RxRelay
import RxSwift

enum LaunchScreenState {
    case initialization
    case loading(url: String)
    case reload(url: String)
    case didFinish
}

final class LaunchScreenViewModel {
    private let navigationService: NavigationServiceProtocol?

    let state = BehaviorRelay<LaunchScreenState>(value: .initialization)

    init(di: AppDI = .shared) {
        self.navigationService = di.navigationService
    }

    func viewDidLoad() {
        navigationService?.setRoot(MainScreenBuilder.build(), embeddedInNavigation: false, animated: false)
    }
}
