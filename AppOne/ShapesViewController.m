//
//  SecondViewController.m
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/13/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ShapesViewController.h"
#import "ShapeView.h"
#import "ShapeMainView.h"

@interface ShapesViewController () <UICollisionBehaviorDelegate, ShapeMotion>

@property (nonatomic) NSMutableArray* shapes;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) IBOutlet ShapeMainView* mainView;

@end

@implementation ShapesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //make shapes
    CGRect rect = CGRectMake(110, 60, 100, 100);
    ShapeView* viewCircle =  [[ShapeView alloc] initWithFrame:rect];
    viewCircle.shapeType = ShapeType_Circle;
    viewCircle.delegate = self;
    [self.mainView addSubview:viewCircle];
    
    rect = CGRectOffset(rect, -80, 200);
    ShapeView* viewSquare =  [[ShapeView alloc] initWithFrame:rect];
    viewSquare.shapeType = ShapeType_Square;
    viewSquare.delegate = self;
    [self.mainView addSubview:viewSquare];
    
    rect = CGRectOffset(rect, 200, 0);
    ShapeView* viewTriangle =  [[ShapeView alloc] initWithFrame:rect];
    viewTriangle.shapeType = ShapeType_Triangle;
    viewTriangle.delegate = self;
    [self.mainView addSubview:viewTriangle];
    
     _shapes = [[NSMutableArray alloc] init];
    [_shapes addObject:viewCircle];
    [_shapes addObject:viewSquare];
    [_shapes addObject:viewTriangle];
    
    self.mainView.shapes = _shapes;
}

-(void) resetShapesLayout {
    CGRect rect = CGRectMake(110, 60, 100, 100);
    [self.shapes[0] setFrame:rect];
    rect = CGRectOffset(rect, -80, 200);
    [self.shapes[1] setFrame:rect];
    rect = CGRectOffset(rect, 200, 0);
    [self.shapes[2] setFrame:rect];
}

-(void) didMoved:(UIView *)view {
    [self.mainView setNeedsDisplay];
}


-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self resetShapesLayout];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.mainView];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:self.shapes]; // 创建一个重力行为
    gravity.gravityDirection = CGVectorMake(0, 1);
    [self.animator addBehavior:gravity];
    
    // 创建碰撞行为
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:self.shapes];
    // 指定 Reference view 的边界为可碰撞边界
    collision.translatesReferenceBoundsIntoBoundary = YES;
    // UICollisionBehaviorModeItems:item 只会和别的 item 发生碰撞；UICollisionBehaviorModeBoundaries：item 只和碰撞边界进行碰撞；UICollisionBehaviorModeEverything:item 和 item 之间会发生碰撞，也会和指定的边界发生碰撞。
    collision.collisionMode = UICollisionBehaviorModeEverything;
    //collision.collisionDelegate = self;
    [self.animator addBehavior:collision];
    
    UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:self.shapes[0] attachedToAnchor:[self.shapes[0] center]];
    attachment.length = 150;
    attachment.damping = 0.5;
    attachment.frequency = 1;
    [self.animator addBehavior:attachment];
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.animator removeAllBehaviors];
}

// item 与 item 之间开始碰撞。
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p {
    NSLog(@"%@", behavior);
}

//// item 与 item 之间结束碰撞。
//- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2;


// item 和边界开始碰撞
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p {
    NSLog(@"%@", behavior);
}

//// item 和边界结束碰撞
//- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier;


@end
