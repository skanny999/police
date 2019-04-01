//
//  ClusterAnnotationView.swift
//  Police
//
//  Created by Riccardo on 18/03/2019.
//  Copyright © 2019 RiccardoScanavacca. All rights reserved.
//

import UIKit
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -10)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()

        if let cluster = annotation as? MKClusterAnnotation {

            if cluster.memberAnnotations is [Annotable] {
                
                image = drawRation(for: cluster.memberAnnotations as! [Annotable])
            }
        }
    }
    
    fileprivate func addBorderTo(_ piePath: UIBezierPath) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = piePath.cgPath // Reuse the Bezier path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.lineWidth = 0.5
        borderLayer.frame = self.bounds
        self.layer.addSublayer(borderLayer)
    }
    
    private func drawRation(for annotations: [Annotable]) -> UIImage {
        
        let groupedAnnotations = grouped(annotations)
        let render = UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40))
        return render.image { _ in
            
            let mainColour = groupedAnnotations.first?.first?.colour ?? .red
            mainColour.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40)).fill()
            
            var quantities = groupedAnnotations.map { $0.count }
            var proportions: [Int] = []
            while quantities.count > 0 {
                proportions.append(quantities.reduce(0, +))
                quantities.remove(at: 0)
            }
            
            for (index, proportion) in proportions.enumerated() {
                
                let colour = groupedAnnotations[index].first?.colour ?? .red
                let whole = proportions.first!
                colour.setFill()
                let piePath = UIBezierPath()
                piePath.addArc(withCenter: CGPoint(x: 20, y: 20), radius: 20,
                               startAngle: 0, endAngle: (CGFloat.pi * 2.0 * CGFloat(proportion)) / CGFloat(whole),
                               clockwise: true)
                addBorderTo(piePath)
                piePath.addLine(to: CGPoint(x: 20, y: 20))
                piePath.close()
                piePath.fill()
            }


            UIColor(red: 200/255, green: 220/255, blue: 1, alpha: 1).setFill()
            let centrepath = UIBezierPath(ovalIn: CGRect(x: 8, y: 8, width: 24, height: 24))
            addBorderTo(centrepath)
            centrepath.fill()
            
            
            // Finally draw count text vertically and horizontally centered
            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.black,
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
            let text = "\(proportions.first!)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 20 - size.width / 2, y: 20 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)

        }
    }
    
    
    private func grouped(_ annotation: [Annotable]) -> [[Annotable]] {
        
        let grouped = Dictionary(grouping: annotation, by: { $0.colour })
        var array: [[Annotable]] = []
        for group in grouped {
            array.append(group.value)
        }
        return array.sorted {$0.count > $1.count} as [[Annotable]]
    }

}
