//
//  UITextView+LookAndFeel.m
//  JoinJob
//
//  Created by Luca Rocchi on 11/01/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import "UITextView+LookAndFeel.h"

@implementation UITextView (LookAndFeel)
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];;
    self.layer.borderColor=[[UIColor colorWithWhite:0.6 alpha:.8]CGColor];
    self.layer.borderWidth= 1.0f;
    self.layer.cornerRadius=3.0f;
    self.layer.masksToBounds=YES;
}

@end
