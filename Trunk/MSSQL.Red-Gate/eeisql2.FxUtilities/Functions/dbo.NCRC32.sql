SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE FUNCTION [dbo].[NCRC32]
/***************************************************************************************************
    DESCRIPTION
        Compute 32-bit CRC from a UNICODE character array.

    INPUT PARAMETERS:
        @input          ASCII text to compute CRC for.

    RETURN VALUE:
        Resulting 32-bit CRC value.

    EXAMPLES:
        SELECT  t.input, csum = CHECKSUM(t.input), t.crc, crchex = CONVERT(VARBINARY(8), t.crc)
        FROM    (   SELECT  t.input, crc = dbo.NCRC32(t.input)
                    FROM    (         SELECT  input = N'test'
                                UNION SELECT  input = N'x'
                                UNION SELECT  input = N''
                                UNION SELECT  input = NULL
                                UNION SELECT  input = 'stop'
                                UNION SELECT  input = 'pots'
                                UNION SELECT  input = N'System.IO.Stream'
                                UNION SELECT  input = N'SYSTEM.IO.Stream'
                                UNION SELECT  input = N'Test.fqn.data'
                                UNION SELECT  input = N'Test.fqn.datax'
                            ) AS t
                ) AS t
***************************************************************************************************/
(
    @input nvarchar(max)
)
RETURNS int
--WITH SCHEMABINDING
AS
BEGIN
    DECLARE @crc        bigint = 0xFFFFFFFF
    ,       @result     int
    ;
    SELECT  @crc = dbo.CRC32calc( dbo.CRC32calc(@crc, (cval / 256)), cval & 0xFF)
    FROM    (   SELECT  v.id, cval = UNICODE(SUBSTRING(@input, v.id, 1))
                FROM    dbo.IndexTable(1, LEN(@input)) AS v
            ) AS t
    ORDER
    BY      t.Id
    ;
    SET @result = CONVERT(int, CONVERT(VARBINARY(4), ~@crc)) ;
    RETURN @result ;
END
GO
