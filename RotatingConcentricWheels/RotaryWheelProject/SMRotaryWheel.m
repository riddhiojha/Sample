//
//  SMRotaryWheel.m
//  RotaryWheelProject
//
//  Created by cesarerocchi on 2/10/12.
//  Copyright (c) 2012 studiomagnolia.com. All rights reserved.


#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "SMRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>
#import "SMCLove.h"

@interface SMRotaryWheel()
    - (void)drawWheel;
    - (float) calculateDistanceFromCenter:(CGPoint)point;
    - (void) buildClovesEven;
    - (void) buildClovesOdd;
    - (UIImageView *) getCloveByValue:(int)value;
    - (NSString *) getCloveName:(int)position;
@end

static float deltaAngle;
static float minAlphavalue = 0.8;
static float maxAlphavalue = 1.0;

@implementation SMRotaryWheel

@synthesize delegate, container, numberOfSections, startTransform, cloves, currentValue;


- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
		
        self.currentValue = 0;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
		[self drawWheel];
        
	}
    return self;
}



- (void) drawWheel {
    
    

    container = [[UIView alloc] initWithFrame:self.frame];
        
    CGFloat angleSize = 2*M_PI/numberOfSections;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        UIImageView *im = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment.png"]];
        
        im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x, 
                                        container.bounds.size.height/2.0-container.frame.origin.y); 
        im.transform = CGAffineTransformMakeRotation(angleSize*i);
        im.alpha = minAlphavalue;
        im.tag = i;
        
        if (i == 0) {
            im.alpha = maxAlphavalue;
        }
        
        UIImageView *cloveImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 40, 40)];
        cloveImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", i]];
//        [im addSubview:cloveImage];
        
        
        UILabel *testlabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 40, 40)];
        testlabel.text = [NSString stringWithFormat:@"test%i", i];
        
        
        
        int ringWidth = 40;
        int textRadius = 40;
        int ringAlpha = 1.0;
        int textAlpha = 1.0;
        char* fontName = (char*)[[UIFont fontWithName:@"VAGRounded-Bold" size:18].fontName cStringUsingEncoding:NSASCIIStringEncoding];
        
        NSArray* sections = [[NSArray alloc] initWithObjects:@"settings",nil];
        
        
        CGPoint centerPoint = CGPointMake(40 / 2, 40 / 2);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(@"Setting", 40, 40, 8,40, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        CGContextSetTextMatrix(context, CGAffineTransformIdentity);
        
        CGContextSelectFont(context, fontName, 18, kCGEncodingMacRoman);
        CGContextSetRGBStrokeColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, ringAlpha);
        CGContextSetLineWidth(context, ringWidth);
        
        CGContextStrokeEllipseInRect(context, CGRectMake(ringWidth, ringWidth, 40 - (ringWidth * 2), 40 - (ringWidth * 2)));
        CGContextSetRGBFillColor(context, 255.0/255.0, 255.0/255.0, 255.0/255.0, textAlpha);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
        float angle = DEGREES_RADIANS(90);
        [self drawStringAtContext:context string:@"Setting" atAngle:angle withRadius:40];
        
             
        CGContextRestoreGState(context);
        
        CGImageRef contextImage = CGBitmapContextCreateImage(context);
        
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        
        UIImage* uiImage = [[UIImage alloc] initWithCGImage:CGBitmapContextCreateImage(context)];
       
        UIImageView *textImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 40, 40)];
        textImage.image = uiImage;
        [im addSubview:cloveImage];

        
        
        
        
        
        
        
        
        
        
        
        
        [UIView beginAnimations:nil context:NULL]; // arguments are optional
//        view.transform = CGAffineTransformMakeRotation(M_PI_2);
        [UIView commitAnimations];
        
        // CALayer's transform property is a CATransform3D.
        // rotate around a vector (x, y, z) = (0, 0, 1) where positive Z points
        // out of the device's screen.
        
        testlabel.layer.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);
//        [im addSubview:testlabel];
        
        [container addSubview:im];
        
    }
    
    container.userInteractionEnabled = NO;
    [self addSubview:container];
    
    cloves = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.frame];
    bg.image = [UIImage imageNamed:@"bg.png"];
//    [self addSubview:bg];
    
    UIImageView *mask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 58, 58)];
    mask.image =[UIImage imageNamed:@"centerButton.png"] ;
    mask.center = self.center;
    mask.center = CGPointMake(mask.center.x, mask.center.y+3);
    [self addSubview:mask];
    
    if (numberOfSections % 2 == 0) {
        
        [self buildClovesEven];
        
    } else {
        
        [self buildClovesOdd];
        
    }
    
    [self.delegate wheelDidChangeValue:[self getCloveName:currentValue]];

    
}


- (UIImageView *) getCloveByValue:(int)value {

    UIImageView *res;
    
    NSArray *views = [container subviews];
    
    for (UIImageView *im in views) {
        
        if (im.tag == value)
            res = im;
        
    }
    
    return res;
    
}

- (void) buildClovesEven {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        
        if (clove.maxValue-fanWidth < - M_PI) {
            
            mid = M_PI;
            clove.midValue = mid;
            clove.minValue = fabsf(clove.maxValue);
            
        }
        
        mid -= fanWidth;
        
        
        NSLog(@"cl is %@", clove);
        
        [cloves addObject:clove];
        
    }
    
}


- (void) buildClovesOdd {
    
    CGFloat fanWidth = M_PI*2/numberOfSections;
    CGFloat mid = 0;
    
    for (int i = 0; i < numberOfSections; i++) {
        
        SMClove *clove = [[SMClove alloc] init];
        clove.midValue = mid;
        clove.minValue = mid - (fanWidth/2);
        clove.maxValue = mid + (fanWidth/2);
        clove.value = i;
        
        mid -= fanWidth;
        
        if (clove.minValue < - M_PI) {
            
            mid = -mid;
            mid -= fanWidth; 
            
        }
        
                
        [cloves addObject:clove];
        
        NSLog(@"cl is %@", clove);
        
    }
    
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
    
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    
    if (dist > 180)
    {
        // forcing a tap to be on the ferrule
        NSLog(@"ignoring tap (%f,%f)", touchPoint.x, touchPoint.y);
        return NO;
    }
    
	float dx = touchPoint.x - container.center.x;
	float dy = touchPoint.y - container.center.y;
	deltaAngle = atan2(dy,dx); 
    
    startTransform = container.transform;
    
    UIImageView *im = [self getCloveByValue:currentValue];
    im.alpha = minAlphavalue;
    
    return YES;
    
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
        
	CGPoint pt = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:pt];
    
//    if (dist < 40 || dist > 100) 
//    {
//        // a drag path too close to the center
//        NSLog(@"drag path too close to the center (%f,%f)", pt.x, pt.y);
//        
//        // here you might want to implement your solution when the drag 
//        // is too close to the center
//        // You might go back to the clove previously selected
//        // or you might calculate the clove corresponding to
//        // the "exit point" of the drag.
//
//    }
	
	float dx = pt.x  - container.center.x;
	float dy = pt.y  - container.center.y;
	float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    return YES;
	
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    
    CGFloat newVal = 0.0;
    
    for (SMClove *c in cloves) {
        
        if (c.minValue > 0 && c.maxValue < 0) { // anomalous case
            
            if (c.maxValue > radians || c.minValue < radians) {
                
                if (radians > 0) { // we are in the positive quadrant
                    
                    newVal = radians - M_PI;
                    
                } else { // we are in the negative one
                    
                    newVal = M_PI + radians;                    
                    
                }
                currentValue = c.value;
                
            }
            
        }
        
        else if (radians > c.minValue && radians < c.maxValue) {
            
            newVal = radians - c.midValue;
            currentValue = c.value;
            
        }
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    
    CGAffineTransform t = CGAffineTransformRotate(container.transform, -newVal);
    container.transform = t;
    
    [UIView commitAnimations];
    
    [self.delegate wheelDidChangeValue:[self getCloveName:currentValue]];
    
    UIImageView *im = [self getCloveByValue:currentValue];
    im.alpha = maxAlphavalue;
    
}

- (NSString *) getCloveName:(int)position {
    
    NSString *res = @"";
    
    switch (position) {
        case 0:
            res = @"Circles";
            break;
            
        case 1:
            res = @"Flower";
            break;
            
        case 2:
            res = @"Monster";
            break;
            
        case 3:
            res = @"Person";
            break;
            
        case 4:
            res = @"Smile";
            break;
            
        case 5:
            res = @"Sun";
            break;
            
        case 6:
            res = @"Swirl";
            break;
            
        case 7:
            res = @"3 circles";
            break;
            
        case 8:
            res = @"Triangle";
            break;
            
        default:
            break;
    }
    
    return res;
}


#pragma mark - Circularise text

- (void) drawStringAtContext:(CGContextRef) context string:(NSString*) text atAngle:(float) angle withRadius:(float) radius
{
    
    float perimeter = 2 * M_PI * radius;
    float textAngle = 30.0 / perimeter * 2 * M_PI;
    
    angle += textAngle / 2;
    
    for (int index = 0; index < [text length]; index++)
    {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];
        char* c = (char*)[letter cStringUsingEncoding:NSASCIIStringEncoding];
        
        NSLog(@"Char %@ with size: %f x %f", letter, 30.0, 30.0);
        
        float x = radius * cos(angle);
        float y = radius * sin(angle);
        
        float letterAngle = (30.0 / perimeter * -2 * M_PI);
        
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, x, y);
        CGContextRotateCTM(context, (angle - 0.5 * M_PI));
        CGContextShowTextAtPoint(context, 0, 0, c, strlen(c));
        CGContextRestoreGState(context);
        
        angle += letterAngle;
    }
}

- (UIImage*) createMenuRingWithFrame:(CGRect)frame
{
    }



@end
