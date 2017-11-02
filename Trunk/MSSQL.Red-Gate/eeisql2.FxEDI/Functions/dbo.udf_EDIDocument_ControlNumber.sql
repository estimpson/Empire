SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create function [dbo].[udf_EDIDocument_ControlNumber]
(
	@XMLData xml
)
returns varchar(10)
as
begin
--- <Body>
	declare
		@ReturnValue varchar(max)
		
	set @ReturnValue = @XMLData.value('/*[1]/TRN-INFO[1]/@control_number', 'varchar(10)')
--- </Body>

---	<Return>
	return
		@ReturnValue
end


GO
