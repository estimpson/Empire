SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [EEIUser].[vw_ST_SalesPersonActivity_OneWeek]
as
select
	h.RowID
,	e.name as SalesPerson
,	sls.Customer
,	sls.Program
,	sls.[Application]
,	convert(varchar, convert(date, sls.SOP)) as SOP
,	replace(convert(varchar, cast(sls.PeakVolume as money),1), '.00', '') as PeakVolume
,	sd.StatusType as [Status]
,	convert(varchar(20), d.ActivityDate, 100) as ActivityDate
,	d.Activity
,	coalesce(d.MeetingLocation, '') as MeetingLocation
,	coalesce(d.ContactName, '') as ContactName
,	coalesce(d.ContactPhoneNumber, '') as ContactPhoneNumber
,	coalesce(d.ContactEmailAddress, '') as ContactEmailAddress
,	case
		when convert(int, (d.Duration / 60)) = 1 and convert(int, (d.Duration % 60)) = 0 then '1 hour'
		when convert(int, (d.Duration % 60)) = 0 then convert(varchar(10), convert(int, (d.Duration / 60))) + ' hours '
		when convert(int, (d.Duration / 60)) = 0 then convert(varchar(10), convert(int, (d.Duration % 60))) + ' minutes'
		when convert(int, (d.Duration / 60)) = 1 then '1 hour ' + convert(varchar(10), convert(int, (d.Duration % 60))) + ' minutes'
		else (convert(varchar(10), convert(int, (d.Duration / 60))) + ' hours ' + 
			convert(varchar(10), convert(int, (d.Duration % 60))) + ' minutes')
	end as Duration
,	coalesce(d.Notes, '') as Notes
,	h.SalesPersonCode
--,	ROW_NUMBER() OVER(ORDER BY d.ActivityDate DESC) AS RowId
from
	eeiuser.ST_LightingStudy_2016 sls
	join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = sls.ID
	join eeiuser.ST_SalesLeadLog_Detail d
		on d.SalesLeadId = h.RowID
	join dbo.employee e
		on e.operator_code = h.SalesPersonCode
	join eeiuser.ST_SalesLeadLog_StatusDefinition sd
		on sd.StatusValue = d.Status
	join 
		(	select
				max(slld.RowModifiedDT) as dt
			from
				EEIUser.ST_SalesLeadLog_Detail slld ) as maxDetail
		on maxDetail.dt = d.RowModifiedDT
where
	d.ActivityDate between dateadd(day, -7, getdate()) and dateadd(day, 1, getdate())
GO
