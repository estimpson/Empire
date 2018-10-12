SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[order_header_eei] as 
	select	* from EEH.dbo.order_header_eei with (readuncommitted)
GO
