//
//  SuccessView.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import SnapKit

struct SuccessViewModel {
    let title: String
    let region: String
    let tempC: String
    let text: String
}

final class SuccessView: UIView {
    
    let miniLogoImageView: UIImageView = {
        let imageView = UIImageView(image: Images.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
           let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    } ()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
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
    
    func set(_ model: SuccessViewModel) {
        titleLabel.text = model.title
        subTitleLabel.text = model.region
        temperatureLabel.text = model.tempC
    }
}

private extension SuccessView {
    func loadView() {
        addSubViews()
        addConstraints()
    }
    
    func addSubViews() {
        addSubview(miniLogoImageView)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(temperatureLabel)
    }
    
    func addConstraints() {
        miniLogoImageView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.top.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(164)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
