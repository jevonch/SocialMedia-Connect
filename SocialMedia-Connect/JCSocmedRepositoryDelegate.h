//
//  JCSocmedRepositoryDelegate.h
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

@class JCSocmedRepository;

@protocol JCSocmedRepositoryDelegate <NSObject>
- (void)repository:(JCSocmedRepository *)repository didLoadFeeds:(NSArray *)feeds;
- (void)repository:(JCSocmedRepository *)repository didFailToLoadFeedsWithTerm:(NSString *)term;
@end
