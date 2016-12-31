//
//  TDBrowserNavBar.m
//  TechBrowser
//
//  Created by Todd Ditchendorf on 9/26/13.
//
//

#import "TDBrowserNavBar.h"

static inline CGFloat TDAlign(CGFloat x) {
    return x; //floor(x) + 0.5;
}

@implementation TDBrowserNavBar

- (void)drawRect:(CGRect)dirtyRect {
    [super drawRect:dirtyRect];
 
    CGRect bounds = self.bounds;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //CGContextSetRGBFillColor(ctx, 1.0, 1.0, 1.0, 1.0);
    CGContextSetRGBStrokeColor(ctx, 0.0, 0.0, 0.0, 0.3);
    CGContextSetLineWidth(ctx, 1.0);
    
    //CGContextFillRect(ctx, bounds);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, TDAlign(CGRectGetMinX(bounds)), TDAlign(CGRectGetMaxY(bounds)));
    CGContextAddLineToPoint(ctx, TDAlign(CGRectGetMaxX(bounds)), TDAlign(CGRectGetMaxY(bounds)));
    CGContextStrokePath(ctx);
}

@end
