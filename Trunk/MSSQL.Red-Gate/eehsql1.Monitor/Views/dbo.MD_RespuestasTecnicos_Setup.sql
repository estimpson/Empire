SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[MD_RespuestasTecnicos_Setup] as
	select	* from	Sistema.dbo.MD_RespuestasTecnicos_Setup with (readuncommitted)
GO
