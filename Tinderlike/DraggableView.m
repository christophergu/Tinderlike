//
//  DraggableView.m
//  Tinderlike
//
//  Created by Christopher Gu on 8/7/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "DraggableView.h"

@interface DraggableView ()
@property(nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) CGPoint originalPoint;
@end

@implementation DraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.backgroundColor = [[UIColor grayColor] CGColor];

        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
        [self addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;
    
    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.originalPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:
        {
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngel = (CGFloat) (2*M_PI/16 * rotationStrength);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
            
            break;
        };
        case UIGestureRecognizerStateEnded:
        {
            if ((xDistance > 100) || (xDistance <= -100))
            {
                [self swipedAndDecided:xDistance Transformations:yDistance];
            }
            else
            {
                [self resetViewPositionAndTransformations];
            }
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}

- (void)swipedAndDecided:(CGFloat)xDistance Transformations:(CGFloat)yDistance
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         CGFloat rotationStrength = MIN(xDistance / 320, 1);
                         CGFloat rotationAngel = (CGFloat) (2*M_PI/16 * rotationStrength);
                         CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
                         CGFloat scale = MAX(scaleStrength, 0.93);
                         CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngel);
                         CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
                         self.transform = scaleTransform;
                         self.center = CGPointMake(self.originalPoint.x + xDistance * 3, self.originalPoint.y + yDistance * 3);
                     }];
}

- (void)resetViewPositionAndTransformations
{
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.center = self.originalPoint;
                         self.transform = CGAffineTransformMakeRotation(0);
                     }];
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}

@end
