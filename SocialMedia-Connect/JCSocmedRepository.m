//
//  JCSocmedRepository.m
//  SocialMedia-Connect
//
//  Created by Jevon Christian on 12/5/13.
//  Copyright (c) 2013 Jevon Christian. All rights reserved.
//

#import "JCSocmedRepository.h"

@interface JCSocmedRepository ()
@property (nonatomic, strong, readwrite) NSMutableArray *feeds;
@end

@implementation JCSocmedRepository


-(void)requestFeeds:(NSString *)accessToken
{
    //Construct the Foursquare URL
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/177321525623964/feed?access_token=%@&limit=10",accessToken];
    NSString *picture = [NSString stringWithFormat:@"https://graph.facebook.com/177321525623964/picture?access_token=%@",accessToken];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError)
                               {
                                  // [self handleNetworkErorr:connectionError];
                               }
                               else
                               {
                                   [self handleNetworkResponse:data picturePath:picture];
                               }
                           }];

}

- (void)handleNetworkResponse:(NSData *)data picturePath:(NSString *)picturePath
{
    NSError *error;
    id JSONResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (error)
    {
        //[self handleNetworkErorr:error];
        return;
    }
    
    id responseArray = [JSONResponse valueForKeyPath:@"data"];
    
    NSMutableArray *feeds = [[NSMutableArray alloc] initWithCapacity:[responseArray count]];
    for (id feedDict in responseArray)
    {
        JCMyFeeds *feed = [[JCMyFeeds alloc] initWithAPIResponse:feedDict picturePath:picturePath];
        [feeds addObject:feed];
    }
    
    self.feeds = feeds;
    
    if ([self.delegate respondsToSelector:@selector(repository:didLoadFeeds:)])
    {
        [self.delegate repository:self didLoadFeeds:self.feeds];
    }
}
@end