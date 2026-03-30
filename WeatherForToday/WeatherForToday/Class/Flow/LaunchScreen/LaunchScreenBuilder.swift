//
//  LaunchScreenViewBuilder.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit

struct LaunchScreenBuilder {
    static func build(di: AppDI = .shared) -> UIViewController {
        let vc = LaunchScreenView()
        let vm = LaunchScreenViewModel(di: di)
        vc.set(vm)
        return vc
    }
}