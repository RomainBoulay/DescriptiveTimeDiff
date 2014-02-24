//
//  NSDate+DescriptiveTimeDiff.m
//


#import "NSDate+DescriptiveTimeDiff.h"

#import "TTTLocalizedPluralString.h"
#import "NSDate+Utils.h"

#define LOCALISABLE_FULL    @"LocalizableFull"
#define LOCALISABLE_SHORT   @"LocalizableShort"

#define NSL(key, table) (NSLocalizedStringFromTable(key, table, nil))

#define LEFT_FORMAT(table)     (NSL(@"LeftFormat", table))
#define AGO_FORMAT(table)      (NSL(@"AgoFormat", table))
#define IN_FORMAT(table)      (NSL(@"InFormat", table))


@implementation NSDate (DescriptiveTimeDiff)


#pragma mark - Private
+ (NSString *)stringWithComponents:(NSDateComponents *)dateComponents localizationsTable:(NSString *)table {
    NSString *returnString;

    if (dateComponents.year > 0)
        returnString = [self.class stringWithKey:@"year" localizationsTable:table andCount:dateComponents.year];
    
    else if (dateComponents.month > 0)
        returnString = [self.class stringWithKey:@"month" localizationsTable:table andCount:dateComponents.month];
    
    else if (dateComponents.week > 0)
        returnString = [self.class stringWithKey:@"week" localizationsTable:table andCount:dateComponents.week];
    
    else if (dateComponents.day > 0)
        returnString = [self.class stringWithKey:@"day" localizationsTable:table andCount:dateComponents.day];
    
    else if (dateComponents.hour > 0)
        returnString = [self.class stringWithKey:@"hour" localizationsTable:table andCount:dateComponents.hour];
    
    else if (dateComponents.minute > 0)
        returnString = [self.class stringWithKey:@"minute" localizationsTable:table andCount:dateComponents.minute];
    
    else if (dateComponents.second > 0)
        returnString = [self.class stringWithKey:@"second" localizationsTable:table andCount:dateComponents.second];
    
    return returnString;
}


+ (NSString *)stringWithKey:(NSString *)i18nKey localizationsTable:(NSString *)table andCount:(NSInteger)count {
    return [NSString stringWithFormat:NSL(TTTLocalizedPluralStringKeyForCountAndSingularNoun(count, NSL(i18nKey, table)), table), count];
}


#pragma mark - Public
- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date type:(DescriptiveTimeDiffType)type fullString:(BOOL)isFullStrings {
    NSDateComponents *dateComponents = [self componentsForDifferenceWithDate:date];

    // Determining string format with given type
    NSString *localizationsTable = (isFullStrings) ? LOCALISABLE_FULL : LOCALISABLE_SHORT;
    NSString *format;
    if (type == DescriptiveTimeDiffTypeSuffixLeft)
        format = LEFT_FORMAT(localizationsTable);
    
    else if (type == DescriptiveTimeDiffTypeSuffixAgo)
        format = AGO_FORMAT(localizationsTable);
    
    else if (type == DescriptiveTimeDiffTypeSuffixIn)
        format = IN_FORMAT(localizationsTable);
    
    NSString *description = [self.class stringWithComponents:dateComponents localizationsTable:localizationsTable];
    
    if (description.length)
        description = [NSString stringWithFormat:format, description];
    
    return (description.length) ? description : nil;
}

@end
