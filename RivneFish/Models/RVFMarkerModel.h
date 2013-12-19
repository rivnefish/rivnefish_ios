//
//  RVFMarkerModel.h
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/19/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

@import MapKit;

#import <Foundation/Foundation.h>

@interface RVFMarkerModel : NSObject <MKAnnotation>

@property (nonatomic, strong) NSNumber *markerId;
@property (nonatomic, strong) NSString *markerName;
@property (nonatomic, strong) NSString *markerAddress;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;

@end
