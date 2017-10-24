SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EEIUser].[fn_QT_GetLTAYearsForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(max)
as
begin
	declare
		@LTAYearsOutput varchar(max)
		
	if exists
	(	select
			1
		from
			eeiuser.QT_QuoteLTA qlta
		where
			qlta.QuoteNumber = @QuoteNumber
			and qlta.Percentage > 0 ) begin
		
			select
				@LTAYearsOutput = coalesce(@LTAYearsOutput + ',', '') + qlta.EffectiveDate
			from
				eeiuser.QT_QuoteLTA qlta
			where
				qlta.QuoteNumber = @QuoteNumber
	end
	
	return @LTAYearsOutput
end
GO
