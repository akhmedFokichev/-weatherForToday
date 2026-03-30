//
//  MainScreen.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import SVProgressHUD

final class MainScreenView: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: Images.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var errorView: ErrorView = ErrorView()
    private lazy var successCarousel: SuccessCarouselView = SuccessCarouselView()
    
    private var viewModel: MainScreenViewModel?
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel?.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        addSubviews()
        addConstraints()
    }
    
    func set(_ viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        bind(viewModel)
    }
}

private extension MainScreenView {
    func bind(_ viewModel: MainScreenViewModel) {
        viewModel.state
            .delay(.milliseconds(400), scheduler: MainScheduler.asyncInstance)
            .bind { [weak self] state in
            self?.updateView(state)
        }.disposed(by: bag)
        
        errorView.retryButton
            .rx.tap.bind { [weak self]in
            self?.setLoadingState()
            self?.viewModel?.tapRetry()
        }.disposed(by: bag)
    }
    
    func updateView(_ state: MainScreenState) {
        switch state {
        case .initialization:
            errorView.isHidden = true
            successCarousel.isHidden = true
            
        case .loading:
            setLoadingState()
            
        case let .error(error):
            errorView.setErrorText(text: error)
            errorView.isHidden = false
            SVProgressHUD.dismiss()
            
        case let .success(models):
            setSuccessState(models)
        }
    }
    
    func setLoadingState() {
        logoImageView.isHidden = false
        errorView.isHidden = true
        successCarousel.isHidden = true
        SVProgressHUD.show()
    }
    
    func setSuccessState(_ models: [SuccessViewModel]) {
        logoImageView.isHidden = true
        SVProgressHUD.dismiss()
        successCarousel.isHidden = false
        successCarousel.configure(models: models)
        print("print weather, pages: \(models.count)")
    }
}

private extension MainScreenView {
    func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(errorView)
        view.addSubview(successCarousel)
    }
    
    func addConstraints() {
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(260)
            $0.centerX.equalToSuperview()
        }
        
        errorView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        successCarousel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: 240))
    }
}
