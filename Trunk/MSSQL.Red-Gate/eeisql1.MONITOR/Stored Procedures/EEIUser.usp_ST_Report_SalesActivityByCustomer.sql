SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [EEIUser].[usp_ST_Report_SalesActivityByCustomer]
	@Customer varchar(50)
as
set nocount on
set ansi_warnings on;

--- <Body>
with cte_Header (RowID, ActivityDate) as 
(
select
	h.RowID
,	max(d.ActivityDate) as ActivityDate
from
	eeiuser.ST_LightingStudy_2016 sls
	join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = sls.ID
	join eeiuser.ST_SalesLeadLog_Detail d
		on d.SalesLeadId = h.RowID
where
	d.ActivityDate between dateadd(day, -30, getdate()) and dateadd(day, 1, getdate())
group by
	h.RowID
)

select
	h.RowID
,	h.CombinedLightingId
,	e.name as SalesPerson
,	sls.Customer
,	sls.Program
,	sls.[Application]
,	sls.BulbType
,	sls.Region
,	convert(varchar, convert(date, sls.SOP)) as SOP
,	convert(varchar, convert(date, sls.EOP)) as EOP
,	sls.PeakVolume
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
,	sls.AwardedVolume
,	sls.OEM
,	sls.NamePlate
,	h.SalesPersonCode
--,	ROW_NUMBER() OVER(ORDER BY d.ActivityDate DESC) AS RowId
from
	eeiuser.ST_LightingStudy_2016 sls
	join eeiuser.ST_SalesLeadLog_Header h
		on h.CombinedLightingId = sls.ID
	join eeiuser.ST_SalesLeadLog_Detail d
		on d.SalesLeadId = h.RowID
	join dbo.employee e
		on e.operator_code = d.SalesPersonCode
	join eeiuser.ST_SalesLeadLog_StatusDefinition sd
		on sd.StatusValue = d.Status
	join cte_Header cte
		on cte.RowID = h.RowID
		and cte.ActivityDate = d.ActivityDate
where
	sls.Customer = @Customer
--- </Body>
GO
