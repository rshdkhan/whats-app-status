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
    var rowIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        outerCollectionView.delegate = self
        outerCollectionView.dataSource = self
        
        outerCollectionView.register(UINib(nibName: "OuterCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OuterCollectionViewCell")
        
    }
}


extension StoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OuterCollectionViewCell", for: indexPath) as! OuterCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    
}
