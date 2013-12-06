//
//  JCSocmedRepository.h
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCMyFeeds.h"
#import "JCSocmedRepositoryDelegate.h"

@interface JCSocmedRepository : NSObject

@property (nonatomic, weak) id<JCSocmedRepositoryDelegate> delegate;
-(void)requestFeeds:(NSString *)accessToken;
@end
