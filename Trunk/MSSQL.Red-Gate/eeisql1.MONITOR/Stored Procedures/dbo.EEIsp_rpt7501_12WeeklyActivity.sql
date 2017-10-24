SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create procedure [dbo].[EEIsp_rpt7501_12WeeklyActivity] (
	@fromdate		datetime,
	@throughdate		datetime,
	@foreigndest char(1),
	@seventyfiveOone varchar (25) )
as
Begin
	
	Create table #shipped214s
	(serial 		integer,
	part			varchar(25),
	quantity	numeric (20,6),
	shipper	varchar(50),
	twofourteenNo		varchar(50),
	ITNo			varchar(50)
	)
	
	If exists (Select 1 from seventyfiveOones where seventyfiveOone = @seventyfiveOone )
		Begin
			Select		serial,
					part,
					quantity,
					(CASE WHEN isNULL(destination.custom5,'N') = 'N' THEN @seventyfiveOone ELSE shipper END) as seventyfiveNo,
					twofourteenNo,
					ITNo,
					1 as 	received214,
					1 as totalshipped214,
					1 as thiswkshipped214,
					(CASE WHEN destination.custom5 = 'Y' THEN '7512' ELSE '7501' END) as foreignordomestic
	from			 #shipped214s,
					shipper,
					destination
	where		1=0
		RETURN		
	end
	
ELSE	
	
	Begin
		
		insert 	seventyfiveOones
		Select 	@seventyfiveOone,
					GetDate ()
		where	isNULL(@seventyfiveOone, '') > ''

	Insert	 #shipped214s
	select 	serial,
				part,
				quantity,
				shipper,
				custom4,
				custom3
	from		audit_trail
	where	type = 'S' and
				part<> 'PALLET' and
				isNULL(custom4,'')>'' and
				isNULL(custom3,'')>'' and
				date_stamp >= @fromdate and
				date_stamp< dateadd(dd,1,@throughdate)
				
				
	Update		audit_trail
	set			custom2 = @seventyfiveOone
	where		date_stamp > '2005/07/01' and type = 'S' and serial in (select serial from #shipped214s) and
					isNULL(@seventyfiveOone, '')>'' and
					audit_trail.custom2 is NULL 
				
				
	Select		serial,
					part,
					quantity,
					(CASE WHEN isNULL(destination.custom5,'N') = 'N' THEN @seventyfiveOone ELSE shipper END) as seventyfiveNo,
					twofourteenNo,
					ITNo,
					(select sum(quantity) from audit_trail where audit_trail.part = #shipped214s.part and date_stamp > '2005/06/28' and type = 'Z' and custom4 = twofourteenNo) as 	received214,
					(select sum(quantity) from audit_trail where audit_trail.part = #shipped214s.part and date_stamp > '2005/06/28'  and type = 'S' and custom4 = twofourteenNo)  as totalshipped214,
					(select sum(quantity) from audit_trail where audit_trail.part = #shipped214s.part and type = 'S' and custom4 = twofourteenNo and date_stamp >= @fromdate and date_stamp< dateadd(dd,1,@throughdate)) as thiswkshipped214,
					(CASE WHEN destination.custom5 = 'Y' THEN '7512' ELSE '7501' END) as foreignordomestic
	from			 #shipped214s,
					shipper,
					destination
	where		shipper.date_shipped >= @fromdate and
					shipper.date_shipped< dateadd(dd,1,@throughdate) and
					convert(varchar(50),shipper.id) = #shipped214s.shipper and
					shipper.destination = destination.destination and
					isNULL(destination.custom5,'N') = @foreigndest
					
	End
	
End
GO
