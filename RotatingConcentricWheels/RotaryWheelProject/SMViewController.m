//
//  SMViewController.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.
//

#import "SMViewController.h"
#import "SMRotaryWheel.h"
#import "OutsideWheel.h"

@implementation SMViewController

@synthesize  valueLabel;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 350, 120, 30)];
    valueLabel.textAlignment = UITextAlignmentCenter;
    valueLabel.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:valueLabel];
	
  
    
    
    
    
    
    
    OutsideWheel *wheelOuter = [[OutsideWheel alloc] initWithFrame:CGRectMake(0, 0, 500, 560)
                                                       andDelegate:self
                                                      withSections:8];
    
    
    wheelOuter.center = CGPointMake(320, 240);
    [self.view addSubview:wheelOuter];
    
    SMRotaryWheel *wheel = [[SMRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 250, 560)
                                                    andDelegate:self
                                                   withSections:8];
    
    
    wheel.center = CGPointMake(320, 240);
    [self.view addSubview:wheel];


    
    
//    
//    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    bg.center = CGPointMake(160, 240);
//    bg.userInteractionEnabled = NO;
//    bg.image = [UIImage imageNamed:@"overlay.png"];
//    [self.view addSubview:bg];
//     
    
    

    
    
    
    
}

- (void) wheelDidChangeValue:(NSString *)newValue {

    self.valueLabel.text = newValue;
    
}

//CABasicAnimation *rotation;
//rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//rotation.fromValue = [NSNumber numberWithFloat:0];
//rotation.toValue = [NSNumber numberWithFloat:(2*M_PI)];
//rotation.duration = 1.1; // Speed
//rotation.repeatCount = HUGE_VALF; // Repeat forever. Can be a finite number.
//[yourView.layer addAnimation:rotation forKey:@"Spin"];


@end
