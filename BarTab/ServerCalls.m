//
//  ServerCalls.m
//  BarTab
//
//  Created by Sunny Shah on 9/10/14.
//  Copyright (c) 2014 Sunny Shah. All rights reserved.
//

#import "ServerCalls.h"

#define kFBAuthURL @"https://a65f383.ngrok.com/api/v1/login"
#define kSendGiftURL @"http://dfd1f6b.ngrok.com/api/v1/gifts"
#define kSentGiftsURL @"http://dfd1f6b.ngrok.com/api/v1/my_sent_gifts"
#define kReceivedGiftsURL @"http://dfd1f6b.ngrok.com/api/v1/my_received_gifts"

@interface ServerCalls ()

@end

@implementation ServerCalls

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


-(void)postFBAuthToken:(NSString*)authToken
{
    NSError *error;
    NSDictionary *requestParameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
                                authToken, @"oauth_token",
                                nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestParameters
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    if (!JSONData) {
        NSLog(@"Got an error: %@", error);
    }else {
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        NSLog(@"json information: %@",JSONString);
    }
    
    NSURL *yourURL1 = [NSURL URLWithString:kFBAuthURL];
    NSMutableURLRequest *yourRequest1 = [NSMutableURLRequest requestWithURL:yourURL1
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:5.0];
    [yourRequest1 setHTTPMethod:@"POST"];
    [yourRequest1 setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [yourRequest1 setHTTPBody:JSONData];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:yourRequest1 returningResponse:&urlResponse error:&requestError];
    
    if (response == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sign up failure!", @"errors", nil];
    }
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (responseString == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Network not found!", @"errors", nil];
    }
    NSLog(@"response string: %@",responseString);
    self.userAuthToken = responseString;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];

}

-(void)postGift:(NSString*)authToken :(NSString*)giftType :(NSString*)amount
{
    NSError *error;
    NSDictionary *requestParameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
                                        authToken, @"user_token",
                                        giftType, @"name",
                                        @"9737695622",@"phone",
                                        amount, @"amount",
                                        nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!JSONData) {
        NSLog(@"Got an error: %@", error);
    }else {
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        NSLog(@"json information: %@",JSONString);
    }
    
    NSURL *yourURL1 = [NSURL URLWithString:kSendGiftURL];
    NSMutableURLRequest *yourRequest1 = [NSMutableURLRequest requestWithURL:yourURL1
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:5.0];
    [yourRequest1 setHTTPMethod:@"POST"];
    [yourRequest1 setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [yourRequest1 setHTTPBody:JSONData];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:yourRequest1 returningResponse:&urlResponse error:&requestError];
    
    if (response == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sign up failure!", @"errors", nil];
    }
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (responseString == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Network not found!", @"errors", nil];
    }
    NSLog(@"response string: %@",responseString);
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
}

-(void)getAllSentGifts:(NSString*)authToken
{
    NSError *error;
    NSDictionary *requestParameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
                                        authToken, @"user_token",
                                        nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!JSONData) {
        NSLog(@"Got an error: %@", error);
    }else {
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        NSLog(@"json information: %@",JSONString);
    }
    
    NSURL *yourURL1 = [NSURL URLWithString:kSendGiftURL];
    NSMutableURLRequest *yourRequest1 = [NSMutableURLRequest requestWithURL:yourURL1
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:5.0];
    [yourRequest1 setHTTPMethod:@"GET"];
    [yourRequest1 setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [yourRequest1 setHTTPBody:JSONData];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:yourRequest1 returningResponse:&urlResponse error:&requestError];
    
    if (response == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sign up failure!", @"errors", nil];
    }
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (responseString == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Network not found!", @"errors", nil];
    }
    NSLog(@"response string: %@",responseString);
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
}

-(void)getAllReceivedGifts:(NSString*)authToken
{
    NSError *error;
    NSDictionary *requestParameters =  [[NSDictionary alloc] initWithObjectsAndKeys:
                                        authToken, @"user_token",
                                        nil];
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:requestParameters
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!JSONData) {
        NSLog(@"Got an error: %@", error);
    }else {
        NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
        NSLog(@"json information: %@",JSONString);
    }
    
    NSURL *yourURL1 = [NSURL URLWithString:kReceivedGiftsURL];
    NSMutableURLRequest *yourRequest1 = [NSMutableURLRequest requestWithURL:yourURL1
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:5.0];
    [yourRequest1 setHTTPMethod:@"GET"];
    [yourRequest1 setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [yourRequest1 setHTTPBody:JSONData];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:yourRequest1 returningResponse:&urlResponse error:&requestError];
    
    if (response == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Sign up failure!", @"errors", nil];
    }
    NSString *responseString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    if (responseString == nil) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"Network not found!", @"errors", nil];
    }
    NSLog(@"response string: %@",responseString);
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    NSLog(@"DID RECEIVE DATA");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"PROCESSING DATA");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"NOT CONNECTING TO SERVER");
}

-(NSString*)getAuthToken{
    return self.userAuthToken;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
