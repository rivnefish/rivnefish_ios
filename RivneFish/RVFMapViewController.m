//
//  RVFMapViewController.m
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/1/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

@import MapKit;

#import "RVFMapViewController.h"
#import "RVFServerComminicationsWrapper.h"
#import "XMLDictionary.h"
#import "RVFMarkerModel.h"

static NSString * const kAnnotationViewIdentifier = @"AnnotationViewIdentifier";

@interface RVFMapViewController () <MKMapViewDelegate>
{
    IBOutlet MKMapView *_mapView;
}

@property (nonatomic, strong) NSMutableArray *markersArray;

@end

@implementation RVFMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _mapView.delegate = self;
    
    [self requestMarkerData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestMarkerData
{
    self.markersArray = [NSMutableArray array];
    
    [RVFServerComminicationsWrapper getDataFromUrl:@"http://rivnefish.com/wp-content/plugins/fish-map/fish_map_genxml2.php?action=show&lat=50.619616&lng=26.251379000000043"
                                   completionBlock:^(NSData *data) {
                                       NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
                                       for (NSDictionary *markerDict in dict[@"marker"])
                                       {
                                           [self.markersArray addObject:[RVFMarkerModel objectWithDictionary:markerDict]];
                                       }
                                       
                                       [_mapView addAnnotations:self.markersArray];
                                   }];
}

#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationViewIdentifier];
    
    if (nil == annotationView)
    {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationViewIdentifier];
    }
    
    annotationView.annotation = annotation;
    annotationView.image = [UIImage imageNamed:@"marker"];
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

@end
