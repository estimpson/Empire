USE [MONITOR]
GO

/****** Object:  UserDefinedFunction [EEIUser].[fn_QT_GetCSMPlatformsForQuote]    Script Date: 03/06/2013 14:16:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE function [EEIUser].[fn_QT_GetCSMPlatformsForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(max)
as
begin
	declare
		@PlatformOutput varchar(max)
		
	if exists
	(	select
			1
		from
			EEIUSER.QT_QuoteManualProgramData qmpd
		where
			qmpd.QuoteNumber = @QuoteNumber ) begin
	
	
			select
				@PlatformOutput = qmpd.Platform
			from
				EEIUSER.QT_QuoteManualProgramData qmpd 
			where
				qmpd.QuoteNumber = @QuoteNumber
	end
	else begin
		select
			@PlatformOutput = COALESCE(@PlatformOutput + ',', '') + qcsm.Platform
		from
			EEIUSER.QT_QuoteCSM qcsm
		where
			qcsm.QuoteNumber = @QuoteNumber
			and qcsm.Platform is not null
		group by
			qcsm.Platform
	end

	return	@PlatformOutput
end

GO

