//
//  ImagesManager.m
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/13/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "ImagesManager.h"
#import "SBJson4.h"
#import "ImageItem.h"

static NSString* url_scheme = @"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=%@&rsz=8&start=%ld";

@interface ImagesManager () <NSURLConnectionDataDelegate> {
    NSURLConnection* _conn;
    NSOperationQueue* _queue;
}

@property (nonatomic, readwrite) NSInteger max_results;  //writable internally
@end


@implementation ImagesManager

@synthesize max_results;


+ (ImagesManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static ImagesManager *sharedInstance;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ImagesManager alloc] init];
    });
    
    sharedInstance.max_results = 64;
    
    return sharedInstance;
}



-(void)loading:(NSString*)keyword withCursor:(NSInteger)index returnResponse:(ResponseBlock)block {
    if (!keyword || index>=  self.max_results) return;
    
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1; //serial
    }
    
    NSOperation* op = [[NSOperation alloc] init];
    op.completionBlock =  ^(void){
        NSString* url = [NSString stringWithFormat:url_scheme, keyword, index];
        NSLog(@"requesting: %@", url);
        
        if (_conn) {
            [_conn cancel];
            _conn = nil;
        }
        
        
        NSURL *restURL = [NSURL URLWithString: url];
        NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
        //    _conn = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self startImmediately:YES];
        
        //synchrnous code for quick test.
        NSURLResponse* response = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest: restRequest returningResponse:&response error:&error];
        //NSLog(@"%@", data);
        
        if (!data) {
            return;
        }
        
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        NSLog(@"%@", object);
        if (!object[@"responseData"]) {
            return;
        }
        
        NSMutableArray* results = [[NSMutableArray alloc] init];
        NSDictionary* dicts = object[@"responseData"][@"results"];
        for (NSDictionary* dict in dicts) {
            ImageItem* item = [ImageItem new];
            item.rawTitle = dict[@"titleNoFormatting"];
            item.title = dict[@"title"];
            item.rawContent= dict[@"contentNoFormatting"];
            item.content= dict[@"content"];
            item.bigImgUrl = dict[@"url"];
            item.tbImgUrl = dict[@"tbUrl"];
            [results addObject: item];
        }
        
        NSLog(@"%@", results);
        block(results);

    };
    
    [_queue addOperation:op];    
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    NSLog(@"%@", data);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
   NSLog(@"loading done: %@", connection);
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    NSLog(@"URL Connection Failed!");
    _conn = nil;
}


@end
