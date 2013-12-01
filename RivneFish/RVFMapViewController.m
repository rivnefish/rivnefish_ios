//
//  RVFMapViewController.m
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/1/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

#import "RVFMapViewController.h"

@interface RVFMapViewController ()
{
    IBOutlet MKMapView *_mapView;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
