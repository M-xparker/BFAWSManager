//
//  BFAWSManagerClass.h
//  ExampleAppGA
//
//  Created by Matthew Parker on 3/2/13.
//  Copyright (c) 2013 Matt Parker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>
#import <AWSiOSSDK/SimpleDB/AmazonSimpleDBClient.h>
#import <AWSiOSSDK/SQS/AmazonSQSClient.h>
#import <AWSiOSSDK/SNS/AmazonSNSClient.h>

@interface BFAWSManager : NSObject <AmazonServiceRequestDelegate>

+ (void)uploadFileWithData:(NSData *)savedData named:(NSString *)name;
+(void)deleteFileWithName:(NSString *)filename;
+(NSURLRequest *)getURLforFileWithName:(NSString *)filename;
+(NSMutableArray *)s3DirectoryListingWithPrefix:(NSString *)prefix;
@end
