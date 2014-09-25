//
//  NSDate+Utilities.h
//  JoinJob
//
//  Created by Luca Rocchi on 25/02/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Utilities)
-(NSString *) toItalian;
+(NSDate*) fromItalian:(NSString*)date;
-(NSString *) toMDY;
-(NSString *) toSql;
-(NSString *) toSqlShort;
+(NSDate*) fromSql:(NSString*)date;
-(NSString *) toDayMonth;
@end
