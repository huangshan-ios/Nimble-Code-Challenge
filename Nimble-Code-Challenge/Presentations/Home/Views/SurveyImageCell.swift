//
//  SurveyImageCell.swift
//  Nimble-Code-Challenge
//
//  Created by Son Hoang on 30/06/2022.
//

import UIKit
import Nuke

class SurveyImageCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    func setImage(_ url: String) {        
        guard
            let originalImageUrl = URL(string: url),
            let highQualityImageUrl = originalImageUrl.toHighQualityImageURL()
        else {
            return
        }
        
        loadImage(originalUrl: originalImageUrl,
                  highQualityUrl: highQualityImageUrl)
    }
    
    private func loadImage(originalUrl: URL, highQualityUrl: URL) {
        Nuke.loadImage(with: createImageRequest(with: highQualityUrl),
                       into: backgroundImage,
                       completion: { [weak self] result in
            guard let self = self, case .failure = result else {
                return
            }
            Nuke.loadImage(with: self.createImageRequest(with: originalUrl),
                           into: self.backgroundImage)
        })
    }
    
    private func createImageRequest(with url: URL) -> ImageRequest {
        return ImageRequest(
            url: url,
            processors: [ImageProcessors.Resize(size: UIScreen.main.bounds.size,
                                                contentMode: .aspectFill,
                                                crop: true, upscale: true)],
            priority: .high
        )
    }
}
