//
//  ViewController.m
//  图片coverFlow特效
//
//  Created by locklight on 17/2/14.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "ViewController.h"
#import "LLCoverFlowLayout.h"

static NSString *cellID = @"cellID";

@interface ViewController ()<UICollectionViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setupUI];
}

- (void)setupUI{
    //创建布局对象
    LLCoverFlowLayout *layout = [[LLCoverFlowLayout alloc]init];
    //创建collectionView
    UICollectionView *vc = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,200) collectionViewLayout:layout];
    
    //设置视图属性与数据源
    vc.backgroundColor = [UIColor whiteColor];
    vc.center = self.view.center;
    vc.dataSource = self;
    
    //注册
    [vc registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    
    //添加视图
    [self.view addSubview:vc];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"LOCK7"]];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
