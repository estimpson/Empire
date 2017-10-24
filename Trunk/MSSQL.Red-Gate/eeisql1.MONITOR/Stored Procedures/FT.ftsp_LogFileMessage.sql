SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [FT].[ftsp_LogFileMessage]
(	@FileName sysname,
	@Message TEXT,
	@Status INT = 0)
AS
INSERT	FT.UOP_FileLog
(	FileName,
	Message,
	Status)
SELECT	@FileName,
	@Message,
	@Status
GO
