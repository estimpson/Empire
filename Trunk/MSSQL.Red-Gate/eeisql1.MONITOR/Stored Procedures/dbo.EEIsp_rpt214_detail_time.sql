SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[EEIsp_rpt214_detail_time] (	@fromdate datetime, @throughdate datetime )
as
Begin
	
	Create table #214s_in
	(serial 				integer,
	part					varchar(25),
	quantity			numeric (20,6),
	datereceived	datetime,
	twofourteen		varchar(50)
	)
	
	Create table #214s_out
	(serial 				integer,
	part					varchar(25),
	quantity			numeric (20,6),
	dateout			datetime,
	ITNo					varchar(50),
	twofourteen   	varchar(50)
	)
	
	CREATE INDEX indx_214In

			ON #214s_in
		( twofourteen )
		
		CREATE INDEX indx_214Inserial

			ON #214s_in
		( serial )
		
		CREATE INDEX indx_214OutSerial

			ON #214s_out
		( serial )
	
	
	Insert	#214s_in
	Select	serial,
				part,
				std_quantity,
				date_stamp,
				custom4
	from		audit_trail
	Where	part <> 'PALLET' and type = 'Z' and
				date_stamp >= @fromdate and
				date_stamp < dateadd(dd,1, @throughdate)
				
	Insert	#214s_out
	Select	serial,
				part,
				std_quantity,
				date_stamp,
				custom2,
				custom4
	from		audit_trail
	Where	type in ( 'S', 'D', 'V') and status <> 'S' and
				custom4 in (Select distinct twofourteen from #214s_in)and
				date_stamp >=  @fromdate
				
	Insert	#214s_out
	Select	serial,
				part,
				std_quantity,
				date_stamp,
				custom2,
				custom4
	from		audit_trail
	Where	type = 'Q' and
				custom4 in (Select distinct twofourteen from #214s_in) and
				status = 'S' and
				date_stamp < dateadd(dd,1, @throughdate)
				
	Select 			distinct #214s_in.serial  as Serialin,
					#214s_in.part partin,
					#214s_in.quantity as qtyin,
					#214s_in.datereceived as datein,
					#214s_out.serial as serialout ,
					#214s_out.part as partout,
					#214s_out.quantity as qtyout,
					#214s_out.dateout as datoutsystem,
					part_standard.cost,
					part_standard.price,
					ITNo,
					#214s_in.twofourteen,
					#214s_out.twofourteen
	from			#214s_in
					left join #214s_out
						on #214s_in.serial = #214s_out.serial
					join part_standard
						on #214s_in.part = part_standard.part
					
								
		

UNION

Select 			distinct NULL  as Serialin,
					NULL as partin,
					NULL as qtyin,
					NULL as datein,
					#214s_out.serial as serialout ,
					#214s_out.part as partout,
					#214s_out.quantity as qtyout,
					#214s_out.dateout as datoutsystem,
					part_standard.cost,
					part_standard.price,
					ITNo,
					#214s_out.twofourteen,
					#214s_out.twofourteen
	from			#214s_out,
					part_standard
	where		#214s_out.serial not in (select #214s_in.serial from #214s_in) and
					#214s_out.part = part_standard.part
								
		order by 
		11,
		2,
		1				
	
	
End
GO
