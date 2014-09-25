//
//  NSDate+Utilities.m
//  JoinJob
//
//  Created by Luca Rocchi on 25/02/14.
//  Copyright (c) 2014 joinjob. All rights reserved.
//

#import "NSDate+Utilities.h"

@implementation NSDate (Utilities)

-(NSString *) toItalian{
    NSLocale *itLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    df.locale=itLocale;
    return [df stringFromDate:self];
}

+(NSDate*) fromItalian:(NSString*)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy"];
    return [df dateFromString:date];
}

-(NSString *) toSql{
    //NSLocale *itLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd 23:59:59"];
    //df.locale=itLocale;
    return [df stringFromDate:self];
}

-(NSString *) toSqlShort{
    //NSLocale *itLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    //df.locale=itLocale;
    return [df stringFromDate:self];
}


-(NSString *) toMDY{
    //NSLocale *itLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MM/dd/yyyy"];
    //df.locale=itLocale;
    return [df stringFromDate:self];
}

+(NSDate*) fromSql:(NSString*)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    @try {
        //NSLocale *itLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"it_IT"];
        //df.locale=itLocale;
        NSDate* d= [df dateFromString:date];
        if (d==nil){
            return [NSDate date];
        }else
            return d;
    }
    @catch (NSException *exception) {
        return [NSDate date];
    }
    @finally {
        
    }
   
}

-(NSString *) toDayMonth{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM"];
    return [df stringFromDate:self];
}

@end
