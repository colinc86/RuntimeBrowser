//
//  RTBActivityView.m
//  OCRuntime
//
//  Created by Colin Campbell on 10/27/15.
//  Copyright © 2015 Nicolas Seriot. All rights reserved.
//

#import "RTBActivityView.h"

@implementation RTBActivityView

@synthesize indicatorView = _indicatorView;

- (id)init {
    if (self = [super init]) {
        self.layer.cornerRadius = 10.0f;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor purpleColor];
        self.alpha = 0.9f;
        self.frame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.indicatorView.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
}

- (UIActivityIndicatorView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _indicatorView.hidesWhenStopped = YES;
        [self addSubview:_indicatorView];
    }
    
    return _indicatorView;
}

@end
