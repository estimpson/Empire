SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
	
create view [dbo].[SA_PREGUNTAS] as
	select	* from	Sistema.dbo.SA_PREGUNTAS with (readuncommitted)
GO
