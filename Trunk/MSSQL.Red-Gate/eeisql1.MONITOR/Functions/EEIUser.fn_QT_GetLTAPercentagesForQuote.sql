SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EEIUser].[fn_QT_GetLTAPercentagesForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(max)
as
begin
	declare
		@LTAPercentagesOutput varchar(max)
		
	if exists
	(	select
			1
		from
			eeiuser.QT_QuoteLTA qlta
		where
			qlta.QuoteNumber = @QuoteNumber
			and qlta.Percentage > 0 ) begin
		
			select
				@LTAPercentagesOutput = coalesce(@LTAPercentagesOutput + ',', '') + convert(varchar, qlta.Percentage)
			from
				eeiuser.QT_QuoteLTA qlta
			where
				qlta.QuoteNumber = @QuoteNumber
	end
	
	return @LTAPercentagesOutput
end
GO
