//
//  CameraOverlayView.m
//  ShareStation
//
//  Created by Mitchell Kahn on 2/6/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import "CameraOverlayView.h"

@implementation CameraOverlayView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andPhotoOverlay:(PhotoOverlay *)overlay andShutterButton:(UIButton *)shutterButton{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        UIImage *ovImg = [UIImage imageWithData:overlay.overlayImgData];
        
        UIImageView *overlay = [[UIImageView alloc] initWithImage:ovImg];
        overlay.frame = frame;
        
        [self addSubview:overlay];
        
        self.shutterButton = shutterButton;
        [self addSubview:self.shutterButton];
        
        [self.shutterButton addTarget:self
                               action:@selector(shutterPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        //self.transform = CGAffineTransformMakeRotation(-3.141592/2);
        
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame andOverlayNamed:(NSString *)imageName andShutterButton:(UIButton *)shutterButton
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImageView *overlay = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        overlay.frame = frame;
        
        [self addSubview:overlay];
        
        self.shutterButton = shutterButton;
        [self addSubview:self.shutterButton];
        
        [self.shutterButton addTarget:self
                               action:@selector(shutterPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
        
        //self.transform = CGAffineTransformMakeRotation(-3.141592/2);
        
    }
    return self;
}


-(void)shutterPressed:(id)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(fireShutter)]){
        NSLog(@"Shutter touched in CameraOverlayView");
        [self.delegate fireShutter];
    }
}

@end
