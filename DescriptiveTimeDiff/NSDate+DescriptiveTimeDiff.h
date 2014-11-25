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


- (NSInteger)dayDifferenceWithDate:(NSDate *)otherDate;
- (NSInteger)monthDifferenceWithDate:(NSDate *)otherDate;
- (NSDateComponents *)dateComponentsForDifferenceWithDate:(NSDate *)otherDate unitFlags:(NSCalendarUnit)unitFlags;

- (NSInteger)day;
- (NSInteger)month;
- (NSInteger)year;

- (BOOL)isSameDay:(NSDate *)comparedDate;
- (BOOL)isSameMonth:(NSDate *)comparedDate;
- (BOOL)isSameYear:(NSDate *)comparedDate;

@end
