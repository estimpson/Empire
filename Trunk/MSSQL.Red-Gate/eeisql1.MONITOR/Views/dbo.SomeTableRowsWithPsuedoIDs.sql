SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



create view [dbo].[SomeTableRowsWithPsuedoIDs]
as
select
	str.RowID
,	str.ATextColumn
,	str.RowCreateDT
,	PsuedoID = 'PFA-'+convert(char(4), datepart(year, str.RowCreateDT)) + '-' + right('000' + convert(varchar, row_number() over (partition by datepart(year, str.RowCreateDT) order by str.RowCreateDT)), 4)
from
	dbo.SomeTableRows str
GO
