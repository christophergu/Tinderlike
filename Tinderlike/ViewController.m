//
//  ViewController.m
//  Tinderlike
//
//  Created by Christopher Gu on 8/7/14.
//  Copyright (c) 2014 Christopher Gu. All rights reserved.
//

#import "ViewController.h"
#import "HelloWorldViewController.h"
#import "DraggableView.h"

@interface ViewController ()
@property(nonatomic) DraggableView *draggableView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadDraggableCustomView];
}

- (void)loadDraggableCustomView
{
    self.resetButton.layer.cornerRadius = 5.0;
    
    self.draggableView = [[DraggableView alloc] initWithFrame:CGRectMake(60, 90, 200, 260)];
    
    [self.view addSubview:self.draggableView];
}

- (IBAction)onResetButtonPressed:(id)sender
{
    if (!(self.draggableView.frame.origin.x == 60.0) &&
        !(self.draggableView.frame.origin.y == 90.0)) {
        for (UIView *subview in self.view.subviews)
        {
            if ([subview isKindOfClass:[DraggableView class]])
            {
                [subview removeFromSuperview];
            }
        }

        [self loadDraggableCustomView];
        self.draggableView.alpha = 0.0;
        [UIView animateWithDuration:0.2 animations:^{
            self.draggableView.alpha = 1.0;
        }];
    }
}

- (IBAction)onTappedChecker:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint point = [tapGestureRecognizer locationInView:self.view];

    if (CGRectContainsPoint(self.draggableView.frame, point))
    {
        HelloWorldViewController *hwvc = [[HelloWorldViewController alloc]init];
        [self.navigationController pushViewController:hwvc animated:YES];
    }
}
@end
