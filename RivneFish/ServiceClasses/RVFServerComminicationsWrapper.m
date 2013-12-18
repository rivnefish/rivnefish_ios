//
//  RVFServerComminicationsWrapper.m
//  RivneFish
//
//  Created by Yurii Zadoianchuk on 12/18/13.
//  Copyright (c) 2013 RivneFish. All rights reserved.
//

#import "RVFServerComminicationsWrapper.h"
#import "RVFUtils.h"

@implementation RVFServerComminicationsWrapper

+ (void)sendData:(NSData *)data
           toUrl:(NSString *)urlString
 usingHTTPMethod:(RVFHTTPMethod)method
 completionBlock:(void (^)(NSData *data))completionBlock
{
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    NSMutableURLRequest *mutableUrlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [mutableUrlRequest setHTTPBody:data];
    [mutableUrlRequest setHTTPMethod:[RVFUtils httpMethodStringForMethod:method]];
    [mutableUrlRequest setValue:@"application/xml"
             forHTTPHeaderField:@"Accept"];
    
    if (nil != data)
    {
        [mutableUrlRequest setValue:@"application/xml"
                 forHTTPHeaderField:@"Content-Type"];
        [mutableUrlRequest setValue:[NSString stringWithFormat:@"%u", [data length]]
                 forHTTPHeaderField:@"Content-Length"];
    }
    
    [NSURLConnection sendAsynchronousRequest:mutableUrlRequest
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         completionBlock(data);
    }];
}

+ (void)getDataFromUrl:(NSString *)url
       completionBlock:(void (^)(NSData *data))completionBlock
{
    [self sendData:nil
             toUrl:url
   usingHTTPMethod:RVFHTTPMethodGET
   completionBlock:completionBlock];
}

@end
