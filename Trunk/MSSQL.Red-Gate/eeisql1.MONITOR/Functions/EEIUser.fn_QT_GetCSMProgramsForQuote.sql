SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EEIUser].[fn_QT_GetCSMProgramsForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(max)
as
begin
	declare
		@ProgramOutput varchar(max)
		
	if exists
	(	select
			1
		from
			EEIUSER.QT_QuoteManualProgramData qmpd
		where
			qmpd.QuoteNumber = @QuoteNumber ) begin
	
	
			select
				@ProgramOutput = qmpd.Program
			from
				EEIUSER.QT_QuoteManualProgramData qmpd 
			where
				qmpd.QuoteNumber = @QuoteNumber
	end
	else begin
		select
			@ProgramOutput = COALESCE(@ProgramOutput + ',', '') + qcsm.Program
		from
			EEIUSER.QT_QuoteCSM qcsm
		where
			qcsm.QuoteNumber = @QuoteNumber
			and qcsm.Program is not null
		group by
			qcsm.Program
	end

	return	@ProgramOutput
end
GO
