//
//  StatsTrayCollectionView.h
//  Social Solver
//
//  Created by David Woods on 11/9/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Created in Version 2

#import <UIKit/UIKit.h>

@interface StatsTrayCollectionView : UIView

@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, readonly, weak) UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet id<UICollectionViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet id<UICollectionViewDataSource> dataSource;

@end
