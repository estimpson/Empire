SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS OFF
GO
CREATE FUNCTION [Fx].[FileStreamCRC] (@fileContents [varbinary] (max))
RETURNS [int]
WITH EXECUTE AS CALLER
EXTERNAL NAME [CRC32].[UserDefinedFunctions].[FileStreamCRC]
GO
