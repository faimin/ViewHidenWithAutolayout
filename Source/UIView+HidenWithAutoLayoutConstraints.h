//
//  UIView+HidenWIthAutoLayoutConstraints.h
//  hidenWithAutolayout
//
//  Created by Tony on 15/8/20.
//  Copyright (c) 2015年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (HidenWithAutoLayoutConstraints)

- (void)foldConstraint:(BOOL)fold attributes:(NSLayoutAttribute)attributes, ...NS_REQUIRES_NIL_TERMINATION;



@end
