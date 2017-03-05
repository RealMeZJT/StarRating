//
//  StarRating.swift
//  StarRating
//
//  Created by ZhouJiatao on 19/12/2016.
//  Copyright © 2016 ZJT. All rights reserved.
//

import UIKit

protocol StarRatingDelegate {
    func starRatingView(_ starRatingView:StarRatingView, didRated numberOfStar:Float)
}

///评分控件(✨星星)
class StarRatingView: UIView {
    
    struct Contants {
        static let defaultDarkStarImageName = "dark_star"
        static let defaultBrightStarImageName = "bright_star"
        static let darkStarTag:Int = 1
        static let brightStarTag:Int = 2
    }
    
    var darkStarImageName: String = Contants.defaultDarkStarImageName
    var brightStarImageName: String = Contants.defaultBrightStarImageName
    
    var starBgColor:UIColor = UIColor.white
    var starCount:Int = 5
    var numberOfBrightStar:Float = 0 {
        didSet {
            delegate?.starRatingView(self, didRated: numberOfBrightStar)
            brightStars()
        }
    }
    var delegate:StarRatingDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private var darkStarViews: [UIImageView] = []
    private var brightStarViews: [UIImageView] = []
    private func setup() {
        //add views
        for _ in 0..<starCount {
            
            let brightStarImageView = createBrightStarImageView()
            brightStarViews.append(brightStarImageView)
            addSubview(brightStarImageView)
            
            let darkStarImageView = createDarkStarImageView()
            darkStarViews.append(darkStarImageView)
            addSubview(darkStarImageView)
            
        }
        
    }
    
    override func layoutSubviews() {
        let starViewHeight:CGFloat = bounds.height
        //starView的尺寸是：星星图片宽度和当前view高度，两者取其中小的一个
        let starViewWidth = min(starViewHeight,starImageSize().width)
        
        let leftMargin = (bounds.size.width / CGFloat(starCount) - starViewWidth) / CGFloat(2)
        
        
        for i in 0..<starCount {
            let starX =  (leftMargin + starViewWidth + leftMargin) * CGFloat(i)
            brightStarViews[i].frame = CGRect(x:starX,
                                              y: 0,
                                              width: starViewWidth,
                                              height: starViewHeight)
            darkStarViews[i].frame = brightStarViews[i].frame
        }
    }
    
    private func createBrightStarImageView() -> UIImageView {
        let brightStarImage = UIImage(named: brightStarImageName)!
        let brightStarImageView = UIImageView(image: brightStarImage)
        brightStarImageView.contentMode = .scaleAspectFit
        brightStarImageView.tag = Contants.brightStarTag
        return brightStarImageView
    }
    
    private func createDarkStarImageView() -> UIImageView {
        let darkStarImage = UIImage(named: darkStarImageName)!
        let darkStarImageView = UIImageView(image: darkStarImage)
        darkStarImageView.tag = Contants.darkStarTag
        darkStarImageView.contentMode = .scaleAspectFit
        darkStarImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapDarkStar(_:)))
        darkStarImageView.addGestureRecognizer(tapGesture)
        
        return darkStarImageView
    }
    
    private func starImageSize() -> CGSize {
        return UIImage(named: darkStarImageName)!.size
    }
    
    func tapDarkStar(_ gesture: UIGestureRecognizer) {
        if let tapView = gesture.view as? UIImageView {
            let index = darkStarViews.index(of: tapView)!
            let numberOfStarSouldBright = index + 1
            self.numberOfBrightStar = Float(numberOfStarSouldBright)
        }
        
    }
    
    private func brightStars() {
        spitOutAllDarkView()
        
        let fullStarNumber = Int(numberOfBrightStar)
        for i in 0..<fullStarNumber {
            bite(darkStarViews[i], rate: 1.0)
        }
        
        let unfilledStarIndex = fullStarNumber
        if unfilledStarIndex < darkStarViews.count {
            let unfilledStarRate:Float = numberOfBrightStar - Float(fullStarNumber)
            bite(darkStarViews[unfilledStarIndex], rate: unfilledStarRate)
        }
        
    }
    
    //bite from right to left
    private func bite(_ view:UIView ,rate:Float) {
        let biteWidth = view.bounds.width * CGFloat(rate)
        let remainingWidth = view.bounds.width - biteWidth
        let remainingX = view.bounds.width - remainingWidth
        let remainingHeight = view.bounds.height
        let remainingPath = UIBezierPath(rect: CGRect(x: remainingX,
                                                      y: 0,
                                                      width: remainingWidth,
                                                      height: remainingHeight))
        
        let remainingMask = CAShapeLayer()
        remainingMask.frame = view.bounds
        remainingMask.path = remainingPath.cgPath
        
        view.layer.mask = remainingMask
    }
    
    private func spitOutAllDarkView() {
        for v in darkStarViews {
            spitOut(v)
        }
    }
    
    private func spitOut(_ view:UIView) {
        view.layer.mask = nil
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
