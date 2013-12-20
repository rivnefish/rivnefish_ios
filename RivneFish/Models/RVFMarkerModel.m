//
//  RVFMarkerModel.m
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/19/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

#import "RVFMarkerModel.h"

@implementation RVFMarkerModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (nil != self)
    {
        self.markerId = dictionary[@"marker_id"];
        self.markerName = dictionary[@"name"];
        self.markerAddress = dictionary[@"address"];
        _coordinate = CLLocationCoordinate2DMake([dictionary[@"lat"] doubleValue], [dictionary[@"lng"] doubleValue]);
    }
    
    return self;
}

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary
{
    return [[RVFMarkerModel alloc] initWithDictionary:dictionary];
}

@end
