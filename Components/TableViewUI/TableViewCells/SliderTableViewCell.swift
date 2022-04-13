//
//  SliderTableViewCell.swift
//  
//
//  Created by Maxamilian Litteral on 2/7/20.
//

#if canImport(UIKit)
import BonMot
import UIKit

/// Common type to set a localized or an attributed string
public enum StringType {
    case localized(String)
    case attributed(NSAttributedString)
}

/// Table view cell with detail text on the right
open class SliderTableViewCell: TableViewCell, StepSliderDelegate {

    // MARK: - Properties

    public var title: String? {
        didSet {
            titleLabel.styledText = title
        }
    }

    public var detailText: String? {
        didSet {
            detailLabel.styledText = detailText
        }
    }

    public var callback: SliderAction?

    private lazy var titleLabel = UILabel(style: .title2)

    private lazy var detailLabel: UILabel = {
        let label = UILabel(style: .body4)
        label.numberOfLines = 0
        return label
    }()

    private lazy var optionDescriptionLabel: UILabel = {
        let label = UILabel(style: .message1)
        label.numberOfLines = 0
        return label
    }()

    private lazy var optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 25),
            imageView.widthAnchor.constraint(equalToConstant: 25)
        ])

        return imageView
    }()

    private lazy var optionImageCaptionLabel = UILabel(style: .message1)

    private lazy var noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var noteLabel = UILabel(style: .message1)

    /// Contains optionImageView & sliderContainerStackView
    private lazy var imageAndSliderStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [optionImageView, sliderContainerStackView])
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    /// Contains fllexible leading space & optionDescriptionLabel
    private lazy var optionDescriptionStackView = UIStackView(arrangedSubviews: [.flexibleSpace(), optionDescriptionLabel])

    /// Contains imageAndSliderStackView & optionDescriptionLabel
    private lazy var sliderAndDescriptionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageAndSliderStackView, optionDescriptionStackView])
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    /// Contains StepSlider. UIStackView so we don't have to create constraints
    private let sliderContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    /// Contains noteImageView, noteLabel
    private lazy var noteStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [noteImageView, noteLabel])
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var options: [SliderOptionConvertible] = []

    // MARK: - Lifecycle

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        setup()
    }

    open override func prepareForReuse() {
        super.prepareForReuse()

        title = nil
        detailText = nil
        optionDescriptionLabel.text = nil
        optionImageView.image = nil
        optionImageCaptionLabel.text = nil
        callback = nil
        options = []
        noteImageView.image = nil
        noteLabel.text = nil
    }

    // MARK: - Actions

    func configure(value: @escaping SliderValue, options: [SliderOptionConvertible], callback: @escaping SliderAction) {
        self.callback = callback
        self.options = options

        let slider = StepSliderContainer(value: value, options: options)
        slider.delegate = self

        sliderContainerStackView.subviews.forEach { $0.removeFromSuperview() }
        sliderContainerStackView.addArrangedSubview(slider)

        displayOption(at: value())
    }

    private func displayOption(at index: Int) {
        let selectedOption = options[index]
        optionImageView.image = selectedOption.image
        optionDescriptionLabel.styledText = selectedOption.description
        optionImageCaptionLabel.styledText = selectedOption.imageCaption
        noteImageView.image = selectedOption.note?.image
        noteLabel.styledText = selectedOption.note?.text

        optionImageView.isHidden = selectedOption.image == nil
        optionDescriptionStackView.isHidden = optionImageView.isHidden
        optionImageCaptionLabel.isHidden = selectedOption.imageCaption == nil
        noteImageView.isHidden = noteImageView.image == nil
        noteStackView.isHidden = selectedOption.note == nil

        UIView.performWithoutAnimation {
            resizeIfNeeded()
        }
    }

    // MARK: StepSliderDelegate

    func slider(didSelect index: Int) {
        displayOption(at: index)
        callback?(index)
    }

    // MARK: Setup

    private func setup() {
        contentView.layoutMargins = UIEdgeInsets(xInset: 24, yInset: 14)

        let stackView = UIStackView(arrangedSubviews: [titleLabel, detailLabel, sliderAndDescriptionStackView, noteStackView])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.setCustomSpacing(4, after: titleLabel)
        stackView.setCustomSpacing(10, after: sliderAndDescriptionStackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)

        contentView.addSubview(optionImageCaptionLabel)

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            optionImageCaptionLabel.centerXAnchor.constraint(equalTo: optionImageView.centerXAnchor),
            optionImageCaptionLabel.topAnchor.constraint(equalTo: optionImageView.bottomAnchor, constant: 4),
            optionDescriptionLabel.leadingAnchor.constraint(equalTo: sliderContainerStackView.leadingAnchor),
            sliderAndDescriptionStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
        ])
    }
}

#endif

