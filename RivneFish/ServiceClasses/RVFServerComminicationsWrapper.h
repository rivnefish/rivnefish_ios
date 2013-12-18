//
//  RVFServerComminicationsWrapper.h
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/18/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Typedefs.h"

@interface RVFServerComminicationsWrapper : NSObject

+ (void)sendData:(NSData *)data
           toUrl:(NSString *)urlString
 usingHTTPMethod:(RVFHTTPMethod)method
 completionBlock:(void (^)(NSData *data))completionBlock;

+ (void)getDataFromUrl:(NSString *)url
       completionBlock:(void (^)(NSData *data))completionBlock;

@end
