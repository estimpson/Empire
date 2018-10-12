SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetDocumentOpenAmount]
(	
	@document_type AS VARCHAR(25),
	@document_id1 AS VARCHAR(25), 
	@document_id2 AS VARCHAR(25), 
	@document_id3 AS VARCHAR(25)
)
RETURNS TABLE 
AS
RETURN
(
	SELECT	*
	FROM	EEH_EMPOWER.dbo.GetDocumentOpenAmount( @document_type, @document_id1, @document_id2, @document_id3 )
)
GO
