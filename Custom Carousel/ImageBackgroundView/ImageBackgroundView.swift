//
//  ImageBackgroundView.swift
//  Custom Carousel
//
//  Created by Akshay Naithani on 24/08/24.
//

import UIKit

class ImageBackgroundView: UIView {

    @IBOutlet private var mainView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet weak var xCenterConstraint: NSLayoutConstraint!
    
    var imageTransformToScale: CGFloat = 1 {
        didSet {
            guard oldValue != imageTransformToScale else { return }
            containerView.transform = CGAffineTransform(scaleX: imageTransformToScale, y: imageTransformToScale)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        loadView()
        guard let mainView else { return }
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(mainView)
        let cornerRadius: CGFloat = 24
        layer.cornerRadius = cornerRadius
        bgView.layer.cornerRadius = cornerRadius
//        set(centerX: center.x)
        set(centerX: 0)
    }
    
    func set(bgColor: UIColor, image: UIImage?) {
        bgView.backgroundColor = bgColor
        imageView.image = image
    }
    
    func set(centerX: CGFloat) {
//        containerView.center.x = centerX
        xCenterConstraint.constant = centerX
    }
    
    func set(centerX: CGFloat,
             zPosition: CGFloat,
             imageTransformToScale: CGFloat) {
        self.set(centerX: centerX)
        self.layer.zPosition = zPosition
        self.imageTransformToScale = imageTransformToScale
    }
}
