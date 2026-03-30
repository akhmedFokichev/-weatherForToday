//
//  NavigationService.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit

protocol NavigationServiceProtocol: AnyObject {
    func setRoot(_ viewController: UIViewController, embeddedInNavigation: Bool, animated: Bool)
    func push(_ viewController: UIViewController, animated: Bool)
    func pop(animated: Bool)
    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

final class NavigationService: NavigationServiceProtocol {
    private weak var window: UIWindow?

    init(window: UIWindow) {
        self.window = window
    }

    func setRoot(_ viewController: UIViewController, embeddedInNavigation: Bool = true, animated: Bool = false) {
        guard let window else { return }

        let root: UIViewController
        if embeddedInNavigation {
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.setNavigationBarHidden(true, animated: false)
            root = navigationController
        } else {
            root = viewController
        }

        window.rootViewController = root
        window.makeKeyAndVisible()

        guard animated else { return }
        UIView.transition(
            with: window,
            duration: 0.25,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }

    func push(_ viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func present(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        topViewController?.present(viewController, animated: animated, completion: completion)
    }

    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        topViewController?.dismiss(animated: animated, completion: completion)
    }

    private var navigationController: UINavigationController? {
        if let navigationController = window?.rootViewController as? UINavigationController {
            return navigationController
        }
        return window?.rootViewController?.navigationController
    }

    private var topViewController: UIViewController? {
        var top = window?.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}
