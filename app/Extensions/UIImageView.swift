//
//  UIImageView.swift
//  IsisJungleRocks
//
//  Created by Andrio Frizon on 9/7/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

// To use this extension add pod 'Kingfisher'
// https://github.com/onevcat/Kingfisher
import Kingfisher

typealias ImageLoaded = (_ image: UIImage?) -> Void

protocol FetchImageTask {
    func cancel()
}

extension DownloadTask: FetchImageTask {}

extension UIImageView {
    @discardableResult
    func loadImage(fromUrl url: String?,
                   withParams params: LoadImageParams = LoadImageParams(),
                   completion: ImageLoaded? = nil) -> FetchImageTask? {
        guard let url = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let imageUrl = URL(string: url)
            else {
                resetImage(with: params)
                return nil
        }
        setupImageView(with: params)
        let cornerProcessor = RoundCornerImageProcessor(cornerRadius: params.cornerRadius)
        let scale = UIScreen.main.scale
        let resizeProcessor = ResizingImageProcessor(
            referenceSize: CGSize(width: frame.size.width * scale, height: frame.size.height * scale),
            mode: .aspectFill
        )
        let combinedProcessors = resizeProcessor |> cornerProcessor
        let processor: ImageProcessor = params.resizeBeforeCaching ? combinedProcessors : cornerProcessor
        self.kf.indicatorType = params.showActivityIndicator ? .activity : .none
        if let activityIndicatorColor = params.activityIndicatorColor {
            (self.kf.indicator?.view as? UIActivityIndicatorView)?.color = activityIndicatorColor
        }
        var options: KingfisherOptionsInfo = [.processor(processor)]
        if params.forceRefresh {
            options.append(.forceRefresh)
        }
        let task = kf.setImage(
            with: imageUrl,
            placeholder: params.placeholder,
            options: options,
            progressBlock: { (receivedSize, totalSize) in
                if receivedSize == totalSize {
                    self.contentMode = params.contentMode
                    self.image = nil
                }
        }, completionHandler: { (image, _, _, _) in //(image, error, cacheType, url)
            if let image = image {
                self.contentMode = params.contentMode
                self.image = image
            }
            self.isUserInteractionEnabled = true
            completion?(image)
        })
        return task
    }

    // MARK: - Private methods

    private func setupImageView(with params: LoadImageParams) {
        layer.masksToBounds = true
        contentMode = params.placeholderContentMode
        image = params.placeholder
        isUserInteractionEnabled = false
        backgroundColor = params.backgroundColor
    }

    private func resetImage(with params: LoadImageParams) {
        contentMode = params.placeholderContentMode
        image = params.placeholder
        backgroundColor = params.backgroundColor
    }
}

struct LoadImageParams {
    var backgroundColor: UIColor = .lightGray
    var placeholder: UIImage?
    var placeholderContentMode: UIView.ContentMode = .scaleAspectFill
    var contentMode: UIView.ContentMode = .scaleAspectFill
    var showActivityIndicator: Bool = true
    var activityIndicatorColor: UIColor?
    var cornerRadius: CGFloat = 0
    var forceRefresh: Bool = false
    var resizeBeforeCaching: Bool = false
}
