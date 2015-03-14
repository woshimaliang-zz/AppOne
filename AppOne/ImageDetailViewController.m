//
//  ImageDetailViewController.m
//  demo
//
//  Created by Ma, Liang (Liang) on 3/11/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ImageDetailViewController.h"
#import "ImageItem.h"
#import <UIImageView+WebCache.h>

@interface ImageDetailViewController () {
    
}

@property (nonatomic) IBOutlet UIActivityIndicatorView* activity;
@property (nonatomic) IBOutlet UILabel* label;
@property (nonatomic) IBOutlet UIImageView* imageView;

@end

@implementation ImageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.imageItem.rawContent;
    self.label.text = self.imageItem.rawTitle;
    
    __block ImageDetailViewController* __weak weakSelf = self;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageItem.bigImgUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.activity stopAnimating];
        weakSelf.activity.hidden = YES;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
