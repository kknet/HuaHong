//
//  UploadFileInfo.h
//  CVSUpload
//
//  Created by Leigang on 16/3/28.
//  Copyright © 2016年 Leigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadFileInfo : NSObject

@property (nonatomic, strong) NSString* filePath;
@property (nonatomic, strong) NSString* endpoint;
@property (nonatomic, strong) NSString* bucket;
@property (nonatomic, strong) NSString* object;
@property (nonatomic, strong) NSString* uploadState;
@end
