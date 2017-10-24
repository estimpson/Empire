SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE procedure [FT].[ftsp_EDISaveTRWReleasePlan]
as
declare	@RPID int

insert	FT.CustReleasePlans
(	RPDate,
	Description)
select	GetDate(),
	'Created by Executor EDI Process.'

select	@RPID = scope_identity ()

/*
insert	FT.CustReleasePlanRaw
(	RPID,
	RPDocument)
select	RPID = @RPID,
	RPDocument = ''

select	*
from	FT.CustReleasePlans

select	*
from	FT.CustReleasePlanDetails

select	*
from	FT.CustReleasePlanDetailDates


begin transaction

create table #output
(	output varchar (255))

insert	#output
EXEC master..xp_cmdshell 'OSQL -Ueric -P /Q"select * from monitor..raw_830_release select * from monitor..raw_830_shp"'

declare	@output varchar (255)

declare	output cursor local for
select	output
from	#output

open	output

fetch	output
into	@output

while	@@fetch_status = 0 begin
	update	FT.CustReleasePlanRaw
	set	RPDocument = RPDocument + @output
	where	RPID = @RPID

	fetch	output
	into	@output
end

drop table #output
commit
*/

insert	FT.CustReleasePlanDetails
(	RPID,
	ShipTo,
	CustomerPart,
	CustomerPO,
	ModelYear,
	SalesOrderNo,
	LastShipper,
	LastShipDate,
	LastShippedAccum)
select	RPID,
	ShipTo,
	CustomerPart,
	CustomerPO,
	ModelYear,
	SalesOrderNo =
	(	select	max (oh.order_no)
		from	order_header oh
		where	oh.customer_part = CustomerPart and
			oh.destination = Destination and
			(	oh.customer_po = CustomerPO or
				isnull (CheckPO, 'N') != 'Y') and
			(	oh.model_year = ModelYear or
				isnull (CheckModelYear, 'N') != 'Y')),
	LastShipper,
	LastShipDate,
	LastShippedAccum
from	(	select	RPID = @RPID,
			ShipTo = rtrim (raw_830_release.n104_1),
			CustomerPart = rtrim (raw_830_release.lin03),
			CustomerPO = rtrim (raw_830_release.lin05),
			ModelYear = '',
			LastShipper = null,
			LastShipDate = null,
			LastShippedAccum = null,
			Destination = min (edi_setups.destination),
			CheckPO = min (edi_setups.check_po),
			CheckModelYear = min (edi_setups.check_model_year)
		from	raw_830_release
			left join edi_setups on rtrim (raw_830_release.n104_1) = edi_setups.parent_destination
		group by
			rtrim (raw_830_release.n104_1),
			rtrim (raw_830_release.lin03),
			rtrim (raw_830_release.lin05)) ReleaseDetails

insert	FT.CustReleasePlanDetailDates
(	RPDID,
	DateQualifier,
	ReleaseDate,
	QuantityQualifier,
	Quantity)
select	RPDID,
	DateQualifier = 'S',
	ReleaseDate = convert (datetime, fst04),
	QuantityQualifier = bfr_sched_qty_type,
	Quantity = convert (decimal (20,6),raw_830_release.fst01)
from	FT.CustReleasePlanDetails CustReleasePlanDetails
	left join raw_830_release on CustReleasePlanDetails.ShipTo = rtrim (raw_830_release.n104_1) and
		isnull (CustReleasePlanDetails.CustomerPart, '') = isnull (rtrim (raw_830_release.lin03), '') and
		isnull (CustReleasePlanDetails.CustomerPO, '') = isnull (rtrim (raw_830_release.lin05), '')
where	CustReleasePlanDetails.RPID = @RPID

GO
