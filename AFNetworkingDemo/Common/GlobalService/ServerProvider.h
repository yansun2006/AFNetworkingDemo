//
//  ServerProvider.h
//  Sloth
//
//  Created by Ann Yao on 12-9-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerReturnInfo.h"

typedef void (^ResultBlock)(ServerReturnInfo *retInfo);

@interface ServerProvider : NSObject

+ (void)loginToRestServer:(NSString*)strLoginPhone andPwd:(NSString*)strPwd result:(ResultBlock)resultBlock;

@end
