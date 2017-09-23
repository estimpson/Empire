SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vwePOD]
(	Part,
	Description )
as
--	Description:
--	Exceptions are purchase order detail records with invalid balances.
select	Part = part_number,
	Description = 'The balance for order ' + convert ( varchar, po_number ) + ' part ' + part_number + ' is negative.  ' +
	(	case IsNull ( balance, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, balance ) + ')'
		end )
from	dbo.po_detail
where	balance < 0
GO
