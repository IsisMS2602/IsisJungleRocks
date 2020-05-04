//
//  CircularView.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/28/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import Foundation
import UIKit

class CircularProgressView: UIView {
    var begininPoint: CGFloat = 0
    var endPoint: CGFloat = 25
    var percentagePoint: CGFloat = (2 * .pi)/100
    let colors = [UIColor.systemPink.cgColor, UIColor(red: 51/255, green: 127/255, blue: 1, alpha: 1).cgColor, UIColor.yellow.cgColor, UIColor.orange.cgColor]
    var layers: [CAShapeLayer] = []
    private var circle = CAShapeLayer()
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var someOtherLayer = CAShapeLayer()
    private var yellowLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layers.append(circle)
        layers.append(circleLayer)
        layers.append(progressLayer)
        layers.append(someOtherLayer)
        for i in 0...3 {
            createCircularPath(layers: layers[i], start: begininPoint, end: percentagePoint * endPoint, color: colors[i])
            begininPoint = percentagePoint * endPoint
            endPoint += 25
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createCircularPath(layers: CAShapeLayer, start: CGFloat, end: CGFloat, color: CGColor) {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: 72, startAngle: start, endAngle:  end, clockwise: true)
        layers.path = circularPath.cgPath
        layers.fillColor = UIColor.clear.cgColor
        layers.lineCap = .butt
        layers.lineWidth = 8
        layers.strokeColor = color
        layer.addSublayer(layers)
    }
}
