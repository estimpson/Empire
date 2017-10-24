SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE view [dbo].[vw_eei_row3_locations]
as
Select code from location where code like '%-%' and  code not like 'EE%'
and code not like 'FG%' and code not like '%*%' and plant not like '%TRAN%' and code not like 'QC%' and code not in ('MEZWIRE-1',
'MEZWIRE-2',
'MEZWIRE-7',
'RMMEZZ2-T',
'RMMEZZ3-T',
'TEAM 1-BOB')  AND  sUBSTRING(CODE,patindex('%-%', code)+1,1) = 3 
GO
