//
// UIView+HidenWIthAutoLayoutConstraints.m
// hidenWithAutolayout
//
// Created by Tony on 15/8/20.
// Copyright (c) 2015年 Tony. All rights reserved.
//

#import "UIView+HidenWithAutoLayoutConstraints.h"
#import <objc/runtime.h>

@implementation UIView (HidenWithAutoLayoutConstraints)

- (void)foldConstraint:(BOOL)fold attributes:(NSLayoutAttribute)attributes, ...NS_REQUIRES_NIL_TERMINATION {
    va_list ap;
    va_start(ap, attributes);

    if (attributes) {
        [self foldConstraint:fold attribute:attributes];

        NSLayoutAttribute detailAttribute;
        while ((detailAttribute = va_arg(ap, NSLayoutAttribute))) {
            [self foldConstraint:!self.hidden attribute:detailAttribute];
        }
    }

    va_end(ap);
    self.hidden = !self.hidden;
}

- (void)foldConstraint:(BOOL)fold attribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *constraint = [self constraintForAttribute:attribute];
    if (!constraint) {
        return;
    }
    
    NSString *constraintString = [self attributeToString:attribute];
    NSNumber *originConstant = objc_getAssociatedObject(self, constraintString.UTF8String);
    if (!originConstant) {
        objc_setAssociatedObject(self, [constraintString UTF8String], @(constraint.constant), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        originConstant = @(constraint.constant);
    }
    
    if (fold) {
        constraint.constant = 0;
    } else {
        constraint.constant = originConstant.floatValue;
    }
}

- (CGFloat)constraintConstantForAttribute:(NSLayoutAttribute)attribute {
    NSLayoutConstraint *constraint = [self constraintForAttribute:attribute];
    if (constraint) {
        return constraint.constant;
    } else {
        return NAN;
    }
}

- (NSLayoutConstraint *)constraintForAttribute:(NSLayoutAttribute)attribute {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"firstAttribute = %d && firstItem = %@", attribute, self];
    
    NSArray<__kindof NSLayoutConstraint *> *constraints= self.superview.constraints;
    NSArray<__kindof NSLayoutConstraint *> *filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    NSLayoutConstraint *constraint = filteredArray.firstObject;
    if (constraint) {
        return constraint;
    }
    
    NSArray *selfFilteredArray = [self.constraints filteredArrayUsingPredicate:predicate];
    return selfFilteredArray.firstObject;
}

#define ATRRIBUTE(_attribute) \
@(_attribute): @#_attribute,

- (NSString *)attributeToString:(NSLayoutAttribute)attribute {
    NSDictionary<NSNumber *, NSString *> *attributeMap = @{
        @(NSLayoutAttributeLeft): @"NSLayoutAttributeLeft",
        @(NSLayoutAttributeRight): @"NSLayoutAttributeRight",
        @(NSLayoutAttributeTop): @"NSLayoutAttributeTop",
        @(NSLayoutAttributeBottom): @"NSLayoutAttributeBottom",
        @(NSLayoutAttributeLeading): @"NSLayoutAttributeLeading",
        @(NSLayoutAttributeTrailing): @"NSLayoutAttributeTrailing",
        @(NSLayoutAttributeWidth): @"NSLayoutAttributeWidth",
        @(NSLayoutAttributeHeight): @"NSLayoutAttributeHeight",
        @(NSLayoutAttributeCenterX): @"NSLayoutAttributeCenterX",
        @(NSLayoutAttributeCenterY): @"NSLayoutAttributeCenterY",
        @(NSLayoutAttributeBaseline): @"NSLayoutAttributeBaseline",
        @(NSLayoutAttributeFirstBaseline): @"NSLayoutAttributeFirstBaseline",
        @(NSLayoutAttributeLeftMargin): @"NSLayoutAttributeLeftMargin",
        @(NSLayoutAttributeRightMargin): @"NSLayoutAttributeRightMargin",
        @(NSLayoutAttributeLeadingMargin): @"NSLayoutAttributeLeadingMargin",
        @(NSLayoutAttributeTrailingMargin): @"NSLayoutAttributeTrailingMargin",
        @(NSLayoutAttributeTopMargin): @"NSLayoutAttributeTopMargin",
        @(NSLayoutAttributeBottomMargin): @"NSLayoutAttributeBottomMargin",
        @(NSLayoutAttributeCenterXWithinMargins): @"NSLayoutAttributeCenterXWithinMargins",
        @(NSLayoutAttributeCenterYWithinMargins): @"NSLayoutAttributeCenterYWithinMargins",
        @(NSLayoutAttributeNotAnAttribute): @"NSLayoutAttributeNotAnAttribute",
    };
    NSString *value = attributeMap[@(attribute)] ?: @"NSLayoutAttributeNotAnAttribute";
    return value;
}

@end
