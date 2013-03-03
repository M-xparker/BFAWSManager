//
//  BFAWSManager.m
//
//  Created by Matthew Parker on 12/18/12.
//  Copyright (c) 2012 BitFountain.
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//
#define kAWSAccessKey @"AKIAJZKKHSBMTOCKBVOA"
#define kAWSSecretKey @"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"
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
