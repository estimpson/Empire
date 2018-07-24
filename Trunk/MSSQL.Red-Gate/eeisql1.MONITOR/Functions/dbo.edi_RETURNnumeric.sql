SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[edi_RETURNnumeric]
(	@InputString varchar (100))
RETURNS VARCHAR(100)
AS
begin
DECLARE @s VARCHAR(1000), @i TINYINT, @result VARCHAR(100)

--SELECT @s = '012345ab-6789ext'

SELECT @S = @InputString

SET @i = 1

SET @result = ''

WHILE (@i <= Datalength(@s)) BEGIN SET @result = @result + Substring(@s,Patindex('%[0-9]%',@s),1)

 SET @s = Stuff(@s,Patindex('%[0-9]%',@s),1,'') 
 
 SET @i = @i + 1 
  

  --SELECT @result = RIGHT(('0000000000'+@result), 10)
  SELECT @result = @result
END
RETURN @result
END


--SELECT [DBO].[edi_RETURNnumeric]('012345ab-6789ext')
GO
