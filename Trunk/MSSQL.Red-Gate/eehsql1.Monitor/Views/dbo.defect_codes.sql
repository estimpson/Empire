SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[defect_codes] as
	select	* from	 EEH.dbo.defect_codes with (readuncommitted)

GO
