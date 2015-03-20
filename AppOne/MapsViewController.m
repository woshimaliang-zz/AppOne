//
//  MapsViewController.m
//  AppOne
//
//  Created by Ma, Liang (Liang) on 3/19/15.
//  Copyright (c) 2015 Ma, Liang (Liang). All rights reserved.
//

#import "MapsViewController.h"
#import <MapKit/MapKit.h>

@interface MapsViewController () <UISearchBarDelegate>

@property (nonatomic) NSMutableArray* annos;
@property (nonatomic) IBOutlet UISearchBar* searchBar;
@property (nonatomic) IBOutlet MKMapView* mapView;

@end

@implementation MapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CLLocationCoordinate2D center;
    center.latitude = 37.388159;
    center.longitude = -121.994762;
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 10000, 10000);
    self.mapView.region = region;
    
    self.annos = [[NSMutableArray alloc] init];
    [self loadStaticAnnoations];
}

-(void) loadStaticAnnoations {
    NSString* file = [[NSBundle mainBundle] pathForResource:@"items" ofType:@"plist"];
    NSArray* array = [NSArray arrayWithContentsOfFile:file];
    
    for (NSDictionary* dict in array) {
        MKPointAnnotation* anno = [[MKPointAnnotation alloc] init];
        anno.title = dict[@"name"];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue], [dict[@"lon"] doubleValue]);
        anno.coordinate = coordinate;
        [self.mapView addAnnotation:anno];
        [self.annos addObject:anno];
    }
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  
    [self.mapView removeAnnotations:self.annos];
    [self.annos removeAllObjects];
    __block MapsViewController* __weak weakSelf = self;
    
//  address search
//    CLGeocoder* geo = [[CLGeocoder alloc] init];
//    [geo geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
//        
//        for (MKPlacemark* mark in placemarks) {
//            MKPointAnnotation* anno = [[MKPointAnnotation alloc] init];
//            anno.coordinate = mark.location.coordinate;
//            anno.title = weakSelf.searchBar.text;
//            [weakSelf.mapView addAnnotation:anno];
//            [weakSelf.annos addObject:anno];
//        }
//        
//        if (placemarks.count ==0) return;
//        
//        //scroll to first item
//        MKMapRect rect = [weakSelf.mapView visibleMapRect];
//        MKMapPoint pt = MKMapPointForCoordinate([(MKPlacemark*)placemarks[0] location].coordinate);
//        rect.origin.x = pt.x - rect.size.width*0.5;
//        rect.origin.y = pt.y - rect.size.height*0.25;
//        [weakSelf.mapView setVisibleMapRect:rect animated:YES];
//    }];
    
    //poi search
    MKLocalSearchRequest* request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchBar.text;
    request.region = self.mapView.region;
    
    MKLocalSearch* search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        for (MKMapItem* mark in response.mapItems) {
            MKPointAnnotation* anno = [[MKPointAnnotation alloc] init];
            anno.coordinate = mark.placemark.location.coordinate;
            anno.title = mark.name;
            [weakSelf.mapView addAnnotation:anno];
            [weakSelf.annos addObject:anno];
        }

        if (response.mapItems ==0) return;
        
        [weakSelf.mapView setRegion:response.boundingRegion animated:YES];
       
        //scroll to first item
        MKMapRect rect = [weakSelf.mapView visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([[(MKMapItem*)response.mapItems[0] placemark] location].coordinate);
        rect.origin.x = pt.x - rect.size.width*0.5;
        rect.origin.y = pt.y - rect.size.height*0.25;
        //[weakSelf.mapView setVisibleMapRect:rect animated:YES];
    }];
}

-(IBAction)handleTap:(UIGestureRecognizer*) gesture {
    
    [self.searchBar resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
