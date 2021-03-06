//
//  FunnyViewController.swift
//  DYLive
//
//  Created by 渠晓友 on 2017/5/7.
//  Copyright © 2017年 xiaoyouPrince. All rights reserved.
//

import UIKit

private let kTopMargin : CGFloat = 5

class FunnyViewController: BaceAnchorViewController {
    
    // MARK: - 懒加载
    fileprivate lazy var funnyVM : FunnyViewModel = FunnyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
        collectionView.contentInset = UIEdgeInsets(top: kTopMargin, left: 0, bottom: 0, right: 0)
        
    }

}


extension FunnyViewController
{
    override func loadData() {
        
        super.baceVM = funnyVM
        
        self.funnyVM.loadFunnyData { 
            
            self.collectionView.reloadData()
            
            // 调用父类的加载完成方法
            self.loadDataFinished()
            
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Dlog(message: "我点击了娱乐页面的第\(indexPath.row)个cell")
    }
}
