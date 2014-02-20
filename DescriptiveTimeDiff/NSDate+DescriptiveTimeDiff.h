//
//  NSDate+DescriptiveTimeDiff.h
//


typedef NS_ENUM(NSInteger, DescriptiveTimeDiffType)
{
	DescriptiveTimeDiffTypeSuffixNone = 0,
    DescriptiveTimeDiffTypeSuffixLeft,
    DescriptiveTimeDiffTypeSuffixAgo
};


@interface NSDate (DescriptiveTimeDiff)

- (NSString *)descriptiveTimeDifferenceWithType:(DescriptiveTimeDiffType)type
                                 withFullString:(BOOL)isFullStrings;

- (NSString *)descriptiveTimeDifferenceWithDate:(NSDate *)date
                                           type:(DescriptiveTimeDiffType)type
                                 withFullString:(BOOL)isFullStrings;
@end
