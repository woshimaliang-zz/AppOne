//
//  ShapeMainView.m
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/17/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ShapeMainView.h"

@implementation ShapeMainView

@synthesize shapes = _shapes;


-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    for (UIView* view in self.subviews) {
        NSLog(@"%@", NSStringFromCGRect(view.frame));
        
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i=0; i<_shapes.count; i++) {
        CGPoint pt1 = [_shapes[i] center];
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextSetLineWidth(context, 3);
        for (int j=i+1; j<_shapes.count; j++) {
            CGPoint pt2 = [_shapes[j] center];
           // CGContextBeginPath(context);
            CGContextMoveToPoint(context, pt1.x, pt1.y);
            CGContextAddLineToPoint(context, pt2.x, pt2.y);
            CGContextStrokePath(context);
            //CGContextClosePath(context);
        }
    }
    
    
//    float i = rand()%300;
//    
//    rect = CGRectMake(200, i+100, 100, 100);
//    CGContextAddRect(context, rect);
//    CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
//    CGContextFillRect(context, rect);
    
}

@end
