//
//  CameraOverlayView.h
//  ShareStation
//
//  Created by Mitchell Kahn on 2/6/14.
//  Copyright (c) 2014 AppDelegates, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoOverlay+Convenience.h"


@protocol ShutterProtocol <NSObject>

-(void)fireShutter;

@end


@interface CameraOverlayView : UIView

@property (nonatomic, strong) UIImage *photoOverlayImage;
@property (nonatomic, strong) UIButton *shutterButton;
@property (nonatomic, weak) id<ShutterProtocol> delegate;

- (id)initWithFrame:(CGRect)frame andOverlayNamed:(NSString *)imageName andShutterButton:(UIButton *)shutterButton;
- (id)initWithFrame:(CGRect)frame andPhotoOverlay:(PhotoOverlay *)overlay andShutterButton:(UIButton *)shutterButton;

@end
