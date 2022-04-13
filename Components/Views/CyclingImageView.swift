//
//  CyclingImageView.swift
//  
//
//  Created by Rob Visentin on 1/22/21.
//

#if canImport(UIKit)
import UIKit

public class CyclingImageView: UIControl {

    public enum ImageReference {
        case local(UIImage)
        case remote(URL)
    }

    private enum ImageState {
        case loaded(UIImage?)
        case loading
        case error(Error)
    }

    // MARK: - Properties

    public var images: [ImageReference] {
        didSet {
            reload()
        }
    }

    public var currentImage: ImageReference? {
        if images.indices.contains(currentIndex) {
            return images[currentIndex]
        }
        return nil
    }

    public override var contentMode: UIView.ContentMode {
        get {
            return imageView.contentMode
        }
        set {
            imageView.contentMode = newValue
        }
    }

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = UIColor.SS.Slate.base
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private let tapIcon: UIView = {
        let tapIcon = UIImageView(image: UIImage(named: "FingerIcon", in: .module, compatibleWith: nil))
        tapIcon.translatesAutoresizingMaskIntoConstraints = false
        return tapIcon
    }()

    private var imageStates = [ImageState]()
    private var imageTasks = [URLSessionDataTask?]()

    private var currentIndex = 0 {
        didSet {
            if currentIndex != oldValue {
                sendActions(for: .valueChanged)
            }
        }
    }

    // MARK: - Lifecycle

    public init(images: [ImageReference] = []) {
        self.images = images

        super.init(frame: .zero)

        setup()
        reload()
    }

    public required init?(coder aDecoder: NSCoder) {
        images = []

        super.init(coder: aDecoder)

        setup()
        reload()
    }

    // MARK: - Actions

    @objc public func reset() {
        guard !images.isEmpty else { return }

        currentIndex = 0
        show(imageState: imageStates[currentIndex])
    }

    @objc public func advance() {
        guard !images.isEmpty else { return }

        currentIndex = (currentIndex + 1) % images.count
        show(imageState: imageStates[currentIndex])
    }

    private func reload() {
        imageStates = images.map {
            switch $0 {
            case .local(let image):
                return .loaded(image)
            case .remote:
                return .loading
            }
        }
        imageTasks = images.map(load)
        tapIcon.isHidden = images.count < 2

        reset()
    }

    private func show(imageState: ImageState) {
        switch imageState {
        case .loaded(let image):
            activityIndicator.stopAnimating()
            imageView.image = image
        case .loading:
            activityIndicator.startAnimating()
            imageView.image = nil
        case .error:
            // Implement error state design here if needed
            activityIndicator.stopAnimating()
            imageView.image = nil
        }
    }

    private func load(image: ImageReference) -> URLSessionDataTask? {
        switch image {
        case .local:
            return nil
        case .remote(let url):
            var task: URLSessionDataTask!
            task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                self?.finish(task: task, data: data, error: error)
            }
            task.resume()
            return task
        }
    }

    private func finish(task: URLSessionDataTask, data: Data?, error: Error?) {
        let result: ImageState

        if let error = error {
            result = .error(error)
        } else {
            result = .loaded(data.flatMap { UIImage(data: $0, scale: UIScreen.main.scale) })
        }

        DispatchQueue.main.async {
            guard let index = self.imageTasks.firstIndex(of: task) else { return }

            self.imageStates[index] = result
            self.imageTasks[index] = nil

            if index == self.currentIndex {
                self.show(imageState: result)
            }
        }
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .white

        addSubview(imageView)
        addSubview(activityIndicator)
        addSubview(tapIcon)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            tapIcon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            tapIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(advance))
        addGestureRecognizer(tapRecognizer)
    }

}

#endif
