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
- (NSDateComponents *)componentsForDifferenceWithDate:(NSDate *)aDate;

@end
