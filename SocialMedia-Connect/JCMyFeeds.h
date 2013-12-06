//
//  JCMyFeeds.h
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCMyFeeds : NSObject


- (id)initWithAPIResponse:(id)apiResponse picturePath:(NSString *)picturePath;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *profPict;
@property (nonatomic, copy) NSString *feedID;

@end
