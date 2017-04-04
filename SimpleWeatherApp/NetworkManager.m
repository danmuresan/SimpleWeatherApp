//
//  NetworkManager.m
//  SimpleWeatherApp
//
//  Created by Muresan, Dan-Sorin on 4/3/17.
//  Copyright © 2017 Muresan, Dan-Sorin. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

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

    //sSessionDelegate

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

- (void) makeDummyAfPostRequest:(void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    // it would be pretty similar with any JSON we want to send (as long as we transform it into an NSDictionary)
    NSDictionary *postParams = @{@"Username" : @"someUsername",
                                 @"Password" : @"somePassword"};
    [sessionManager POST:@"http://httpbin.org/post" parameters:postParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        customCompletion(YES, 200);
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
        customCompletion(NO, [(NSHTTPURLResponse *)task.response statusCode]);
    }];
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
    [request setURL:[NSURL URLWithString:@"http://httpbin.org/put"]];
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

- (void) makeDummyAfPutRequest:(void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    // it would be pretty similar with any JSON we want to send (as long as we transform it into an NSDictionary)
    NSDictionary *putParams = @{@"Username" : @"someUsername",
                                 @"Password" : @"somePassword"};

    [sessionManager PUT:@"http://httpbin.org/put" parameters:putParams success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        customCompletion(YES, 200);
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
        customCompletion(NO, [(NSHTTPURLResponse *)task.response statusCode]);
    }];
}

- (void) makeDummyAfGetRequest:(void (^)(BOOL wasRequestSuccessful, int responseCode)) customCompletion
{
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    [sessionManager GET:@"http://httpbin.org/get" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        // TODO: parse response here
        customCompletion(YES, 200);
    }
    failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        // TODO: send nil via completion (or something)
        NSLog(@"%@", error.description);
        customCompletion(NO, [(NSHTTPURLResponse *)task.response statusCode]);
    }];
}

@end
