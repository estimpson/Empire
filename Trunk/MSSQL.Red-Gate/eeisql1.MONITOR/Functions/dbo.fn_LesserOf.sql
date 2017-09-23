SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE function [dbo].[fn_LesserOf]
(	@Value1 numeric(20,6),
	@Value2 numeric(20,6))
returns	numeric(20,6)
as
begin
	declare	@LesserOfValue numeric (20,6)

	if	isNULL(@Value1,0)<=isNULL(@Value2,0) 
		Select	@LesserOfValue = isNULL(@Value1,0)
	else
		Select	@LesserOfValue = isNULL(@Value2,0)
			

	return	@LesserOfValue
end

GO
