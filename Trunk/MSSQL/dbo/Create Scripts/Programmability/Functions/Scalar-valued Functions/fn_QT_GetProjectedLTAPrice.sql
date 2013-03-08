USE [MONITOR]
GO

/****** Object:  UserDefinedFunction [EEIUser].[fn_QT_GetProjectedLTAPrice]    Script Date: 03/06/2013 14:16:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [EEIUser].[fn_QT_GetProjectedLTAPrice]
(	
	@QuoteNumber varchar(50)
,	@EffectiveDate date
)
returns	numeric(20,4)
as
begin
	declare
		@QuotePrice numeric(20,4)
	,	@LTAPercentage numeric(20,4)
	,	@ProjectedPrice numeric(20,4)
	set
		@ProjectedPrice = 0
	
	-- Get quote price
	select
		@QuotePrice = ql.QuotePrice
	from
		EEIUser.QT_QuoteLog ql
	where
		ql.QuoteNumber = @QuoteNumber
		
	-- Get LTA percentage for quote
	select
		@LTAPercentage = qlta.Percentage
	from
		EEIUser.QT_QuoteLTA qlta
	where
		qlta.QuoteNumber = @QuoteNumber
		and qlta.EffectiveDate = @EffectiveDate
		
	-- Calculate projected quote price
	if (@LTAPercentage is not null) begin
		set @ProjectedPrice = @QuotePrice - (@QuotePrice * (@LTAPercentage / 100))
	end
	
	return	@ProjectedPrice
end
GO

