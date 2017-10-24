SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[sp_process_GMSPO_DELFOR]
as
BEGIN
BEGIN TRANSACTION
DELETE Log
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete m_in_release_plan
COMMIT TRANSACTION

BEGIN TRANSACTION
  DELETE m_in_release_plan_exceptions
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
							ReleaseDate		datetime,
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
	select 	rtrim(delfor_releases_gmspo.buyer_part) as custpart,
			edi_setups.destination,
			rtrim(delfor_releases_gmspo.customer_po),
			'',
			rtrim(delfor_releases_gmspo.release_number),
			(CASE WHEN isNULL(edi_setups.release_flag,'N') = 'F' THEN 'A' ELSE 'N' END),
			convert(decimal(20,6),delfor_releases_gmspo.quantity),
			'S',
			CONVERT ( datetime, rtrim( start_date )) as reldate,
			(CASE WHEN isNULL(edi_setups.release_flag,'N') = 'F' THEN isNULL(convert(decimal(20,6),delfor_cytd_gmspo.cytd_qty_shipped),0) ELSE 0 END)
	 FROM delfor_releases_gmspo
	 	LEFT OUTER JOIN 	edi_setups  ON rtrim(delfor_releases_gmspo.ship_to_id) = edi_setups.parent_destination
	  LEFT OUTER JOIN	delfor_cytd_gmspo  ON rtrim(delfor_releases_gmspo.ship_to_id) = rtrim(delfor_cytd_gmspo.ship_to_id) and rtrim(delfor_releases_gmspo.buyer_part) = rtrim(delfor_cytd_gmspo.buyer_part) and rtrim(delfor_releases_gmspo.release_number) = rtrim(delfor_cytd_gmspo.release_number)
	  
	 where start_date is not null and date_mgo is not null
	 				 
	 
	 order by edi_setups.destination,delfor_releases_gmspo.buyer_part,delfor_releases_gmspo.start_date           
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
			( CASE WHEN QtyQual = 'A' THEN ((Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+CustomerAccum) ELSE Qty END),
			DateType,
			ReleaseDate
	 FROM #releasePlan
	 order by destination, customerpart, ReleaseDate       
COMMIT TRANSACTION

Update	order_header
set			order_header.dock_code = rtrim(delfor_oh_gmspo.dock_code)
FROM 		order_header,
			delfor_oh_gmspo
	 	LEFT OUTER JOIN 	edi_setups  ON rtrim( delfor_oh_gmspo.ship_to_id) = edi_setups.parent_destination
	 WHERE	edi_setups.destination = order_header.destination
	  and rtrim( delfor_oh_gmspo.buyer_part) = order_header.customer_part



BEGIN TRANSACTION
execute msp_process_in_release_plan
COMMIT TRANSACTION


BEGIN TRANSACTION
Delete	delfor_releases_gmspo
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete	delfor_cytd_gmspo
COMMIT TRANSACTION

BEGIN TRANSACTION
Delete	 delfor_oh_gmspo
COMMIT TRANSACTION


SELECT distinct release_no, customer_part, shipto_id, customer_po FROM m_in_release_plan_exceptions
      END
GO
