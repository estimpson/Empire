SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE Procedure [HN].[GastosPorDia]
(
	@Mes Int
)
/*
	exec HN.GastosPorDia
	@Fecha='2015-01-11'

*/
as
set nocount on
declare	@ProcName sysname
	

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran required=Yes autoCreate=Yes tranDTParm=Yes>
declare	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
create table  #DataNew 
(
	Posting_Account varchar(50),
	Center_Cost varchar(50),
	Account_Description varchar(100),
	TranDT datetime,
	Costo numeric(18,2)
	)

insert into #DataNew
SELECT		Posting_Account = viewGL_Cost_TransactionsItems.Ledger_Account, CenterCost = LO.organization_description, AI.Account_Description, viewGL_Cost_TransactionsItems.transaction_date,
			Sum(viewGL_Cost_TransactionsItems.Amount) AS Costo
FROM        viewGL_Cost_TransactionsItems AS viewGL_Cost_TransactionsItems 
			INNER JOIN ledger_organizations AS LO ON LO.organization = viewGL_Cost_TransactionsItems.CenterCost
			LEFT JOIN dbo.chart_of_account_items AI ON LEFT(viewGL_Cost_TransactionsItems.Ledger_Account, 4) = AI.Account AND viewGL_Cost_TransactionsItems.Fiscal_Year = AI.Fiscal_Year AND AI.Coa = 'EEI Master'
WHERE        (viewGL_Cost_TransactionsItems.dr_posting_account IN (select Ledger_Account FROM EEH.dbo.Ledger_Accounts_ForReport)) AND month(viewGL_Cost_TransactionsItems.transaction_date) = @Mes AND YEAR(viewGL_Cost_TransactionsItems.transaction_date) = year(GETDATE())
GROUP BY viewGL_Cost_TransactionsItems.Ledger_Account, LO.organization_description, AI.Account_Description, viewGL_Cost_TransactionsItems.transaction_date
order by viewGL_Cost_TransactionsItems.transaction_date asc

declare @columnas varchar(max)

set @columnas = ''

select @columnas =  coalesce(@columnas + '[' + cast(TranDT as varchar(12)) + '],', '')
FROM (select distinct TranDT from #DataNew) as DTM

set @columnas = left(@columnas,LEN(@columnas)-1)

--select @columnas

declare @dynamic_pivot_query as varchar(max)

DECLARE @SQLString nvarchar(500);

set @dynamic_pivot_query = N'
SELECT *
FROM
(SELECT *
    FROM  #DataNew) AS SourceTable
PIVOT
(
SUM(Costo)
FOR TranDT IN (' + @columnas + ')
) AS PivotTable;'

--set @dynamic_pivot_query = 'select * from #DataNew 
--pivot 
--(avg(Costo) for TranDT in (' + @columnas + ')
--) p1
--'

exec(@dynamic_pivot_query)

--select * from #DataNew 
drop table #DataNew 
--//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>



GO
