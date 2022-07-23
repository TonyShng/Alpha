//
//  FPSLabel.swift
//  AlphaProject
//
//  Created by a on 2022/7/23.
//

import UIKit

class FPSLabel: UILabel {
    private var link: CADisplayLink?
    private var count: Int = 0
    private var lastTime: TimeInterval = 0
    private let defaultSize = CGSize(width: 55, height: 20)
    
    override init(frame: CGRect) {
        var targetFrame = frame
        if frame.size.width == 0 && frame.size.height == 0 {
            targetFrame.size = defaultSize
        }
        super.init(frame: targetFrame)
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.textAlignment = .center
        self.isUserInteractionEnabled = false
        self.textColor = .white
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)
        self.font = UIFont(name: "Menlo", size: 14)
        
        weak var weakSelf = self
        link = CADisplayLink(target: weakSelf!, selector: #selector(FPSLabel.tick(_:)))
        link!.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tick(_ link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        count += 1
        let delta = link.timestamp - lastTime
        if delta < 1 {
            return
        }
        lastTime = link.timestamp
        let fps = Double(count) / delta
        count = 0
        let progress = fps / 60.0
        self.textColor = UIColor(hue: CGFloat(0.27 * (progress - 0.2)), saturation: 1, brightness: 0.9, alpha: 1)
        self.text = "\(Int(fps + 0.5))FPS"
    }
}
