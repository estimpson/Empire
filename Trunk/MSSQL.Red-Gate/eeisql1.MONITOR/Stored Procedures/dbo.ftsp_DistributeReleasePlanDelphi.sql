SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE  procedure [dbo].[ftsp_DistributeReleasePlanDelphi]
as
/*
Assertions:
1) EDI must contain "Net" quantities because if we are shipping against other orders, the accums will get out of "whack."
2) Customer must only send 830's, otherwise we should be focussing on splitting 862's.
3) Release dates are shipping dates.
4) Exactly one part will be marked as the CurrentRevLevel.
5) Only one blanket order will exist for any revision.
*/
--begin transaction ProcessReleasePlan

--delete	log
--where	spid = @@spid

/*
insert	log
(	spid,
	id,
	message )
select	@@spid,
	(	select	isnull (max (id), 0) + 1
		from	log
		where	spid = @@spid),
	'Log purged successfully.'
*/
--execute ftsp_LogComment
--	@Comment = 'Log purged successfully.'


--execute ftsp_LogBegin --'Start processing ' + convert ( varchar ( 20 ), getdate ( ) ) + '.'
--	@StartDT = GetDate()

--execute ftsp_LogComment
--	@Comment = 'Searching for blanket order for customer part :  (' + @customerpart + ', destination :' + @shipto + ', customer po :' + @customerpo + ' & model year :'+ @modelyear+'.  Processing release #  (' + @releaseno+') due ' + convert ( varchar(20), @releasedt, 113) + '.'

--Clear API table
TRUNCATE TABLE m_in_release_plan
							
Create table #CumulativereleasePlan (
							lineid			integer identity,
							customerpart	varchar (35),
							destination		varchar (20),
							customerPO		varchar	(20),
							modelYear		varchar	(4),
							ReleaseNumber	varchar(30),
							QtyQual			char(1),
							Qty				numeric(20,6),
							DateType		char(1),
							ReleaseDate		DATETIME,
							Accum			numeric (20,6),
							CustomerAccum	numeric (20,6),
							EmpireAccum		numeric (20,6))
							
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
						

insert #releasePlan(		customerpart	,
							destination		,
							customerPO		,
							modelYear			,
							ReleaseNumber	,
							QtyQual				,
							Qty						,
							DateType			,
							ReleaseDate		,
							customerAccum		)
	
	
	
	select 	Raw830Release.CustomerPart,
				COALESCE(InternalDestination, Raw830Release.ShipToID) ShipToID,
				ISNULL(CustomerPO,'') CustomerPO,
				'' AS ModelYear,
				Raw830Release.CustomerRelease,
				'N',
				Raw830Release.ReleaseQty,
				'S',		
				DATEADD(dd, -1*ISNULL(TransitDays,0), Raw830Release.ReleaseDate),
				ISNULL( CustomerAccumReceived,0) AS CustomerAccum
	 FROM (		SELECT	RTRIM(n104_1) AS ShipToID,
								rtrim(lin03) AS CustomerPart,
								rtrim(bfr_rel) AS  CustomerRelease,
								convert(numeric(20,6),fst01) AS ReleaseQty,
								convert(datetime,fst04) AS ReleaseDate
									
					FROM	"raw_830_release"
					WHERE	RTRIM(Fst02) = '1' AND 
								RTRIM(Fst03) = '10' 
				)		Raw830Release
				
	LEFT JOIN		(	SELECT	DISTINCT RTRIM(n104_1)AS ShipToID,
								RTRIM(lin03) AS CustomerPart,
								RTRIM(udf2) AS CustomerPO
					FROM	raw_830_order
					WHERE	RTRIM(udf1) = 'ON'
				)		Raw830CustomerPO ON Raw830Release.ShipToID=Raw830CustomerPO.ShipToID AND Raw830Release.CustomerPart = Raw830CustomerPO.CustomerPart
				
	LEFT JOIN	(	SELECT	RTRIM(n104_1)AS ShipToID,
									RTRIM(lin03) AS CustomerPart,
									CONVERT(numeric(20,6), last_ship_qty) AS CustomerAccumReceived
						FROM	raw_830_shp
						WHERE	RTRIM(bfr_sched_qty_type) = '70'
				)		Raw830Accum ON Raw830Release.ShipToID=Raw830Accum.ShipToID AND Raw830Release.CustomerPart = Raw830Accum.CustomerPart
						
	CROSS JOIN ( SELECT MAX(destination) AS InternalDestination,
									 MAX(id_code_type) AS TransitDays
							FROM	dbo.edi_setups
							WHERE	edi_setups.parent_destination = (Select MAX(RTRIM(n104_1)) FROM dbo.raw_830_release)  ) ShipTo
				
	
ORDER BY 1,2,9

INSERT #CumulativereleasePlan
        ( customerpart ,
          destination ,
          customerPO ,
          modelYear ,
          ReleaseNumber ,
          QtyQual ,
          Qty ,
          DateType ,
          ReleaseDate ,
          Accum ,
          CustomerAccum ,
          EmpireAccum
        )

	select 	customerpart,
			destination,
			customerPO,
			ModelYear,
			ReleaseNumber,
			QtyQual,
			Qty,
			DateType,
			ReleaseDate,
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid),
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+COALESCE(CustomerAccum,0),
			(Select sum(Qty) from #releasePlan RP2 
				where RP2.customerPart = #releasePlan.customerPart and 
							RP2.destination = #ReleasePlan.destination  and 
							RP2.lineid <= #releasePlan.lineid)+COALESCE((SELECT	MIN(order_header.our_cum )
																FROM	order_header 
																JOIN	part_eecustom ON order_header.blanket_part = part_eecustom.part 
																WHERE	ISNULL(NULLIF(order_header.status,''),'C') = 'A' AND 
																		order_header.customer_part = #releasePlan.CustomerPart AND
																		order_header.destination = #releasePlan.destination), CustomerAccum,0)
	 FROM #releasePlan
	 order by destination, customerpart, ReleaseDate       
DELETE	#CumulativereleasePlan
WHERE	(Accum-(EmpireAccum-CustomerAccum))<=0



UPDATE	#CumulativereleasePlan
SET		#CumulativereleasePlan.Qty = (#CumulativereleasePlan.Accum-(#CumulativereleasePlan.EmpireAccum-#CumulativereleasePlan.CustomerAccum))
FROM	#CumulativereleasePlan
JOIN	(SELECT MIN(lineid)FIRSTLINEID
				 FROM	#CumulativereleasePlan
				 GROUP BY	customerpart,
							destination) FIRSTROWCRP ON #CumulativereleasePlan.Lineid =FIRSTROWCRP.FIRSTLINEID






INSERT	dbo.m_in_release_plan
        ( customer_part ,
          shipto_id ,
          customer_po ,
          model_year ,
          release_no ,
          quantity_qualifier ,
          quantity ,
          release_dt_qualifier ,
          release_dt
        )
SELECT	customerpart,
		destination,
		customerPO,
		modelYear,
		ReleaseNumber,
		'N',
		Qty,
		'S',
		ReleaseDate
FROM	#CumulativereleasePlan

 
UPDATE		dbo.order_header
SET			dock_code = DockCode,
				line_feed_code = LineFeed,
				zone_code =UltimateDelphiPart
			
FROM 

order_header	

JOIN ( SELECT	DISTINCT
						COALESCE(es2.Destination , es1.destination) AS Destination,
						rtrim(N104_1) AS ShipToID
			FROM	raw_830_release
					LEFT JOIN  edi_setups es1 ON  RTRIM(n104_1) = es1.parent_destination
					LEFT JOIN  edi_setups es2 ON  RTRIM(n104_1) = es2.destination
					) ShipTo ON order_header.destination = ShipTo.Destination
JOIN		

(SELECT	RTRIM(n104_1)AS ShipToID,
			RTRIM(lin03) AS CustomerPart,
			RTRIM(udf2) AS DockCode
FROM	raw_830_order
WHERE	RTRIM(udf1) = '11')  DockCode ON Order_header.customer_part = DockCode.CustomerPart AND ShipTo.ShipToID = DockCode.ShipToID

JOIN  

(SELECT	RTRIM(n104_1)AS ShipToID,
			RTRIM(lin03) AS CustomerPart,
			RTRIM(udf2) AS LineFeed
FROM	raw_830_order
WHERE	RTRIM(udf1) = '159') LineFeedCode ON Order_header.customer_part = LineFeedCode.CustomerPart AND ShipTo.ShipToID= LineFeedCode.ShipToID

JOIN  (SELECT	RTRIM(n104_1)AS ShipToID,
			RTRIM(lin03) AS CustomerPart,
			RTRIM(udf1) AS UltimateDelphiPart
FROM	raw_830_order
WHERE	RTRIM(udf2) = 'UA') UltimateDelphiPart ON Order_header.customer_part = UltimateDelphiPart.CustomerPart AND ShipTo.ShipToID = UltimateDelphiPart.ShipToID
 
--EXEC dbo.ftsp_DistributeReleasePlan


	  
	  SELECT	'Inserted m_in_release_plan'



GO
