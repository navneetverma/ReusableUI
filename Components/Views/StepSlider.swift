//
//  StepSlider.swift
//  
//
//  Created by Maxamilian Litteral on 2/7/20.
//

#if canImport(UIKit)
import UIKit

protocol StepSliderDelegate: AnyObject {
    func slider(didSelect index: Int)
}

/// Slider with incremental values based on https://stackoverflow.com/questions/8219056/uislider-that-snaps-to-a-fixed-number-of-steps-like-text-size-in-the-ios-7-sett
/// Slider aligned to labels based on https://gist.github.com/jmcd/2499a901136df6f5c327216b27e4e6d4 / https://stackoverflow.com/questions/49309402/placing-labels-above-uislider-using-uistackview
public final class StepSlider: Slider {

    // MARK: - Properties

    private let values: [SliderOptionConvertible]
    private var lastIndex: Int? = nil

    // MARK: - Lifecycle

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(value:options:) instead")
    }

    public init(value: @escaping SliderValue, options: [SliderOptionConvertible]) {
        self.values = options
        super.init(minValue: 0, maxValue: Float(values.count - 1), initialValue: Float(value()))
        self.addTarget(self, action: #selector(handleValueChange(sender:)), for: .valueChanged)
    }

    // MARK: - Actions

    @objc func handleValueChange(sender: UISlider) {
        let newIndex = Int(sender.value + 0.5) // round up to next index
        self.setValue(Float(newIndex), animated: false) // snap to increments
        let didChange = lastIndex == nil || newIndex != lastIndex
        if didChange {
            lastIndex = newIndex
            delegate?.slider(didSelect: newIndex)
        }
    }

}

#endif
