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
    var endPoint: CGFloat = 18
    var percentagePoint: CGFloat = (2 * .pi)/100
    let colors = [
        UIColor(red: 51/255, green: 127/255, blue: 1, alpha: 1).cgColor,
        UIColor.yellow.cgColor,
        UIColor.green.cgColor,
        UIColor.orange.cgColor,
        UIColor.gray.cgColor]
    private var baseLayer = CAShapeLayer()
    private var circle1 = CAShapeLayer()
    private var circle2 = CAShapeLayer()
    private var circle3 = CAShapeLayer()
    private var circle4 = CAShapeLayer()
    private var circle5 = CAShapeLayer()
    private var circle6 = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func createCircularPath(start: CGFloat, end: CGFloat, color: CGColor) {
        let newLayer = CAShapeLayer()
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2),
            radius: 72,
            startAngle: start,
            endAngle: end,
            clockwise: true
         )
        newLayer.path = circularPath.cgPath
        newLayer.fillColor = UIColor.clear.cgColor
        newLayer.lineCap = .butt
        newLayer.lineWidth = 8
        newLayer.strokeColor = color
        layer.addSublayer(newLayer)
    }
    func calculateCircle(layerBaseInfoArray: [(UIColor, Int)]) {
       // layer.sublayers?.removeAll()
        guard !layerBaseInfoArray.isEmpty else {
            createCircularPath(start: 0, end: 2 * .pi, color: UIColor.systemPink.cgColor)
            return
        }
        var totalOfHouers = 0
        for index in 0 ... layerBaseInfoArray.count - 1 {
         totalOfHouers += layerBaseInfoArray[index].1
        }
        for index in 0 ... layerBaseInfoArray.count - 1 {
            createCircularPath(start: generateBeginingPoint(value: endPoint), end: generateEndPoints(value: ((.pi * 2) * CGFloat(calc(number: layerBaseInfoArray[index].1, total: totalOfHouers)) / 100)), color: layerBaseInfoArray[index].0.cgColor)
        }
    }
    func calc(number: Int, total: Int) -> Int {
        let result = (number * 100) / total
        return result
    }
    func generateEndPoints(value: CGFloat) -> CGFloat {
        endPoint += (value + 0.2 )
        return endPoint
    }
    func  generateBeginingPoint(value: CGFloat) -> CGFloat {
        begininPoint = value
        return begininPoint
    }
}
