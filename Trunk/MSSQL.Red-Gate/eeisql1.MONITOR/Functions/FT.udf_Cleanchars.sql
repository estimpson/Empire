SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create FUNCTION [FT].[udf_Cleanchars] (@InputString varchar(80)) 
RETURNS varchar(80) 
AS 

BEGIN 
declare @return varchar(80) , @length int , @counter int , @cur_char char(1) 
SET @return = '' 
SET @length = 0 
SET @counter = 1 
SET @length = LEN(@InputString) 
IF @length > 0 
BEGIN WHILE @counter <= @length 

BEGIN SET @cur_char = SUBSTRING(@InputString, @counter, 1) IF ((ascii(@cur_char) in (32,44,46)) or (ascii(@cur_char) between 48 and 57) or (ascii(@cur_char) between 65 and 90) or (ascii(@cur_char) between 97 and 122))
BEGIN SET @return = @return + @cur_char END 
SET @counter = @counter + 1 
END END 

RETURN @return END
GO
