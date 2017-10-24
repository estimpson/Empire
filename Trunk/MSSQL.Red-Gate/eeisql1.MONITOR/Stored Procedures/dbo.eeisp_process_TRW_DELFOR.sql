SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[eeisp_process_TRW_DELFOR]

as
BEGIN
BEGIN TRANSACTION
DELETE Log
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete m_in_release_plan
COMMIT TRANSACTION

Create table #releasePlan (
							lineid	integer identity,
							customerpart	varchar (35),
							destination		varchar (20),
							customerPO		varchar	(20),
							modelYear			varchar	(4),
							ReleaseNumber	varchar(30),
							QtyQual				char(1),
							Qty						numeric(20,6),
							DateType			char(1),
							ReleaseDate		DATETIME,
							CustomerAccum	numeric (20,6))
							
BEGIN TRANSACTION
insert #releasePlan( customerpart	,
							destination		,
							customerPO		,
							modelYear			,
							ReleaseNumber	,
							QtyQual				,
							Qty						,
							DateType			,
							ReleaseDate		,
							customerAccum		)
	select 	rtrim(raw_830_release.lin03) as custpart,
			edi_setups.destination,
			rtrim(raw_830_release.lin05),
			'',
			rtrim(raw_830_release.bfr_rel),
			'A',
			convert(decimal(20,6),raw_830_release.fst01),
			'S',
			dateadd(dd, -1*isNULL (edi_setups.id_code_type,0),convert(DATETIME,fst04)) as reldate,
			isNULL(convert(decimal(20,6),raw_830_shp.auth_to_ship_qty),0)
	 FROM "raw_830_release"
	 	LEFT OUTER JOIN 	"edi_setups"  ON rtrim("raw_830_release"."n104_1") = "edi_setups"."parent_destination"
	  LEFT OUTER JOIN	"raw_830_shp"  ON rtrim("raw_830_release"."n104_1") = rtrim("raw_830_shp"."n104_1") and rtrim("raw_830_release"."lin03") = rtrim("raw_830_shp"."lin03") and rtrim("raw_830_release"."bfr_rel") = rtrim("raw_830_shp"."bfr_rel")
	  
	 WHERE rtrim(isNULL(raw_830_release.bfr_sched_qty_type,'2')) not in ('2','3')  and   
	 				rtrim(raw_830_shp.bfr_sched_qty_type) = '7'   and
	 				rtrim(raw_830_shp.udf9) = '52'
	 				 
	 
	 order by edi_setups.destination,custpart,reldate           
COMMIT TRANSACTION 			

BEGIN TRANSACTION
insert m_in_release_plan (customer_part,
													shipto_id,
													customer_po,
													model_year,
													release_no,
													quantity_qualifier,
													quantity,
													release_dt_qualifier,
													release_dt)
	select 	customerpart,
			destination,
			customerPO,
			ModelYear,
			ReleaseNumber,
			QtyQual,
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+CustomerAccum,
			DateType,
			ReleaseDate
	 FROM #releasePlan
	 order by destination, customerpart, ReleaseDate       
COMMIT TRANSACTION

Update	order_header
set			custom01 = rtrim(udf2)
FROM 		"raw_830_order"
	 	LEFT OUTER JOIN 	"edi_setups"  ON rtrim("raw_830_order"."n104_1") = "edi_setups"."parent_destination"
	  JOIN	"order_header"   ON edi_setups.destination = order_header.destination
	  WHERE rtrim(raw_830_order.udf1) = order_header.customer_part

--BEGIN TRANSACTION
--insert m_in_release_plan
--	select 	rtrim(raw_830_release.lin03),
--			edi_setups.destination,
--			rtrim(raw_830_release.lin05),
--			'',
--			rtrim(raw_830_release.bfr_rel),
--			'A',
--			isNULL(convert(decimal(20,6),raw_830_shp.auth_to_ship_qty),0)+convert(decimal(20,6),raw_830_release.fst01),
--			'S',
--		dateadd(dd, -1*isNULL (edi_setups.id_code_type,0),convert(timestamp,fst04))
--	 FROM "raw_830_release"
--	 LEFT OUTER JOIN	"raw_830_shp"  ON rtrim("raw_830_release"."n104_1") = rtrim("raw_830_shp"."n104_1") and rtrim("raw_830_release"."lin03") = rtrim("raw_830_shp"."lin03") and rtrim("raw_830_release"."bfr_rel") = rtrim("raw_830_shp"."bfr_rel")
--	 LEFT OUTER JOIN 	"edi_setups"  ON rtrim("raw_830_release"."n104_1") = "edi_setups"."parent_destination"
--	 WHERE rtrim(isNULL(raw_830_release.bfr_sched_qty_type,'2')) not in ('2','3')  and   rtrim(raw_830_shp.bfr_sched_qty_type) = '7'            
--COMMIT TRANSACTION 

execute	FT.ftsp_EDISaveTRWReleasePlan

BEGIN TRANSACTION
execute msp_process_in_release_plan
COMMIT TRANSACTION


BEGIN TRANSACTION
Delete	raw_830_release
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete	raw_830_shp
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete	raw_830_order
COMMIT TRANSACTION

--Begin Transaction
--Update	order_header
--set	fab_cum = convert (decimal (20,6),ath03),
--	fab_date = convert (timestamp, ath02)
--from	order_header,
--	raw_830_auth
--where order_header.destination = rtrim(raw_830_auth.N104_2) and
--	order_header.customer_part = rtrim(raw_830_auth.lin03) and
--	rtrim(raw_830_auth.ath01) = 'FI'
--	
--Commit transaction
--
--Begin Transaction
--Update	order_header
--set	raw_cum = convert (decimal (20,6),ath03),
--	raw_date = convert (timestamp, ath02)
--from	order_header,
--	raw_830_auth
--where order_header.destination = rtrim(raw_830_auth.N104_2) and
--	order_header.customer_part = rtrim(raw_830_auth.lin03)and
--	rtrim(raw_830_auth.ath01) = 'MT'
--Commit transaction
--
--BEGIN TRANSACTION
--DELETE	raw_830_auth
--COMMIT TRANSACTION


SELECT DISTINCT "message" from log
   WHERE "message" like 'Blanket order does%'
END
GO
