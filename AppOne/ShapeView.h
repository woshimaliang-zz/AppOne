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

@protocol ShapeMotion <NSObject>

@optional
-(void) didMoved:(UIView*)view;

@end

@interface ShapeView : UIView <UIGestureRecognizerDelegate>

@property(nonatomic) ShapeType shapeType;
@property(nonatomic, weak) id<ShapeMotion> delegate;

@end
