//
//  RVFUtils.m
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/18/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

#import "RVFUtils.h"

@implementation RVFUtils

+ (NSString *)httpMethodStringForMethod:(RVFHTTPMethod)method
{
    switch (method)
    {
        case RVFHTTPMethodGET:
            return @"GET";
        case RVFHTTPMethodPOST:
            return @"POST";
        case RVFHTTPMethodPUT:
            return @"PUT";
        case RVFHTTPMethodDELETE:
            return @"DELETE";
        default:
            return nil;
    }
}

@end
