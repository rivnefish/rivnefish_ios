#import <CoreText/CoreText.h>
#import "GDefaultClusterRenderer.h"
#import "GQuadItem.h"
#import "GCluster.h"

@implementation GDefaultClusterRenderer {
    GMSMapView *_map;
    NSMutableArray *_markerCache;
}

- (id)initWithMapView:(GMSMapView*)googleMap {
    if (self = [super init]) {
        _map = googleMap;
        _markerCache = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)clustersChanged:(NSSet*)clusters {
    for (GMSMarker *marker in _markerCache) {
        marker.map = nil;
    }
    
    [_markerCache removeAllObjects];
    
    for (id <GCluster> cluster in clusters) {
        GMSMarker *marker;
        marker = [[GMSMarker alloc] init];
        [_markerCache addObject:marker];
        
        NSUInteger count = cluster.items.count;
        if (count > 1) {
            marker.icon = [self generateClusterIconWithCount:count];
        }
        else {
            marker.icon = cluster.marker.icon;
        }
        
        marker.userData = cluster.marker.userData;
        
        marker.position = cluster.marker.position;
        marker.map = _map;
    }
}

- (UIImage*)generateClusterIconWithCount:(NSUInteger)count {
    
    int diameter = 30;
    float inset = 1;

    CGRect rect = CGRectMake(0, 0, diameter + 10, diameter + 10);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // draw shadow
    CGContextSaveGState(ctx);
    CGContextSetShadow(ctx, CGSizeMake(2, 2), 2);
    [[UIColor whiteColor] setFill];
    CGRect shadowRect = CGRectMake(0, 0, diameter, diameter);
    CGContextFillEllipseInRect(ctx, shadowRect);
    CGContextRestoreGState(ctx);

    // set stroking color and draw circle
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0] setStroke];

    UIColor *yellow = [UIColor colorWithRed:1.0 green:180.0 / 255.0 blue:0 alpha:1.0];
    UIColor *orange = [UIColor colorWithRed:253.0 / 255.0 green:128.0 / 255.0 blue:35.0 / 255.0 alpha:1.0];
    UIColor *blue = [UIColor colorWithRed:92.0 / 255.0 green:115.0 / 255.0 blue: 201.0 / 255.0 alpha:1.0];

    if (count > 100) [yellow setFill];
    else if (count > 10) [orange setFill];
    else [blue setFill];

    CGContextSetLineWidth(ctx, inset);

    // make circle rect 5 px from border
    CGRect circleRect = CGRectMake(0, 0, diameter, diameter);
    circleRect = CGRectInset(circleRect, inset, inset);

    // draw circle
    CGContextFillEllipseInRect(ctx, circleRect);
    CGContextStrokeEllipseInRect(ctx, circleRect);

    CTFontRef myFont = CTFontCreateWithName( (CFStringRef)@"Helvetica-Bold", 10.0f, NULL);
    
    UIColor *fontColor;
    fontColor = [UIColor whiteColor];
    
    NSDictionary *attributesDict = [NSDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)myFont, (id)kCTFontAttributeName,
                    fontColor, (id)kCTForegroundColorAttributeName, nil];

    // create a naked string
    NSString *string = [[NSString alloc] initWithFormat:@"%lu", (unsigned long)count];

    NSAttributedString *stringToDraw = [[NSAttributedString alloc] initWithString:string
                                                                       attributes:attributesDict];

    // flip the coordinate system
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, diameter);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)(stringToDraw));
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter,
                                                                        CFRangeMake(0, stringToDraw.length),
                                                                        NULL,
                                                                        CGSizeMake(diameter, diameter),
                                                                        NULL);
    CFRelease(frameSetter);
    
    //Get the position on the y axis
    float midHeight = diameter;
    midHeight -= suggestedSize.height;
    
    float midWidth = diameter / 2;
    midWidth -= suggestedSize.width / 2;

    CTLineRef line = CTLineCreateWithAttributedString(
            (__bridge CFAttributedStringRef)stringToDraw);
    CGContextSetTextPosition(ctx, midWidth, 12);
    CTLineDraw(line, ctx);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
