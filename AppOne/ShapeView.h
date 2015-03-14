//
//  ShapeView.h
//  demo
//
//  Created by Ma, Liang (Liang) on 3/10/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShapeType) {
    ShapeType_Circle = 0,
    ShapeType_Square = 1,
    ShapeType_Triangle = 2,
};

@interface ShapeView : UIView <UIGestureRecognizerDelegate>

@property(nonatomic) ShapeType shapeType;

@end
