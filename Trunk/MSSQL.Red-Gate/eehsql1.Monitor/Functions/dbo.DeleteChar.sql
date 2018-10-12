SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[DeleteChar]
(
	 @string varchar(25)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	declare @pos smallint

	while isnumeric(@string+'e0') = 0
	begin

	set @pos = (select patindex('%[^0-9]%',@string))
	set @string = (select replace(@string,substring(@string,@pos,1),''))

	end
	--select @string
	-- Return the result of the function
	RETURN @string
END
GO
