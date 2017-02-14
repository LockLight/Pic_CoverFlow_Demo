//
//  LLCoverFlowLayout.m
//  图片coverFlow特效
//
//  Created by locklight on 17/2/14.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "LLCoverFlowLayout.h"

#define HALF_WIDTH self.collectionView.bounds.size.width / 2
#define FULL_WIDTH self.collectionView.bounds.size.width

@implementation LLCoverFlowLayout

-(void)prepareLayout{
    [super prepareLayout];
    
    //设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置cell大小
    CGFloat height = self.collectionView.bounds.size.height;
    self.itemSize = CGSizeMake(height * 0.8, height * 0.8);
    
    //版本判断,取消预加载
    if([[UIDevice currentDevice].systemVersion integerValue] >= 10.0){
        self.collectionView.prefetchingEnabled = NO;
    }
    
    //设置滚动内边距,确定第一个cell和最后一个cell位置
    self.collectionView.contentInset = UIEdgeInsetsMake(0, HALF_WIDTH - self.itemSize.width * 0.5, 0, HALF_WIDTH - self.itemSize.width * 0.5);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    //拷贝布局对象数组到新的数组,解决警告
    NSArray *arrList = [[NSArray alloc]initWithArray:arr copyItems:YES];
    
    //当前显示的中心点的值 = 半个视图宽度 + contentoffset偏移量
    CGFloat center = HALF_WIDTH + self.collectionView.contentOffset.x;
    
    //遍历单元格设置形变
    for (UICollectionViewLayoutAttributes *attr in arrList) {
        //当前单元格到当前中心点的距离
        CGFloat distance = center - attr.center.x;
        
        //缩放系数
        CGFloat scale = 1 - ABS(distance) / FULL_WIDTH;
        //根据距离设置旋转角度
        CGFloat angle = M_PI_2 * (ABS(distance) / FULL_WIDTH);
        
        //旋转方向根据距离正负确定
        if(distance < 0){
            angle = - angle;
        }
        
        //设置三维透视旋转
        CATransform3D transform = attr.transform3D;
        transform.m34 = -1.0 / 1000;
        transform =  CATransform3DRotate(transform, angle, 0, 1, 0);
        
        //旋转基础上缩放
        attr.transform3D = CATransform3DScale(transform, scale, scale, 1);
    }
    return arrList;
}

//根据拖拽力度以及cell偏移量获取坐标点
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //获取当前偏移局域内的所有cell信息
    CGFloat x = proposedContentOffset.x;
    CGFloat y = proposedContentOffset.y;
    CGFloat w = FULL_WIDTH;
    CGFloat h = self.collectionView.bounds.size.width;
    
    //获取当前偏移区域内cell的布局信息
    NSArray<UICollectionViewLayoutAttributes *>  *arrList = [super layoutAttributesForElementsInRect:CGRectMake(x, y, w, h)];
    
    //获取当前中心参照点
    CGFloat center = proposedContentOffset.x + FULL_WIDTH;
    
    //设置最小距离
    CGFloat minDistance = center - arrList[0].center.x;
    
    //遍历布局数组 计算最小距离
    for (NSInteger i = 1; i < arrList.count; i++) {
        CGFloat currentDistance = center - arrList[i].center.x;
        if(ABS(currentDistance) < ABS(minDistance)){
            minDistance = currentDistance;
        }
    }
    
    //返回距离中心最近的cell的坐标
    return CGPointMake(x - minDistance, y);
}


//是否根据视图形变设置重设布局
- (bool)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
