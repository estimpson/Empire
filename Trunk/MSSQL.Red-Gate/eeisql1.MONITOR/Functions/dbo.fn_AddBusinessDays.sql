SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION[dbo].[fn_AddBusinessDays](@Date DATE,@n INT)
RETURNS DATE AS 
BEGIN
DECLARE @d INT,@f INT,@DW INT;
SET @f=CAST(abs(1^SIGN(DATEPART(DW, @Date)-(7-@@DATEFIRST))) AS BIT)
SET @DW=DATEPART(DW,@Date)-(7-@@DATEFIRST)*(@f^1)+@@DATEFIRST*(@f&1)
SET @d=4-SIGN(@n)*(4-@DW);
RETURN DATEADD(D,@n+((ABS(@n)+(@d%(8+SIGN(@n)))-2)/5)*2*SIGN(@n)-@d/7,@Date);
END
GO
