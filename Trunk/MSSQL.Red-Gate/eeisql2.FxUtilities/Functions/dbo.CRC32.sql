SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[CRC32]
/***************************************************************************************************
    DESCRIPTION
        Compute 32-bit CRC from an ASCII character array.

    INPUT PARAMETERS:
        @input          ASCII text to compute CRC for.

    RETURN VALUE:
        Resulting 32-bit CRC value.

    EXAMPLES:
        SELECT  t.input, csum = CHECKSUM(t.input), t.crc, crchex = CONVERT(VARBINARY(8), t.crc)
        FROM    (   SELECT  t.input, crc = dbo.CRC32(t.input)
                    FROM    (         SELECT  input = 'test'
                                UNION SELECT  input = 'x'
                                UNION SELECT  input = ''
                                UNION SELECT  input = NULL
                                UNION SELECT  input = 'stop'
                                UNION SELECT  input = 'pots'
                                UNION SELECT  input = 'System.IO.Stream'
                                UNION SELECT  input = 'SYSTEM.IO.Stream'
                                UNION SELECT  input = 'Test.fqn.data'
                                UNION SELECT  input = 'Test.fqn.datax'
                            ) AS t
                ) AS t
***************************************************************************************************/
(
    @input varchar(max)
)
RETURNS int
--WITH SCHEMABINDING
AS
BEGIN
    DECLARE @crc        bigint = 0xFFFFFFFF
    ,       @result     int
    ;
	declare
		@maxEasyLen bigint =
		(	select
				max(Id)
			from
				CRC32.IndexTable it
		)
	,	@inputtLen bigint = len(@input)

	if	@inputtLen<=@maxEasyLen begin

		SELECT @crc = dbo.CRC32calc(@crc, Ascii(Substring(@input, v.id, 1)))
		FROM  CRC32.IndexTable v
		where	v.Id between 1 and len(@input)  
			--dbo.IndexTable2(1, LEN(@input)) AS v
		ORDER
		BY      v.Id
		;
	end
	else begin
			SELECT @crc = dbo.CRC32calc(@crc, Ascii(Substring(@input, v.id, 1)))
		FROM  dbo.IndexTable2(1, LEN(@input)) AS v
		ORDER
		BY      v.Id
		;
	end

    SET @result = CONVERT(int, CONVERT(VARBINARY(4), ~@crc)) ;
    RETURN @result ;
END
GO
