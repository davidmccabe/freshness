//
//  DMDismissReviewSegue.m
//  Lastid
//
//  Created by David McCabe on 4/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DMDismissReviewSegue.h"

@implementation DMDismissReviewSegue

- (void)perform
{
    UIView *destView = [self.destinationViewController view];
    UIView *sourceView = [[self.sourceViewController navigationController] view];
    
    [sourceView.superview insertSubview:destView belowSubview:sourceView];
    [UIView animateWithDuration:0.5
        animations:^{
            sourceView.center = CGPointMake(285,55);
            sourceView.transform = CGAffineTransformMakeScale(0.05,0.05);
            sourceView.alpha = 0.5;
        }
        completion:^(BOOL finished) {
            [destView removeFromSuperview];
            [self.sourceViewController dismissViewControllerAnimated:NO completion:nil];
        }
     ];
}

- (void)performStepTwo
{

}

@end
