//
//  NetworkManager.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/3/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "NetworkManager.h"

@implementation NetworkManager

- (void) makeDummyPostRequest: (void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion
{
    // set POST data
    NSString *postDataAsString = [NSString stringWithFormat:@"Username=%@&Password=%@", @"username", @"password"];
    
    // convert it into data
    NSData *postData = [postDataAsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // compute data length (to specify it in the request)
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // create url request with all params
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://httpbin.org/post"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // create url connection
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        int responseCode = [((NSHTTPURLResponse *)response) statusCode];
        if (responseCode != 200)
        {
            NSLog(@"%@", response.description);
            customCompletion(NO, responseCode);
        }
        
        customCompletion(YES, responseCode);
        
    }]resume];
}

- (void) makeDummyPutRequest: (void (^)(BOOL wasRequestSuccessful)) customCompletion
{
    // set PUT data
    NSString *putDataAsString = [NSString stringWithFormat:@"Some dummy put data, it really doesn't matter as HttpBin doesn't care"];
    
    // convert it into data
    NSData *putData = [putDataAsString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    // compute data length (to specify it in the request)
    NSString *putLength = [NSString stringWithFormat:@"%lu", (unsigned long)[putData length]];
    
    // create url request with all params
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://httpbin.org/post"]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:putLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:putData];
    
    // create url connection
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if ([((NSHTTPURLResponse *)response) statusCode] != 200)
        {
            NSLog(@"%@", response.description);
            customCompletion(NO);
        }
        
        customCompletion(YES);
        
    }]resume];

}

@end
