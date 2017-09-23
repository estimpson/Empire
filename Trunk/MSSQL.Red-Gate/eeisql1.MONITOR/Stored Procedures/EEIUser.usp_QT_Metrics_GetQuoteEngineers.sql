SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [EEIUser].[usp_QT_Metrics_GetQuoteEngineers]
	 @InitialsString varchar(150) out
as
set nocount on
set ansi_warnings off

--- <Body>
declare @initialsList table
(
	Initials varchar(100)
,	Processed int
)

insert into @initialsList
(
	Initials
,	Processed
)
select
	Initials
,	0
from
	EEIUser.QT_EngineeringInitials qei
where
	coalesce(qei.FirstName, '') != ''
	and coalesce(qei.LastName, '') != ''

-- Loop through list to create a comma delimited string
declare 
	@initials varchar(3)
	
while exists
	(
		select
			*
		from
			@initialsList
		where
			Processed = 0 ) begin
	
	set @initials = 		
		(
			select top 1	
				Initials 
			from 
				@initialsList
			where 
				Processed = 0 )
	
	if (@InitialsString != '') begin
		set @InitialsString = @InitialsString + ',' + @initials
	end
	else begin
		set @InitialsString = @initials
	end
	
	update @initialsList set Processed = 1 where Initials = @initials 		
end
--- </Body>
GO
