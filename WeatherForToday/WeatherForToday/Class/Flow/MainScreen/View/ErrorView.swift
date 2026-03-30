//
//  ErrorStateView.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import SnapKit

final class ErrorView: UIView {
    
    let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Повторить", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.9)
        button.layer.cornerRadius = 12
        return button
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func setErrorText(text: String) {
        errorLabel.text = text
    }
}

private extension ErrorView {
    func loadView() {
        addSubViews()
        addConstraints()
    }
    
    func addSubViews() {
        addSubview(retryButton)
        addSubview(errorLabel)
    }
    
    func addConstraints() {
        
        errorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(retryButton.snp.top).offset(-32)
        }
        
        retryButton.snp.makeConstraints {
            $0.width.equalTo(240)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(40)
        }
    }
}
