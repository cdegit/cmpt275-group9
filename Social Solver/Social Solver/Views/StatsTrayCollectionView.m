//
//  StatsTrayCollectionView.m
//  Social Solver
//
//  Created by David Woods on 11/9/2013.
//  Copyright (c) 2013 Group 9. All rights reserved.
//
//  Worked on by: David Woods

//  Created in Version 2

#import "StatsTrayCollectionView.h"

static int KVOContentSizeContext;

#define BUTTON_SIZE 40.0f


@interface StatsTrayCollectionView()

@property (nonatomic, weak) UICollectionView* collectionView;
@property (nonatomic, weak) UIButton* previousButton;
@property (nonatomic, weak) UIButton* nextButton;

@end

@implementation StatsTrayCollectionView

- (void)awakeFromNib
{
    [self setupViews];
}

- (void)dealloc
{
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)setupViews
{
    // 1 - Setup collection view
    UICollectionViewFlowLayout* flow = [[UICollectionViewFlowLayout alloc] init];
    flow.scrollDirection = (self.isHorizontal ? UICollectionViewScrollDirectionHorizontal : UICollectionViewScrollDirectionVertical);
    flow.itemSize = CGSizeMake(75, 85);
    flow.minimumInteritemSpacing = 10;
    
    UICollectionView* collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flow];
    collectionView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    collectionView.scrollEnabled = NO;
    collectionView.allowsSelection = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self.dataSource;
    collectionView.delegate = self.delegate;

    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:0 context:&KVOContentSizeContext];
    
    // 2 - Setup previous button
    UIButton* prevButton = [UIButton buttonWithType:UIButtonTypeCustom];
    prevButton.autoresizingMask = (self.isHorizontal ? (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight) : (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin));
    [prevButton setImage:[UIImage imageNamed:(self.isHorizontal ? @"arrow-left" : @"arrow-up")] forState:UIControlStateNormal];
    prevButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f];
    prevButton.frame = (self.isHorizontal ? CGRectMake(0, 0, BUTTON_SIZE, CGRectGetHeight(self.bounds)) : CGRectMake(0, 0, CGRectGetWidth(self.bounds), BUTTON_SIZE));
    [prevButton addTarget:self action:@selector(handlePreviousButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    prevButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:prevButton];
    self.previousButton = prevButton;
    
    // 3 - Setup next button
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.autoresizingMask = (self.isHorizontal ? (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight) : (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin));
    [nextButton setImage:[UIImage imageNamed:(self.isHorizontal ? @"arrow-right" : @"arrow-down")] forState:UIControlStateNormal];
    nextButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75f];
    nextButton.frame = (self.isHorizontal ? CGRectMake(CGRectGetWidth(self.bounds) - BUTTON_SIZE, 0, BUTTON_SIZE, CGRectGetHeight(self.bounds)) : CGRectMake(0, CGRectGetHeight(self.bounds) - BUTTON_SIZE, CGRectGetWidth(self.bounds), BUTTON_SIZE));
    [nextButton addTarget:self action:@selector(handleNextButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    nextButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:nextButton];
    self.nextButton = nextButton;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == &KVOContentSizeContext)
    {
        [self updateButtonsForContentOffset:self.collectionView.contentOffset animated:NO];
    }
    else
    {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
}

- (void)handlePreviousButtonTapped
{
    // Figure out where to scroll to to display the page to the left of the current one being viewed
    CGPoint newOffset = self.collectionView.contentOffset;
    if (self.isHorizontal)
    {
        newOffset.x -= CGRectGetMinX(self.nextButton.frame) - CGRectGetMaxX(self.previousButton.frame);
        newOffset.x = MAX(newOffset.x, 0);
    }
    else
    {
        newOffset.y -= CGRectGetMinY(self.nextButton.frame) - CGRectGetMaxY(self.previousButton.frame);
        newOffset.y = MAX(newOffset.y, 0);
    }
    
    [self updateButtonsForContentOffset:newOffset animated:YES];
    [self.collectionView setContentOffset:newOffset animated:YES];
}

- (void)handleNextButtonTapped
{
    // Figure out the offset of the next page
    CGPoint newOffset = self.collectionView.contentOffset;
    if (self.isHorizontal)
    {
        newOffset.x += CGRectGetMinX(self.nextButton.frame) - CGRectGetMaxX(self.previousButton.frame);
        CGFloat maxOffsetX = self.collectionView.contentSize.width - CGRectGetWidth(self.collectionView.bounds);
        newOffset.x = MIN(newOffset.x, maxOffsetX);
    }
    else
    {
        newOffset.y += CGRectGetMinY(self.nextButton.frame) - CGRectGetMaxY(self.previousButton.frame);
        CGFloat maxOffsetY = self.collectionView.contentSize.height - CGRectGetHeight(self.collectionView.bounds);
        newOffset.y = MIN(newOffset.y, maxOffsetY);
    }
    
    // Scroll to the next page
    [self updateButtonsForContentOffset:newOffset animated:YES];
    [self.collectionView setContentOffset:newOffset animated:YES];
}

- (void)updateButtonsForContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    BOOL showPrevious;
    BOOL showNext;
    
    // Figure out whether to display the next and previous buttons based on orientation and current offset
    if (self.isHorizontal)
    {
        showPrevious = (contentOffset.x > 0);
        showNext = (contentOffset.x + CGRectGetWidth(self.collectionView.bounds) < self.collectionView.contentSize.width);
    }
    else
    {
        showPrevious = (contentOffset.y > 0);
        showNext = (contentOffset.y + CGRectGetHeight(self.collectionView.bounds) < self.collectionView.contentSize.height);
    }
    
    // Hide or show the buttons
    [UIView animateWithDuration:(animated ? 0.3 : 0.0)
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         self.previousButton.alpha = (showPrevious ? 1.0f : 0.0f);
                         self.nextButton.alpha = (showNext ? 1.0f : 0.0f);
                     }
                     completion:nil];
}

@end
