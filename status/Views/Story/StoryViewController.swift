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
    
    var tapGest: UITapGestureRecognizer!
    var longPressGest: UILongPressGestureRecognizer!
    var panGest: UIPanGestureRecognizer!
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        
        outerCollectionView.delegate = self
        outerCollectionView.dataSource = self
        
        outerCollectionView.isScrollEnabled = false
        
        outerCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCollectionViewCell")
        
        prepareOuterData()
        addGesture()
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
        self.view.layoutIfNeeded()
        
        outerCollectionView.scrollToItem(at: IndexPath(item: StoryHandler.userIndex, section: 0), at: .centeredHorizontally, animated: false)
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
        removeGestures()
        let indexPath = IndexPath(item: StoryHandler.userIndex, section: 0)
        outerCollectionView.reloadItems(at: [indexPath])
        outerCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let storyBar = self.getCurrentStory() {
                storyBar.animate(animationIndex: self.arrUser[StoryHandler.userIndex].storyIndex)
                self.addGesture()
            }
        }
    }
    
    func getCurrentStory() -> StoryBar? {
        let cell = outerCollectionView.cellForItem(at: IndexPath(item: StoryHandler.userIndex, section: 0))
        print("cell >>", cell)
        if let cell = outerCollectionView.cellForItem(at: IndexPath(item: StoryHandler.userIndex, section: 0)) as? OuterCollectionViewCell {
            return cell.storyBar
        }
        
//        let cell11 = outerCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [], animated: false)
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

// Gestures
extension StoryViewController {
    
    func addGesture() {
        
        // for previous and next navigation
        tapGest = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGest)
        
        longPressGest = UILongPressGestureRecognizer(target: self,
                                                     action: #selector(panGestureRecognizerHandler))
        longPressGest.minimumPressDuration = 0.2
        self.view.addGestureRecognizer(longPressGest)
        
        
        /*
         swipe down to dismiss
         NOTE: Self's presentation style should be "Over Current Context"
         */
        panGest = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerHandler))
        self.view.addGestureRecognizer(panGest)
    }
    
    func removeGestures() {
        self.view.removeGestureRecognizer(tapGest)
        self.view.removeGestureRecognizer(longPressGest)
        self.view.removeGestureRecognizer(panGest)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let touchLocation: CGPoint = gesture.location(in: gesture.view)
        let maxLeftSide = ((view.bounds.maxX * 40) / 100) // Get 40% of Left side
        if let storyBar = getCurrentStory() {
            if touchLocation.x < maxLeftSide {
                storyBar.previous()
            } else {
                storyBar.next()
            }
        }
    }
    
    @objc func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        guard let storyBar = getCurrentStory() else { return }
        
        let touchPoint = sender.location(in: self.view?.window)
        if sender.state == .began {
            storyBar.pause()
            initialTouchPoint = touchPoint
        } else if sender.state == .changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: max(0, touchPoint.y - initialTouchPoint.y),
                                         width: self.view.frame.size.width,
                                         height: self.view.frame.size.height)
            }
        } else if sender.state == .ended || sender.state == .cancelled {
            if touchPoint.y - initialTouchPoint.y > 200 {
                dismiss(animated: true, completion: nil)
            } else {
                storyBar.resume()
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0,
                                             width: self.view.frame.size.width,
                                             height: self.view.frame.size.height)
                })
            }
        }
    }
}

extension StoryViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let storyBar = getCurrentStory() {
            storyBar.pause()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let lastIndex = StoryHandler.userIndex
        let pageWidth = outerCollectionView.frame.size.width
        let pageNo = Int(floor(((outerCollectionView.contentOffset.x + pageWidth / 2) / pageWidth)))
        
        if lastIndex != pageNo {
            StoryHandler.userIndex = pageNo
            showUpcomingUserStory()
        } else {
            if let storyBar = getCurrentStory() {
                self.addGesture()
                storyBar.resume()
            }
        }
    }
}


