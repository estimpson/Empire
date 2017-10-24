SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePPrANOS]
(	Part,
	Description )
as
--	Description:
--	Exceptions are parts designated as Auto Releasing with non-order status
--	specified.
select	Part = part_eecustom.part,
	Description = 'Non-order status specified for part ' + part_eecustom.part + '.'
from	dbo.part_eecustom
where	part_eecustom.auto_releases = 'Y' and
	IsNull ( part_eecustom.non_order_status, 'N' ) = 'Y'
GO
