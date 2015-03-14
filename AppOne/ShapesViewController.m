//
//  SecondViewController.m
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/13/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ShapesViewController.h"
#import "ShapeView.h"

@interface ShapesViewController ()

@end

@implementation ShapesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //make shapes
    CGRect rect = CGRectMake(110, 60, 100, 100);
    ShapeView* viewCircle =  [[ShapeView alloc] initWithFrame:rect];
    viewCircle.shapeType = ShapeType_Circle;
    [self.view addSubview:viewCircle];
    
    rect = CGRectOffset(rect, -80, 200);
    ShapeView* viewSquare =  [[ShapeView alloc] initWithFrame:rect];
    viewSquare.shapeType = ShapeType_Square;
    [self.view addSubview:viewSquare];
    
    rect = CGRectOffset(rect, 200, 0);
    ShapeView* viewTriangle =  [[ShapeView alloc] initWithFrame:rect];
    viewTriangle.shapeType = ShapeType_Triangle;
    [self.view addSubview:viewTriangle];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
