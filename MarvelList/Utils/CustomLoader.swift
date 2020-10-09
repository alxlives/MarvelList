//
//  CustomLoader.swift
//  MarvelList
//
//  Created by MacDev on 09/10/20.
//  Copyright © 2020 Alexandre Abreu. All rights reserved.
//

import UIKit
import SnapKit
import Lottie

class CustomLoader: UIView {
    
    static var shared = CustomLoader()
    
    private var animationHolder: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 0.20, green: 0.56, blue: 0.86, alpha: 1.00)
        return view
    }()
    
    private var animationView: AnimationView = {
        let animationView = AnimationView.init(name: "hero-on-the-way")
        animationView.loopMode = .loop
        animationView.contentMode = .scaleAspectFill
        return animationView
    }()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationHolder.layer.cornerRadius = animationHolder.frame.size.width/2
    }
    
    private func openAnimation() {
        self.alpha = 0
        
        let currentWindow: UIWindow? = UIApplication.shared.keyWindow
        currentWindow?.addSubview(self)
        self.frame = currentWindow?.frame ?? CGRect()
        self.layoutIfNeeded()
        
        self.animationView.currentProgress = 0.0
        self.animationView.play()

        UIView.animate(withDuration: 0.3) {
            self.alpha = 1
        }
    }
    
    private func closeAnimation() {

        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    class func open() {
        shared.openAnimation()
    }
    
    class func close() {
        shared.closeAnimation()
    }
    
}

extension CustomLoader: ViewCodeProtocol {
    func setupHierarchy() {
         self.addSubview(animationHolder)
         animationHolder.addSubview(animationView)
    }
    
    func setupConstraints() {
        animationHolder.snp.makeConstraints { make in
            make.width.height.equalTo(300)
            make.centerX.centerY.equalToSuperview()
        }
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
         }
    }
    
    func aditionalSetup() {
        
    }
    
}
