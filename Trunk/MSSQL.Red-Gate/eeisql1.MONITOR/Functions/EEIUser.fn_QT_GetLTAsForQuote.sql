SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EEIUser].[fn_QT_GetLTAsForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(100)
as
begin
	declare
		@LTAsOutput varchar(100) = ''
		
	if exists
	(	select
			1
		from
			eeiuser.QT_QuoteLTA qlta
		where
			qlta.QuoteNumber = @QuoteNumber
			and qlta.Percentage > 0 ) begin
		
		declare 
			@Year1 varchar(20)
		,	@Year2 varchar(20)
		,	@Year3 varchar(20)
		,	@Year4 varchar(20)
		
		set @Year1 = (	select	'Y1: ' + convert(varchar, qlta.Percentage)
						from	eeiuser.QT_QuoteLTA qlta
						where	qlta.QuoteNumber = @QuoteNumber
								and qlta.LTAYear = 1 )
		
		set @Year2 = (	select	'Y2: ' + convert(varchar, qlta.Percentage)
						from	eeiuser.QT_QuoteLTA qlta
						where	qlta.QuoteNumber = @QuoteNumber
								and qlta.LTAYear = 2 )
						
		set @Year3 = (	select	'Y3: ' + convert(varchar, qlta.Percentage)
						from	eeiuser.QT_QuoteLTA qlta
						where	qlta.QuoteNumber = @QuoteNumber
								and qlta.LTAYear = 3 )	
		
		set @Year4 = (	select	'Y4: ' + convert(varchar, qlta.Percentage)
						from	eeiuser.QT_QuoteLTA qlta
						where	qlta.QuoteNumber = @QuoteNumber
								and qlta.LTAYear = 4 )	
								
		set @LTAsOutput = @Year1 + ',' + @Year2 + ',' + @Year3 + ',' + @Year4								
	end
	
	return @LTAsOutput
end
GO
