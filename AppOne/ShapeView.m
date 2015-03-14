//
//  ShapeView.m
//  demo
//
//  Created by Ma, Liang (Liang) on 3/10/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ShapeView.h"

@implementation ShapeView


#pragma mark - drawing shapes

//-(void) drawRect:(CGRect)rect {
//    
//    [super drawRect:rect];
//    
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
//    
//    // Draw them with a 2.0 stroke width so they are a bit more visible.
//    CGContextSetLineWidth(context, 2.0f);
//    
//    CGContextMoveToPoint(context, 0.0f, 0.0f); //start at this point
//    
//    CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height); //draw to this point
//    
//    // and now draw the Path!
//    CGContextStrokePath(context);
//}

-(void) willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self addShapeLayer:self.shapeType];
}


-(void) addShapeLayer:(ShapeType) type {
    switch (type) {
        case ShapeType_Circle:
            [self drawCricle];
            break;
            
        case ShapeType_Triangle:
            [self drawTriangle];
            break;
            
        default:
            [self drawSquare];
            break;
    }
}

-(void) drawCricle {
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint pt = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2.0, self.bounds.origin.y + self.bounds.size.height/2.0);
    
    [path addArcWithCenter:pt
                    radius:self.bounds.size.width/2.0
                startAngle:0.0
                  endAngle:M_PI * 2.0
                 clockwise:YES];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [path CGPath];
    
    shapeLayer.fillColor = [[UIColor redColor] CGColor];
    shapeLayer.opacity = 0.8;
    
    [[self layer] addSublayer:shapeLayer];
}

-(void) drawSquare {
    self.layer.backgroundColor = [[UIColor blueColor] CGColor];
    return;
}

-(void) drawTriangle {
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    CGPathMoveToPoint(path, nil, width/2.0, 0);
    CGPathAddLineToPoint(path, nil, 0, height);
    CGPathAddLineToPoint(path, nil, width, height);
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path;
    
    shapeLayer.fillColor = [[UIColor greenColor] CGColor];
    shapeLayer.opacity = 0.8;
    
    [[self layer] addSublayer:shapeLayer];
}


#pragma mark - pan

-(void) didMoveToSuperview {
    [super didMoveToSuperview];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
}


- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    
    NSLog(@"loc: %f, %f", [gesture locationInView:self].x, [gesture locationInView:self].y);
    
    NSLog(@"trans: %f, %f", [gesture translationInView:self].x, [gesture translationInView:self].y);
    
    CGPoint pt = [gesture locationInView:self.superview];
    self.center = pt;
}


@end
