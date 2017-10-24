SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE  FUNCTION [dbo].[IsDateLastDayOfMonth]
(@InputDate datetime)
RETURNS int
AS
BEGIN

RETURN (SELECT DATEDIFF ( mm , @InputDate, @InputDate + 1 ))
END
GO
