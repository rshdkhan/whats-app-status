//
//  InnerCollectionViewCell.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import UIKit

protocol ImageZoomDelegate: class {
    func imageZoomStart()
    func imageZoomEnd()
}

class InnerCollectionViewCell: UICollectionViewCell {

    weak var delegate: ImageZoomDelegate?
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgStory: UIImageView!
    
    private var isImageDragged:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scrollView.maximumZoomScale = 3.0;
        scrollView.minimumZoomScale = 1.0;
        scrollView.clipsToBounds = true;
        scrollView.delegate = self
        scrollView.addSubview(imgStory)
    }

}

// MARK:- Helper Methods
extension InnerCollectionViewCell {
    
    func setImage(_ image: UIImage) {
        imgStory.image = image
        isImageDragged = false
        setContentMode()
    }
    
    private func setContentMode() {
        if imgStory.image!.imageOrientation == .up {
            imgStory.contentMode = .scaleAspectFit
        } else if imgStory.image!.imageOrientation == .left || imgStory.image!.imageOrientation == .right {
            imgStory.contentMode = .scaleAspectFill
        }
    }
    
    private func resetImage() {
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.zoomScale = 1.0
        }) { [weak self] (isAnimationDone) in
            if isAnimationDone {
                self?.delegate?.imageZoomEnd()
                self?.isImageDragged = false
            }
        }
    }
}


//Scroll View Delegate
extension InnerCollectionViewCell: UIScrollViewDelegate {
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        delegate?.imageZoomStart()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isImageDragged = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgStory
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if !isImageDragged {
            resetImage()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        resetImage()
    }
}
