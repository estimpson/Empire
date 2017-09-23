SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







/*
	SELECT * 
	FROM MONITOR.HN.DashBoardCycle_GeneralData 
	where week = 16
		  and part = 'PALLET'
*/

CREATE view [HN].[DashBoardCycle_GeneralData] 
as
		Select		a.WeekInYear,
					A.Date_Stamp,
					a.serial,
					a.part,
					a.Quantity,
					a.to_loc,
					a.from_loc,
					a.currentlocation,
					a.TypeG,
					a.TypeH,
					a.TypeShipout,
					a.TypeScrap,					
		total=ps.cost_cum*a.quantity,
		Fis_amount = case when (CurrentLocation like '%fis' OR CurrentLocation like '%-%f' or CurrentLocation like '%lost')
								and TypeH=0 
							then ps.cost_cum*a.quantity else 0 end,
		Good_Amount = case when  (typeh=1 or  TypeShipout=1) or
								(typeh=0 and (CurrentLocation not like '%fis' 
												and CurrentLocation not like '%lost' 
												AND CurrentLocation not like '%-%f'))
							then ps.cost_cum*a.quantity else 0 end,
								
		Scrap_Amount = case when TypeScrap=1 
							then ps.cost_cum*a.quantity else 0 end,
		Lost_Amount = (case when (CurrentLocation like '%fis' or CurrentLocation like '%lost' OR CurrentLocation like '%-%f')
								and TypeH=0 
							then ps.cost_cum*a.quantity else 0 end) + (case when TypeScrap=1 
																		then ps.cost_cum*a.quantity else 0 end),
		a.plant
from	HN.DashboardCycle_Data a
	inner join part_standard ps 
		on ps.part=a.part 

	/*
	SELECT DISTINCT *
				  ,Total_Lost_Amount = ISNULL(Fis_amount,0) + ISNULL(Scrap_lost,0)
				  ,Class  = CASE WHEN RIGHT(Current_location,3) = 'FIS' OR ISNULL(Scrap_lost,0) > 0  
								 THEN 'FIS-SCRAP' 
								 ELSE 'CYCLE OK'
							END 
	FROM ( SELECT a.serial  , a.date_stamp , a.type
				, a.part	, a.quantity
				, a.remarks	, a.from_loc
				, a.to_loc	, ps.cost_cum
				, total=ps.cost_cum*a.quantity
				, Current_location=case when isnull(Obj.location,'N')='N'
										then 'SHIPOUT/SCRAP' 
										else ( Obj.location ) 
									end 
				, year=datepart(yy,a.date_stamp)
				, week=datepart(wk,a.date_stamp)
				, Fis_amount=case when isnull( Obj.location 
												,a.from_loc) like '%FIS' 
								  then  ps.cost_cum*a.quantity 
								  when  isnull(Obj.location,a.from_loc) like '%LOST%'  
								  then  ps.cost_cum*a.quantity  
								  else 0 end
				, Cycle_amount_Good=case when isnull( Obj.location  
													 ,a.from_loc) like '%FIS' 
										 then 0 
										 when  isnull(Obj.location,a.from_loc) like '%LOST%'  
										 then 0  
										 when isnull((select min(d.from_loc) from audit_trail d where d.serial=a.serial and d.type='q' and d.to_loc='s'),'N')<>'N' 
											then 0 
											else ps.cost_cum*a.quantity 
										 end,
				  Scrap_lost=	( select sum(b.quantity*ps1.cost_cum) 
								  from audit_trail b inner join 
										part_standard ps1 on ps1.part=b.part 
								  where		b.serial=a.serial 
										and b.type='q' 
										and b.to_loc='s'
								 )
				,destination= ( select min(l.plant) 
								from location l 
								where l.code=a.from_loc
							  )
			FROM MONITOR.dbo.audit_trail a inner join 
					part_standard ps on ps.part=a.part  left join  
						Monitor.dbo.object Obj ON a.Serial = Obj.Serial 
			WHERE		--(a.date_stamp>='2017/1/1')  
					(	(a.part<>'pallet') 
						AND (a.type='g') 
						and a.from_loc not like '%fis'
						AND (a.date_stamp>='2017/1/1')
					)  
					or (a.serial in (Select  Serial
										FROM (	Select Serial,from_loc,week_no=datepart(wk,max(c.date_stamp)),Qty = 1  
												FROM MONITOR.dbo.audit_trail c
												WHERE		(c.type='g') 
														AND (c.from_loc Not Like '%FIS') 
														AND (c.part='Pallet') 
														AND (c.date_stamp>='2017/1/1')
												group by Serial,from_loc
												--,datepart(wk,max(c.date_stamp))
											UNION ALL 
												Select Serial,from_loc,week_no=datepart(wk,max(c.date_stamp)),Qty = 1 
												FROM MONITOR.dbo.audit_trail c
												WHERE		(c.type='h') 
														AND (c.from_loc Not Like '%FIS') 
														AND (c.part='Pallet') 
														AND (c.date_stamp>='2017/1/1')			
												group by Serial,from_loc
												--,datepart(wk,max(c.date_stamp))
											) xPallet
										Group by Serial,from_loc,week_no
										Having SUM(Qty) >= 2
									 )
									 AND (a.type in ('g'))
									 and a.from_loc not like '%fis'
									 
									 )
					--AND a.Serial in  (35648357,34740102)
		) as detail_cc inner join
			 (	SELECT loc_qty = SUM(loc_qty), year1,week_no
			    FROM (		SELECT loc_qty=count(DISTINCT c.from_loc), year1=(datepart(yy,c.date_stamp)), 
								   week_no=datepart(wk,c.date_stamp)
							FROM MONITOR.dbo.audit_trail c
							WHERE  (c.type='g') AND (c.from_loc Not Like '%FIS') 
							AND (c.part<>'Pallet') 
									AND (c.date_stamp>='2017/1/1')
							group by datepart(yy,c.date_stamp),datepart(wk,c.date_stamp)
						UNION ALL 
							Select loc_qty = count(DISTINCT from_loc), year1, 
									week_no
							FROM ( Select Serial,from_loc,year1,week_no
									FROM (	Select Serial,from_loc,week_no=datepart(wk,c.date_stamp),year1=(datepart(yy,c.date_stamp)),Qty = Count(1) 
											FROM MONITOR.dbo.audit_trail c
											WHERE		(c.type='g') 
													AND (c.from_loc Not Like '%FIS') 
													AND (c.part='Pallet') 
													AND (c.date_stamp>='2017/1/1')
											group by Serial,from_loc,datepart(wk,c.date_stamp),datepart(yy,c.date_stamp)
										UNION ALL 
											Select Serial,from_loc,week_no=datepart(wk,c.date_stamp),year1=(datepart(yy,c.date_stamp)),Qty =Count(1) 
											FROM MONITOR.dbo.audit_trail c
											WHERE		(c.type='h') 
													AND (c.from_loc Not Like '%FIS') 
													AND (c.part='Pallet') 
													AND (c.date_stamp>='2017/1/1')			
											group by Serial,from_loc,datepart(wk,c.date_stamp),datepart(yy,c.date_stamp)
										) xPallet
									Group by Serial,from_loc,year1,week_no
									Having SUM(Qty) >= 2
								 ) Info  
								 GROUP BY year1,week_no	) xSummary	
								GROUP BY year1,week_no						 
			 ) as  summary on (summary.week_no=detail_cc.week and summary.year1=detail_cc.year)	
			 */







GO
