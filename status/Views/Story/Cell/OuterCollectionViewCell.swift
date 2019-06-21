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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        innerCollectionView.register(UINib(nibName: "InnerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "InnerCollectionViewCell")
    }

}

extension OuterCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InnerCollectionViewCell", for: indexPath) as! InnerCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/2-5, height: collectionView.frame.size.width/2-5)
    }
}











