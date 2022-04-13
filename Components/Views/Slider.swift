//
//  Slider.swift
//  
//
//  Created by Maxamilian Litteral on 9/16/20.
//

import Foundation

#if canImport(UIKit)
import UIKit

public class Slider: UISlider {

    private enum Constants {
        static let trackHeight: CGFloat = 6
        static let thumbSize: CGFloat = 12
    }

    // MARK: - Properties

    weak var delegate: StepSliderDelegate?

    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = 2 * Constants.thumbSize
        return size
    }

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(minValue:maxValue:initialValue:) instead")
    }

    public init(minValue: Float, maxValue: Float, initialValue: Float) {
        super.init(frame: .zero)

        self.minimumValue = minValue
        self.maximumValue = maxValue
        self.value = initialValue
        self.minimumTrackTintColor = UIColor.SS.Slate.base
        self.maximumTrackTintColor = UIColor.SS.Grey.basic

        setThumbImage(UIImage.colored(UIColor.SS.Slate.base, cornerRadius: 0.5 * Constants.thumbSize), for: .normal)
    }

    // MARK: - Overrides

    override public func trackRect(forBounds bounds: CGRect) -> CGRect {
        let superTrackRect = super.trackRect(forBounds: bounds)
        return CGRect(
            x: superTrackRect.origin.x,
            y: bounds.midY - 0.5 * Constants.trackHeight,
            width: superTrackRect.size.width,
            height: Constants.trackHeight
        )
    }

}

#endif
