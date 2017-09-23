SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE function [dbo].[udf_StringToInt]
(	@stringNumber varchar(12)
)
returns int
as
begin
--- <Body>
	declare
		@intNumber int
	
	set	@intNumber = convert(int, replace(@stringNumber, ',', ''))
--- </Body>

---	<Return>
	return
		@intNumber
end

GO
