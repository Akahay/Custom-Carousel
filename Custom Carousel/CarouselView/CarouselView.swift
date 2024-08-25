//
//  CarouselView.swift
//  Custom Carousel
//
//  Created by Akshay Naithani on 22/08/24.
//

import UIKit

enum Position {
    case prev
    case curr
    case next
}

class CarouselView: UIView {
    
    @IBOutlet private weak var mainView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var stackView: UIStackView!
            
    private var direction: Position = .prev
    private let maxScale: CGFloat = 1
    private let minScale: CGFloat = 0.8
    var prevCurrentIndex: Int?
    var currentIndex: Int = 1
    
    var offsetX: CGFloat {
        get {
            scrollView.contentOffset.x
        }
        set(newValue) {
            scrollView.contentOffset.x = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        
        loadView()
        guard let mainView else { return }
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(mainView)
        scrollView.delegate = self
        scrollView.decelerationRate = .fast
        scrollView.isPagingEnabled = true
    }

    func configure(with images: [UIImage]) {
        
        for (index, image) in images.enumerated() {
            let imageBGView = ImageBackgroundView(frame: .zero)
            imageBGView.set(bgColor: index % 2 == 0 ? .red : .blue, image: image)
            stackView.addArrangedSubview(imageBGView)
            
            imageBGView.translatesAutoresizingMaskIntoConstraints = false
            imageBGView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
            imageBGView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        }
        
        alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setInitialContentOffset()
            self?.alpha = 1
        }
    }
    
    private func setInitialContentOffset() {
        let width = bounds.width / 2
        guard let views = stackView.arrangedSubviews as? [ImageBackgroundView] else { return }
        views.forEach { $0.set(centerX: width) }
        scrollView.contentOffset.x = views[currentIndex].frame.origin.x
    }
    
    
    private func getCenterX() -> CGFloat {
        scrollView.contentOffset.x + center.x
    }

    private func updateZoomEffect() {
        
        guard let arrangedSubviews = stackView.arrangedSubviews as? [ImageBackgroundView] else { return }
        
        let listCenterX = arrangedSubviews.map { $0.center.x }
        
        var minDiff: CGFloat = .greatestFiniteMagnitude
        let scrolledX = scrollView.contentOffset.x
        let scrolledCenterX = scrolledX + center.x
        
        for (index,itemCenterX) in listCenterX.enumerated() {
            let diff = scrolledCenterX > itemCenterX ? scrolledCenterX - itemCenterX : itemCenterX - scrolledCenterX
            if diff < minDiff {
                currentIndex = index
                minDiff = diff
            }
        }
        
        set(position: .prev, index: currentIndex-1, minDiff: minDiff)
        set(position: .curr, index: currentIndex, minDiff: minDiff)
        set(position: .next, index: currentIndex+1, minDiff: minDiff)
    }
    
    private func getImageBackgroundView(for index: Int) -> ImageBackgroundView? {
        guard index >= 0 && index < stackView.arrangedSubviews.count else { return nil }
        return stackView.arrangedSubviews[index] as? ImageBackgroundView
    }
    
    private func set(position: Position, index: Int, minDiff: CGFloat) {
        
        guard let imageContainerView = getImageBackgroundView(for: index) else { return }
                
        let zPosition: CGFloat
        let scale: CGFloat
        let centerX: CGFloat
        
        switch position {
        case .prev:
            zPosition = 10
            scale = minScale
            centerX = 0.5 * bounds.width
        case .curr:
            zPosition = 100
            let halfWidth: CGFloat = imageContainerView.bounds.width / 2
            let ratio = (minDiff / halfWidth) * 2
            scale = max(minScale, min(maxScale, maxScale - ratio))
            centerX = 0
        case .next:
            zPosition = 10
            scale = minScale
            centerX = -0.5 * bounds.width
        }
        
        imageContainerView.set(centerX: centerX,
                               zPosition: zPosition,
                               imageTransformToScale: scale)
    }
}

extension CarouselView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateZoomEffect()
    }
    
}
