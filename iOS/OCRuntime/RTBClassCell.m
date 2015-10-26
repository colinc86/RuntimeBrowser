//
//  ClassCell.m
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 13.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//

#import "RTBClassCell.h"

@interface RTBClassCell ()

@end

@implementation RTBClassCell

- (void)setClassName:(NSString *)s {
    _label.text = s;
}

- (NSString *)className {
    return _label.text;
}

@end
