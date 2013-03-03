//
//  BFAWSManagerClass.m
//  ExampleAppGA
//
//  Created by Matthew Parker on 3/2/13.
//  Copyright (c) 2013 Matt Parker. All rights reserved.
//
#define kAWSAccessKey @"AKIAJZKKHSBMTOCKBVOA"
#define kAWSSecretKey @"tic8MBrgU0Vl9O7zFehLJtMhH2ZFfADUSGx5m8FZ"
#define kBucketName @"IntroiOS"

#import "BFAWSManager.h"

@implementation BFAWSManager

+ (void)uploadFileWithData:(NSData *)savedData named:(NSString *)name
{
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:kAWSAccessKey withSecretKey:kAWSSecretKey];
    
    @try {
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:name inBucket:kBucketName];
        
        //change content type if not photo
        por.contentType = @"image/jpeg";
        por.data = savedData;
        
        [s3 putObject:por];
        NSLog(@"Successfully uploaded photo");
    }
    @catch (NSException *exception) {
        NSLog(@"Failed to upload with exception: %@",exception);
    }
    @finally {
        
    }
}

+(void)deleteFileWithName:(NSString *)filename{
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:kAWSAccessKey withSecretKey:kAWSSecretKey];
    [s3 deleteObjectWithKey:filename withBucket:kBucketName];
}

+(NSURLRequest *)getURLforFileWithName:(NSString *)filename {
    
    AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:kAWSAccessKey withSecretKey:kAWSSecretKey];
    
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    
    //change content type if not photo
    override.contentType = @"image/jpeg";
    gpsur.key     = filename;
    gpsur.bucket  = kBucketName;
    
    //expiration date is fixed so that URL can be retrieved from cache
    gpsur.expires = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval) 60*60*24*365*100];  // expires 100 years from 1970
    gpsur.responseHeaderOverrides = override;
    
    NSURL *url = [s3 getPreSignedURL:gpsur];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    return request;
    
}

+(NSMutableArray *)s3DirectoryListingWithPrefix:(NSString *)prefix {
    
    AmazonS3Client *s3Client = [[AmazonS3Client alloc] initWithAccessKey:kAWSAccessKey withSecretKey:kAWSSecretKey];
    NSMutableArray* objectSummaries;
    
    @try {
        
        S3ListObjectsRequest *req = [[S3ListObjectsRequest alloc] initWithName:kBucketName];
        
        if (prefix) {
            req.prefix = prefix;
        }
        
        S3ListObjectsResponse *resp = [s3Client listObjects:req];
        objectSummaries = resp.listObjectsResult.objectSummaries;
    }
    @catch (NSException *exception) {
        NSLog(@"Cannot list S3 %@",exception);
    }
    return objectSummaries;
    
}


@end
