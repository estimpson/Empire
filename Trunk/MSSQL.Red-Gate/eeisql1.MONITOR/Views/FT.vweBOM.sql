SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [FT].[vweBOM]
(	Part,
	Description )
as
--	Description:
--	Exceptions are bill of material records with invalid quantities.
select	Part = parent_part,
	Description = 'The std qty for part ' + part + ' is null, zero or negative.  ' +
	(	case IsNull ( std_qty, 1 )
			when 1 then '(undefined)'
			else '(' + convert ( varchar, std_qty ) + ')'
		end )
from	dbo.bill_of_material
where	IsNull ( std_qty, 0 ) <= 0
GO
