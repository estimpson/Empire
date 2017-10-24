SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_ST_Reports_GetSalesForecastData]
	@LightingStudyCustomer varchar(50)
,	@TranDT datetime = null out
,	@Result integer = null  out
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDIStanley.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>


--- <Body>
select 
	sf.customer as Customer, 
	sum(sf.Cal_16_Sales) as Sales_2016,
	sum(sf.Cal_17_Sales) as Sales_2017,
	sum(sf.Cal_18_Sales) as Sales_2018,
	sum(sf.Cal_19_Sales) as Sales_2019,
	sum(sf.Cal_20_Sales) as Sales_2020,
	sum(sf.Cal_21_Sales) as Sales_2021,
	sum(sf.Cal_22_Sales) as Sales_2022
from 
	eeiuser.acctg_csm_vw_select_sales_forecast sf
where 
	sf.parent_customer in 
		(	select
				sf.SalesForecastParentCustomer
			from 
				EEIUser.ST_SalesForecastParentCustomers sf
			where
				sf.LightingStudyCustomer = @LightingStudyCustomer
				and sf.SalesForecastParentCustomer is not null )
group by 
	sf.customer
order by 
	sf.customer
--- </Body>


---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>
GO
