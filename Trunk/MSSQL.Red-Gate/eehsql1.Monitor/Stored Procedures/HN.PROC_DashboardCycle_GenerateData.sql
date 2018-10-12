SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--EXEC [HN].[PROC_DashboardCycle_GenerateData] 'EEA','2017'


CREATE Proc [HN].[PROC_DashboardCycle_GenerateData](
	@Plant as varchar(5),
	@YearToReview as int)
AS
BEGIN

	Delete
	from HN.DashboardCycle_Data
	where	plant= @Plant


Insert into HN.DashboardCycle_Data (WeekInYear, Date_Stamp, Serial, Part, Quantity, To_Loc, from_loc, CurrentLocation, TypeG, TypeH, TypeShipout, TypeScrap ,Plant)
Select	WeekInYear = datepart(week,convert(date,Max(date_stamp))),
		date_stamp = convert(date,Max(date_stamp)), 
		Serial, 
		Part, 
		Quantity, 
		to_loc, 
		from_loc,
		CurrentLocation = (Select Location
							from object
							where	serial = audit_trail.serial),
		TypeG=1,
		TypeH=0,
		TypeShipout= (select max(1)
						from audit_trail a with (readuncommitted)
						where	a.serial =audit_trail.serial
							and (type='S' or type='M')
							and a.date_stamp>=convert(date,Max(audit_trail.date_stamp))),
		TypeScrap = 0,
		@Plant
from	audit_trail with (readuncommitted)
where	(type = 'G'
	and datepart(year,date_stamp)=@yeartoreview
	and plant= @Plant)
	AND (PART<>'pALLET' OR Custom2='Cycle-PutAway')		
group by  Serial, Part, Quantity, to_loc, from_loc

update HN.DashboardCycle_Data
set	Date_Stamp_original  =audit_trail.date_stamp_o
from HN.DashboardCycle_Data Data
	inner join (Select Serial,
						date_stamp_o = Max(date_stamp),
						Date_stamp= Convert(date,max(Date_stamp))
				from	audit_trail with (readuncommitted)
				where	(type = 'G'
					and datepart(year,date_stamp)=@yeartoreview
					and plant= @Plant)
				group by Serial) audit_trail
	on data.Serial = audit_trail.serial
		and data.date_stamp= audit_trail.Date_stamp


update	HN.DashboardCycle_Data
Set		TypeH =1
from	HN.DashboardCycle_Data tblAuditTrail
	inner join (
			--Select	Serial, Date_stamp= Convert(date,max(Date_stamp))
			Select	Serial, Date_stamp= max(Date_stamp)
			from	audit_trail with (readuncommitted)
			where	(type = 'h'
				and datepart(year,date_stamp)=@yeartoreview
				AND (PART<>'pALLET' OR Custom2='Cycle-PutAway'))					
			group by Serial) TypeH
		on tblAuditTrail.Serial = typeH.serial
			and TypeH.date_stamp>=tblAuditTrail.date_stamp_Original
			--and TypeH.date_stamp>=tblAuditTrail.date_stamp
			
			
update	HN.DashboardCycle_Data
Set		TypeScrap =1
from	HN.DashboardCycle_Data tblAuditTrail
	inner join (
			Select	Serial
			from	audit_trail with (readuncommitted)
			where	(type = 'E'
						and to_loc='S')
				
			) TypeH
		on tblAuditTrail.Serial = typeH.serial
			and tblAuditTrail.typeh=0
			
END
GO
