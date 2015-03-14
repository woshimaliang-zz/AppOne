//
//  ImagesManager.h
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/13/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ResponseBlock)(NSArray*);

@interface ImagesManager : NSObject {
    
}

@property (nonatomic, readonly) NSInteger max_results;

+(instancetype) sharedInstance;

-(void)loading:(NSString*)keyword withCursor:(NSInteger)index returnResponse:(ResponseBlock)block;

@end
