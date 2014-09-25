//
//  UITextField+LookAndFeel.m
//  JoinJob
//
//  Created by Luca Rocchi on 11/01/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import "UITextField+LookAndFeel.h"

@implementation UITextField (LookAndFeel)
- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];;
    self.layer.borderColor=[[UIColor colorWithWhite:0.6 alpha:.8]CGColor];
    self.layer.borderWidth= 1.0f;
    self.layer.cornerRadius=3.0f;
    self.layer.masksToBounds=YES;
}
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

- (CGRect)textRectForBounds:(CGRect)bounds{
    NSString*cn= NSStringFromClass ([self class]) ;
    if ([cn isEqual:@"UISearchBarTextField"]){
        return CGRectInset( bounds , 25 , 0 );
    }
    return CGRectInset( bounds , 5 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    NSString*cn= NSStringFromClass ([self class]) ;
    if ([cn isEqual:@"UISearchBarTextField"]){
        return CGRectInset( bounds , 25 , 0 );
    }
    return CGRectInset(bounds, 5, 0);
}
#pragma clang diagnostic pop

@end
