SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [dbo].[part_eecustom] as
	select	*
	from	eeh.dbo.part_eecustom with (readuncommitted)

GO
