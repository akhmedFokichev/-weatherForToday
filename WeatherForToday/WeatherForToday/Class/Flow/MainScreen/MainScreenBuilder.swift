//
//  MainScreenBuilder.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit

struct MainScreenBuilder {
    static func build() -> UIViewController {
        let vc = MainScreenView()
        let vm = MainScreenViewModel()
        vc.set(vm)
        return vc
    }
}
