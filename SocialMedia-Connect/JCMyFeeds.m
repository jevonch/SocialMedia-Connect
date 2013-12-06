//
//  JCMyFeeds.m
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import "JCMyFeeds.h"

@implementation JCMyFeeds
- (id)initWithAPIResponse:(id)apiResponse picturePath:(NSString *)picturePath
{
    if (self = [super init])
    {
        self.status = [apiResponse valueForKey:@"message"];
        self.name = [[apiResponse valueForKey:@"from"]valueForKey:@"name"];
        self.createTime = [apiResponse valueForKey:@"created_time"];
        self.feedID=[apiResponse valueForKey:@"id"];
        self.profPict = picturePath;
    }
    return self;
}
@end
