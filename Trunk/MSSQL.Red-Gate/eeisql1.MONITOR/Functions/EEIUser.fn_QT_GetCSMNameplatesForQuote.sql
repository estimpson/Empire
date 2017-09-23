SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [EEIUser].[fn_QT_GetCSMNameplatesForQuote]
(	
	@QuoteNumber varchar(50)
)
returns	varchar(max)
as
begin
	declare
		@NameplateOutput varchar(max)
		
	if exists
	(	select
			1
		from
			EEIUSER.QT_QuoteManualProgramData qmpd
		where
			qmpd.QuoteNumber = @QuoteNumber ) begin
	
	
			select
				@NameplateOutput = qmpd.Nameplate
			from
				EEIUSER.QT_QuoteManualProgramData qmpd 
			where
				qmpd.QuoteNumber = @QuoteNumber
	end
	else begin
		select
			@NameplateOutput = COALESCE(@NameplateOutput + ',', '') + qcsm.Nameplate
		from
			EEIUSER.QT_QuoteCSM qcsm
		where
			qcsm.QuoteNumber = @QuoteNumber
			and qcsm.Nameplate is not null
		group by
			qcsm.Nameplate
	end

	return	@NameplateOutput
end
GO
