//
//  StoryViewController.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import UIKit

class StoryViewController: UIViewController {
    @IBOutlet weak var outerCollectionView: UICollectionView!
    
    var imageCollection: [[UIImage]]!
    var arrUser = [StoryHandler]()
    var rowIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outerCollectionView.delegate = self
        outerCollectionView.dataSource = self
        
        outerCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCollectionViewCell")
        
        prepareOuterData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let storyBar = getCurrentStory() {
            storyBar.startAnimation()
        }
    }

    @IBAction func cancelBtnTap(_ sender: Any) {
        self.dismiss()
    }
}

//Helper methods
extension StoryViewController {
    func prepareOuterData() {
        for collection in imageCollection {
            arrUser.append(StoryHandler(imgs: collection))
        }
        StoryHandler.userIndex = rowIndex
        outerCollectionView.reloadData()
    }
    
    func currentStoryIndexChanged(index: Int) {
        arrUser[StoryHandler.userIndex].storyIndex = index
    }
    
    func showNextUserStory() {
        let newUserIndex = StoryHandler.userIndex + 1
        if newUserIndex < arrUser.count {
            StoryHandler.userIndex = newUserIndex
            showUpcomingUserStory()
        } else {
            dismiss()
        }
    }
    
    func showPreviousUserStory() {
        let newIndex = StoryHandler.userIndex - 1
        if newIndex >= 0 {
            StoryHandler.userIndex = newIndex
            showUpcomingUserStory()
        } else {
            dismiss()
        }
    }
    
    func showUpcomingUserStory() {
//        removeGestures()
        let indexPath = IndexPath(item: StoryHandler.userIndex, section: 0)
        outerCollectionView.reloadItems(at: [indexPath])
        outerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let storyBar = self.getCurrentStory() {
                storyBar.animate(animationIndex: self.arrUser[StoryHandler.userIndex].storyIndex)
//                self.addGesture()
            }
        }
    }
    
    func getCurrentStory() -> StoryBar? {
        if let cell = outerCollectionView.cellForItem(at: IndexPath(item: StoryHandler.userIndex, section: 0)) as? OuterCollectionViewCell {
            return cell.storyBar
        }
        return nil
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
}


//outer collection view datasource and delegate
extension StoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OuterCollectionViewCell", for: indexPath) as! OuterCollectionViewCell
        
        cell.weakParent = self
        cell.setStory(story: arrUser[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
}
