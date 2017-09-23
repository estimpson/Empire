SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[AddProcedureExecutionErrorMessages]
as
declare	AddMessages cursor local
for
select	'
execute	sp_addmessage
	@MsgNum = ' + convert (varchar, MessageNumber) + ',
	@Severity = 16,
	@MsgText = N''' + Message + '.'',
	@Lang = ''' + Language + ''',
	@Replace = ''Replace'''
from	dbo.ProcedureExecutionErrors
order by [Language], messageNumber


open	AddMessages

declare	@AddMessage nvarchar (1000)

fetch	AddMessages
into	@AddMessage

while	@@fetch_status = 0 begin

	execute	sp_executesql
		@AddMessage

	fetch	AddMessages
	into	@AddMessage
end


GO
