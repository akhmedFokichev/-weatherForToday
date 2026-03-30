//
//  SuccessView.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import SnapKit

struct HourWeatherLine: Hashable {
    let time: String
    let detail: String
}

struct SuccessViewModel {
    let date: String
    let title: String
    let region: String
    let tempC: String
    let text: String
    let hourly: [HourWeatherLine]
}

final class SuccessView: UIView {

    let miniLogoImageView: UIImageView = {
        let imageView = UIImageView(image: Images.logo)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

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

    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let hourlyScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.alwaysBounceVertical = true
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()

    private let hourlyStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 10
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return stack
    }()

    private let hourlyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "По часам"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        label.textAlignment = .left
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
        dateLabel.text = model.date
        titleLabel.text = model.title
        subTitleLabel.text = model.region
        temperatureLabel.text = model.tempC
        conditionLabel.text = model.text
        populateHourlyStack(model.hourly)
    }
}

private extension SuccessView {
    func loadView() {
        addSubViews()
        addConstraints()
    }

    func addSubViews() {
        addSubview(miniLogoImageView)
        addSubview(dateLabel)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(temperatureLabel)
        addSubview(conditionLabel)
        addSubview(hourlyScrollView)
        hourlyScrollView.addSubview(hourlyStack)
    }

    func addConstraints() {
        miniLogoImageView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.top.equalToSuperview().offset(32)
            $0.trailing.equalToSuperview().inset(16)
        }

        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(144)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(32)
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

        conditionLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        hourlyScrollView.snp.makeConstraints {
            $0.top.equalTo(conditionLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-8)
        }

        let hcg = hourlyScrollView.contentLayoutGuide
        let hfg = hourlyScrollView.frameLayoutGuide
        hourlyStack.snp.makeConstraints {
            $0.top.equalTo(hcg.snp.top)
            $0.leading.equalTo(hcg.snp.leading)
            $0.trailing.equalTo(hcg.snp.trailing)
            $0.bottom.equalTo(hcg.snp.bottom)
            $0.width.equalTo(hfg.snp.width)
        }
    }

    func populateHourlyStack(_ items: [HourWeatherLine]) {
        hourlyStack.arrangedSubviews.forEach {
            hourlyStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        if !items.isEmpty {
            hourlyStack.addArrangedSubview(hourlyTitleLabel)
        }
        for line in items {
            hourlyStack.addArrangedSubview(makeHourRow(line))
        }
    }

    func makeHourRow(_ line: HourWeatherLine) -> UIView {
        let timeLabel = UILabel()
        timeLabel.text = line.time
        timeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
        timeLabel.textColor = .label
        timeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        let detailLabel = UILabel()
        detailLabel.text = line.detail
        detailLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        detailLabel.textColor = .secondaryLabel
        detailLabel.numberOfLines = 0

        let row = UIStackView(arrangedSubviews: [timeLabel, detailLabel])
        row.axis = .horizontal
        row.alignment = .firstBaseline
        row.spacing = 12
        row.distribution = .fill
        timeLabel.snp.makeConstraints { $0.width.equalTo(52) }
        return row
    }
}
