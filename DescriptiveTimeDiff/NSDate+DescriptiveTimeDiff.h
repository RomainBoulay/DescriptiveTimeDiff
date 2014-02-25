//
//  NSDate+DescriptiveTimeDiff.h
//


typedef NS_ENUM(NSInteger, DescriptiveTimeDiffType)
{
	DescriptiveTimeDiffTypeSuffixNone = 0,
    DescriptiveTimeDiffTypeSuffixLeft,
    DescriptiveTimeDiffTypeSuffixIn,
    DescriptiveTimeDiffTypeSuffixAgo
};


@interface NSDate (DescriptiveTimeDiff)

- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date
                                           type:(DescriptiveTimeDiffType)type
                                     fullString:(BOOL)isFullStrings;


- (NSInteger)dayDifferenceWithDate:(NSDate *)aDate;
- (NSInteger)monthDifferenceWithDate:(NSDate *)aDate;
- (NSDateComponents *)dateComponentsForDifferenceWithDate:(NSDate *)aDate unitFlags:(NSCalendarUnit)unitFlags;

- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;

@end
