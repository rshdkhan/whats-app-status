//
//  OuterCollectionViewCell.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import UIKit

class OuterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var innerCollectionView: UICollectionView!
    weak var weakParent: StoryViewController?
    var story: StoryHandler!
    var storyBar: StoryBar!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        innerCollectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCollectionViewCell")
    }
    
    func setStory(story: StoryHandler) {
        self.story = story
        self.contentView.layoutIfNeeded()
        addStoryBar()
        innerCollectionView.reloadData()
        innerCollectionView.scrollToItem(at: IndexPath(item: story.storyIndex, section: 0),
                                     at: .centeredHorizontally, animated: false)
    }
    
    private func addStoryBar() {
        if let _ = storyBar {
            storyBar.removeFromSuperview()
            storyBar = nil
        }
        
        storyBar = StoryBar(numberOfSegments: story.images.count)
        storyBar.frame = CGRect(x: 15, y: 15, width: weakParent!.view.frame.width - 30, height: 4)
        storyBar.delegate = self
        storyBar.animatingBarColor = UIColor.white
        storyBar.nonAnimatingBarColor = UIColor.white.withAlphaComponent(0.25)
        storyBar.padding = 2
        storyBar.resetSegmentsTill(index: story.storyIndex)
        self.contentView.addSubview(storyBar)
    }

}


// collection view datasource and delegate
extension OuterCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return story.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCollectionViewCell", for: indexPath) as! InnerCollectionViewCell
        
        cell.setImage(story.images[indexPath.row])
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
}

// MARK:- Segmented ProgressBar Delegate
extension OuterCollectionViewCell: SegmentedProgressBarDelegate {
    
    func segmentedProgressBarChangedIndex(index: Int) {
        weakParent?.currentStoryIndexChanged(index: index)
        innerCollectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                     at: .centeredHorizontally, animated: false)
    }
    
    func segmentedProgressBarReachEnd() {
        weakParent?.showNextUserStory()
    }
    
    func segmentedProgressBarReachPrevious() {
        weakParent?.showPreviousUserStory()
    }
}

// MARK:- Segmented ProgressBar Delegate
extension OuterCollectionViewCell: ImageZoomDelegate {
    
    func imageZoomStart() {
        storyBar.pause()
    }
    
    func imageZoomEnd() {
        storyBar.resume()
    }
}












