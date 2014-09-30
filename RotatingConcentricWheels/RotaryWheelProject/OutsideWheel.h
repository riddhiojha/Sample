//
//  OutsideWheel.h
//  RotaryWheelProject
//
//  Created by Mobii_Mac on 9/30/14.
//
//

#import <UIKit/UIKit.h>
#import "SMRotaryProtocol.h"

@interface OutsideWheel : UIControl

@property (weak) id <SMRotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property int currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;


@end
