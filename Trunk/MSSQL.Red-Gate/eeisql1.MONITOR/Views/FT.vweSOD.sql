SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweSOD]
(	Part,
	Description )
as
--	Description:
--	Exceptions are sales order detail records with invalid quantities.
select	Part = part_number,
	Description = 'The quantity for order ' + convert ( varchar, order_no ) + ' part ' + part_number + ' is zero or negative.  ' +
	(	case IsNull ( std_qty, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, std_qty ) + ')'
		end )
from	dbo.order_detail
where	std_qty <= 0
GO
