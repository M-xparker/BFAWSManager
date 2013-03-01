BFAWSManager
============

Class for managing iOS AWS S3 requests. A [BitFountain](http://bitfountaincode.com/) production.

Nobody likes writing a bunch of boilerplate code so here is a class that gathers it for you.

Usage
------
Just drop your keys and bucket name in at the top of the .m and you're good to go.

The class is currently set up to manage photos but just change the content type where commented if you need to upload anything else.

One thing to note is that if you want the contents of your entire bucket, just pass nil to the method below:
* `+(NSMutableArray *)s3DirectoryListingWithPrefix:(NSString *)prefix`

Requirements
------------
* ARC 
* Amazon S3 iOS SDK

License
-------
This code is made available under the terms of the MIT License.
