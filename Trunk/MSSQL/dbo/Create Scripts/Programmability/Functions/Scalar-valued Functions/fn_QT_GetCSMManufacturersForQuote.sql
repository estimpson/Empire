USE [MONITOR]
GO

/****** Object:  UserDefinedFunction [EEIUser].[fn_QT_GetCSMManufacturersForQuote]    Script Date: 03/06/2013 14:15:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



create function [EEIUser].[fn_QT_GetCSMManufacturersForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(max)
as
begin
	declare
		@ManufacturerOutput varchar(max)
		
	if exists
	(	select
			1
		from
			EEIUSER.QT_QuoteManualProgramData qmpd
		where
			qmpd.QuoteNumber = @QuoteNumber ) begin
	
	
			select
				@ManufacturerOutput = qmpd.Manufacturer
			from
				EEIUSER.QT_QuoteManualProgramData qmpd 
			where
				qmpd.QuoteNumber = @QuoteNumber
	end
	else begin
		select
			@ManufacturerOutput = COALESCE(@ManufacturerOutput + ',', '') + qcsm.Manufacturer
		from
			EEIUSER.QT_QuoteCSM qcsm
		where
			qcsm.QuoteNumber = @QuoteNumber
			and qcsm.Manufacturer is not null
		group by
			qcsm.Manufacturer
	end

	return	@ManufacturerOutput
end



GO

