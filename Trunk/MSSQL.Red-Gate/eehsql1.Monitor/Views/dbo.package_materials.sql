SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create view [dbo].[package_materials] as
	select	* from	eeh.dbo.package_materials with (readuncommitted)
GO
