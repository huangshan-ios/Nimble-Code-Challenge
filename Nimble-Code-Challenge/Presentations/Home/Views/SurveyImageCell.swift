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
        guard let url = URL(string: url) else {
            return
        }
        
        let request = ImageRequest(
            url: url,
            processors: [ImageProcessors.Resize(size: UIScreen.main.bounds.size,
                                                contentMode: .aspectFill,
                                                crop: true, upscale: true)],
            priority: .high
        )
        
        Nuke.loadImage(with: request, into: backgroundImage) { [weak self] result in
            guard
                let self = self,
                case let .success(response) = result
            else {
                return
            }
            let improveImage = response.image.resize(size: UIScreen.main.bounds.size)
            self.backgroundImage.image = improveImage
        }
    }

}
