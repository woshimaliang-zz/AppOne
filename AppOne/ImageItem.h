//
//  ImageItem.h
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/4/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageItem : NSObject

@property (strong, atomic) NSString* bigImgUrl;
@property (nonatomic) NSInteger bigImgWidth;
@property (nonatomic) NSInteger bigImgHeight;

@property (strong, atomic) NSString* tbImgUrl;
@property (nonatomic) NSInteger tbImgWidth;
@property (nonatomic) NSInteger tbImgHeight;

@property (strong, atomic) NSString* title;
@property (strong, atomic) NSString* rawTitle;
@property (strong, atomic) NSString* content;
@property (strong, atomic) NSString* rawContent;

@end
