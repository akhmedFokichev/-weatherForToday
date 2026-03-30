//
//  SuccessCarouselView.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import UIKit
import SnapKit

final class SuccessCarouselView: UIView {

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.isScrollEnabled = true
        scroll.showsHorizontalScrollIndicator = true
        scroll.showsVerticalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        scroll.alwaysBounceVertical = false
        scroll.backgroundColor = .clear
        scroll.clipsToBounds = true
        scroll.delaysContentTouches = false
        scroll.canCancelContentTouches = true
        scroll.contentInsetAdjustmentBehavior = .never
        scroll.automaticallyAdjustsScrollIndicatorInsets = false
        return scroll
    }()

    private let pageControl: UIPageControl = {
        let control = UIPageControl()
        control.currentPageIndicatorTintColor = .label
        control.pageIndicatorTintColor = .secondaryLabel
        control.hidesForSinglePage = true
        control.isUserInteractionEnabled = false
        return control
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private var models: [SuccessViewModel] = []
    private var lastLaidOutPageWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        addConstraints()
        scrollView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(models: [SuccessViewModel]) {
        self.models = models
        lastLaidOutPageWidth = 0
        pageControl.currentPage = 0
        clearPages()
        for model in models {
            let page = SuccessView()
            page.set(model)
            contentView.addSubview(page)
        }
        pageControl.numberOfPages = models.count
        setNeedsLayout()
        layoutIfNeeded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutScrollContent()
    }

    private func layoutScrollContent() {
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        guard pageWidth > 0, pageHeight > 0, !models.isEmpty else {
            scrollView.contentSize = .zero
            contentView.frame = .zero
            lastLaidOutPageWidth = 0
            return
        }

        let count = models.count
        let totalWidth = pageWidth * CGFloat(count)

        contentView.frame = CGRect(x: 0, y: 0, width: totalWidth, height: pageHeight)
        for (index, page) in contentView.subviews.enumerated() {
            page.frame = CGRect(
                x: CGFloat(index) * pageWidth,
                y: 0,
                width: pageWidth,
                height: pageHeight
            )
        }

        scrollView.contentSize = CGSize(width: totalWidth, height: pageHeight)

        if lastLaidOutPageWidth != pageWidth {
            lastLaidOutPageWidth = pageWidth
            let page = min(pageControl.currentPage, count - 1)
            scrollView.contentOffset = CGPoint(x: CGFloat(page) * pageWidth, y: 0)
        }
    }

    private func clearPages() {
        contentView.subviews.forEach { $0.removeFromSuperview() }
    }

    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubview(pageControl)
    }

    private func addConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-12)
        }
    }

    private func updatePageControl(for offsetX: CGFloat) {
        let width = scrollView.bounds.width
        guard width > 0, !models.isEmpty else { return }
        let page = Int(round(offsetX / width))
        pageControl.currentPage = min(max(page, 0), models.count - 1)
    }
}

extension SuccessCarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageControl(for: scrollView.contentOffset.x)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl(for: scrollView.contentOffset.x)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageControl(for: scrollView.contentOffset.x)
    }
}
