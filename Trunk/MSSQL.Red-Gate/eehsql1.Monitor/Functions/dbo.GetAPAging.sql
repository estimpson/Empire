SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE FUNCTION [dbo].[GetAPAging]
(	
	@gl_date DATETIME
)
RETURNS TABLE 
AS
RETURN 
(
	select	*
	from	EEH_Empower.dbo.GetAPAging( @gl_date)
)
GO
