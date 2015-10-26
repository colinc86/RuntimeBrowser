//
//  ClassCell.m
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 13.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//

#import "RTBProtocolCell.h"

@interface RTBProtocolCell ()

@end

@implementation RTBProtocolCell

- (void)setProtocolObject:(RTBProtocol *)p {
    _protocolObject = p;
    _label.text = [p protocolName];
    _label.font = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:18];
    self.accessoryType = [p hasChildren] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}

@end
