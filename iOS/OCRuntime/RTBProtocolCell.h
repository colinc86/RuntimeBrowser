//
//  ClassCell.h
//  RuntimeBrowser
//
//  Created by Nicolas Seriot on 13.08.08.
//  Copyright 2008 seriot.ch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTBProtocol.h"

@interface RTBProtocolCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIButton *button;
@property (nonatomic, retain) RTBProtocol *protocolObject;

@end
