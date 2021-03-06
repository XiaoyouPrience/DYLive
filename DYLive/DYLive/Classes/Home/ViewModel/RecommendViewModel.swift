//
//  RecommendViewModel.swift
//  DYLive
//
//  Created by 渠晓友 on 2017/4/18.
//  Copyright © 2017年 xiaoyouPrince. All rights reserved.
//

/*
 1> 请求0/1数组,并转成模型对象
 2> 对数据进行排序
 3> 显示的HeaderView中内容
 */

import UIKit

class RecommendViewModel : BaseViewModel {
    
    // MARK: - 懒加载对应的Model
    fileprivate lazy var bigDataGroup : AnchorGroup = AnchorGroup()
    fileprivate lazy var prettyGroup : AnchorGroup = AnchorGroup()
    
    lazy var cycleModels : [CycleModel] = [CycleModel]()
    
}


// MARK: - 请求推荐页面数据
extension RecommendViewModel{
    
    // MARK: - 请求推荐数据
    func requestData(_ finishCallBcak : @escaping() -> ()) {
        
        // 0.封装请求参数
        let params = ["limit":"4" , "offset":"0" , "time": Date.getCurrentTime() as NSString]
        
        // 0.1 创建队列
        let dGroup = DispatchGroup()
        
        // 1. 请求第1部分 热门推荐
        dGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", parameters: ["time" : Date.getCurrentTime() as NSString]) { (result) in
            
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.1 设置组属性
            self.bigDataGroup.tag_name = "热门"
            self.bigDataGroup.icon_name = "home_header_hot"
            
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                
                self.bigDataGroup.anchors.append(anchor)
            }
            
            // 请求完成离开队列
            dGroup.leave()
        }
        
        // 2. 请求第2部分 颜值数据
        dGroup.enter()
        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", parameters: params) { (result) in
            
            // 1.将result转成字典类型
            guard let resultDict = result as? [String : NSObject] else { return }
            
            // 2.根据data该key,获取数组
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
            
            // 3.1 设置组属性
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            // 3.2.获取主播数据
            for dict in dataArray {
                let anchor = AnchorModel(dict: dict)
                
                self.prettyGroup.anchors.append(anchor)

            }
            // 请求完成离开队列
            dGroup.leave()
        }
        
        
        // 3. 请求第3部分 游戏数据
        dGroup.enter()
//        NetworkTools.requestData(type: .GET, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: params) { (result) in
//            
//            // 处理对应的result
//            print(result)
//            
//            // 1. 先将result转成字典
//            guard let resultDict = result as? [String : NSObject] else { return }
//            
//            // 2. 根据data的key取出数组
//            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else { return }
//
//            // 3.遍历数组，获取字典，根据字典转化成model对象
//            for dict in dataArray{
//                
//                let group = AnchorGroup(dict: dict)
//                self.anchorGroups.append(group)
//                
//            }
//            
//            // 请求完成离开队列
//            dGroup.leave()
//
//        }
        loadAnchorData(isGroupData: true, URLString: "http://capi.douyucdn.cn/api/v1/getHotCate", parameters: params) {
            // 请求完成离开队列
            dGroup.leave()
        }
        
        
        // 4.数据请求完成之后dispatch回调
        dGroup.notify(queue: DispatchQueue.main){
            
            self.anchorGroups.insert(self.prettyGroup, at: 0)
            self.anchorGroups.insert(self.bigDataGroup, at: 0)
            
            
            print(self.anchorGroups)
            
            
            finishCallBcak()
            
        }

    }
    
    // MARK: - 请求轮播数据
    func requestCycleData(_ finishCallBcak : @escaping() -> ()) {
        
        NetworkTools.requestData(type: .GET, URLString: "http://www.douyutv.com/api/v1/slide/6", parameters: ["version" : "2.300"]) { (result) in
            
            // 1.获取整体字典数据
            guard let resultDict = result as? [String : NSObject] else{ return }
            
            // 2.根据对应的data的key获取数据
            guard let dataArray = resultDict["data"] as? [[String : NSObject]] else{ return }
            
            // 3.字典转模型
            for dict in dataArray{
                
                self.cycleModels.append(CycleModel(dict: dict))
            }
            
            finishCallBcak() //请求完成的回调  
        }
    }
    
}
