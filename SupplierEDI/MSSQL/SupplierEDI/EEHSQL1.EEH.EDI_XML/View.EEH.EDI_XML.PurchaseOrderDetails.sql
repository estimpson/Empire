
/*
Create View.EEH.EDI_XML.PurchaseOrderDetails.sql
*/

use EEH
go

--drop table EDI_XML.PurchaseOrderDetails
if	objectproperty(object_id('EDI_XML.PurchaseOrderDetails'), 'IsView') = 1 begin
	drop view EDI_XML.PurchaseOrderDetails
end
go

create view EDI_XML.PurchaseOrderDetails
with encryption
as
with
	FDW
	(	FirstDayOfWeek
	)
	as
	(	select
			FirstDayOfWeek = dateadd ( day, datediff ( day, '2001-01-01', dateadd ( day, 1 - ( datepart ( dw, getdate () ) ), getdate () ) ), '2001-01-01' )
	)
,	WK
	(	PurchaseOrderNumber
	,	VendorCode
	,	EmpireBlanketPart
	,	VendorDeliveryDay
	,	FirmWeeks
	,	PlanWeekToDisplayEDI
	,	PlanWeeks
	)
	as
	(	select
			FD.PurchaseOrderNumber
		,	FD.VendorCode
		,	FD.EmpireBlanketPart
		,	VDD.VendorDeliveryDay
		,	FirmWeeks =
				case
					when FD.FirmDays%7 + 1 <= VDD.VendorDeliveryDay then floor(FD.FirmDays / 7)
					else 1 + floor(FD.FirmDays / 7)
				end
		,	PWTD.PlanWeekToDisplayEDI
		,	PlanWeeks =
				case
					when PWTD.PlanWeekToDisplayEDI = 0 then
						case when TW.TotalWeeks > 0 then TW.TotalWeeks else 26 end
					else
						case
							when FD.FirmDays%7 + 1 <= VDD.VendorDeliveryDay then floor(FD.FirmDays / 7)
							else 1 + floor(FD.FirmDays / 7)
						end + PWTD.PlanWeekToDisplayEDI + 1
				end
		from
			(	select
					PurchaseOrderNumber = ph.po_number
				,	VendorCode = ph.vendor_code
				,	EmpireBlanketPart = ph.blanket_part
				,	FirmDays =
						case
							when ph.vendor_code = 'TTI' then 7
							when pv.FABAuthDays > 0 then pv.FABAuthDays
							else 14
						end
				from
					dbo.po_header ph
					join dbo.part_vendor pv
						on pv.vendor = ph.vendor_code
						and pv.part = ph.blanket_part
			) FD
			join
				(	select
						VendorCode = vc.code
					,	VendorDeliveryDay =
							coalesce(case when custom4 like '[0-7]' then convert(integer, custom4) end, 2)
					from
						dbo.vendor_custom vc
				) VDD
				on VDD.VendorCode = FD.VendorCode
			join
				(	select
						VendorCode = v.code
					,	PlanWeekToDisplayEDI = coalesce(v.PlanWeekToDisplayEDI, 0)
					from
						dbo.vendor v
				) PWTD
				on PWTD.VendorCode = FD.VendorCode
			join
				(	select
						VendorCode = ev.vendor
					,	TotalWeeks = coalesce(ev.total_weeks, 0)
					from
						dbo.edi_vendor ev
				) TW
				on TW.VendorCode = FD.VendorCode
	)
select
	WK.PurchaseOrderNumber
,	WK.VendorCode
,	WK.FirmWeeks
,	WK.PlanWeekToDisplayEDI
,	WK.PlanWeeks
,	WKS.WeekNo
,	SchedType = case when WKS.WeekNo <= WK.FirmWeeks then 'C' else 'D' end
,	Quantity = coalesce
		(	(	select
					convert(int, sum(pd.balance))
				from
					dbo.po_detail pd
				where
					pd.po_number = WK.PurchaseOrderNumber
					and pd.part_number = WK.EmpireBlanketPart
					and
					(	coalesce(pd.deleted, 'N') != 'Y'
						or pd.received > 0
					)
					and
					(	datediff(wk, FDW.FirstDayOfWeek, pd.date_due) = WKS.WeekNo
						or
						(	pd.date_due < FDW.FirstDayOfWeek
							and WKS.WeekNo = 0
						)
					)
			)
		,	0
		)
,	DueDT = convert(char(6), FDW.FirstDayOfWeek + WKS.WeekNo * 7 + WK.VendorDeliveryDay - 1, 12)
from
	WK
	cross apply
		(	select
				WeekNo = ur.RowNumber - 1
			from
				dbo.udf_Rows(WK.PlanWeeks) ur
		) WKS
	cross join FDW
go

select
	*
from
	EDI_XML.PurchaseOrderDetails pod
where
	pod.PurchaseOrderNumber = 41340
order by
	pod.WeekNo