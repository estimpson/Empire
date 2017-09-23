SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE function [FT].[fn_GetNextContainerLocation]
(	@ContainerDT datetime,
	@ContainerNum tinyint)
returns varchar (10)
as
begin
	declare	@ContainerLocation varchar (10)

	select	@ContainerLocation =
			'TRAN'+ convert (varchar, @ContainerNum) +
			'-' + Right ('0' +  convert(varchar, datepart(ISO_WEEK, @ContainerDT)),2) + Upper(Left(DateName (dw, @ContainerDT),2))


	return	@ContainerLocation
end
GO
