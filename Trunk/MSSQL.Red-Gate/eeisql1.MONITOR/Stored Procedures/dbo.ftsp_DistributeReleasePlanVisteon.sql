SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[ftsp_DistributeReleasePlanVisteon]

as
TRUNCATE TABLE m_in_release_plan



Create table #releasePlan1(
							lineid	integer IDENTITY (1,1),
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
							

							
Create table #NetreleasePlan(
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
						

insert #releasePlan1(		customerpart	,
							destination		,
							customerPO		,
							modelYear			,
							ReleaseNumber	,
							QtyQual				,
							Qty						,
							DateType			,
							ReleaseDate		,
							customerAccum		)
	select 	isNULL(rtrim(customer_part), 'Check EDI Setups'),
			isNull((SELECT	MAX(order_header.destination)
			FROM	order_header
			JOIN	edi_setups ON order_header.destination = edi_seTups.destination
			WHERE	edi_setups.parent_destination = rtrim(fd5_830_releases.ship_to) and  edi_setups.supplier_code = rtrim(fd5_830_releases.ship_from) AND
					order_HEADER.customer_part = fd5_830_releases.customer_part), rtrim(fd5_830_releases.ship_to)),
			rtrim(customer_po),
			'',
			rtrim(release_number),
			'A',
			0,
			'S',
			(CASE date_indicator WHEN 'F' THEN dateadd(dd, -1*isNULL ((SELECT	MAX(id_code_type)
			FROM	order_header
			JOIN	edi_setups ON order_header.destination = edi_seTups.destination
			WHERE	edi_setups.parent_destination = rtrim(fd5_830_releases.ship_to) and  edi_setups.supplier_code = rtrim(fd5_830_releases.ship_from) AND
					order_HEADER.customer_part = fd5_830_releases.customer_part),0),convert(datetime,date2))ELSE dateadd(dd, -1*isNULL ((SELECT	MAX(id_code_type)
			FROM	order_header
			JOIN	edi_setups ON order_header.destination = edi_seTups.destination
			WHERE	edi_setups.parent_destination = rtrim(fd5_830_releases.ship_to) and  edi_setups.supplier_code = rtrim(fd5_830_releases.ship_from) AND
					order_HEADER.customer_part = fd5_830_releases.customer_part),0),convert(datetime,date1))END ),
			convert(decimal(20,6),cum_qty)
	 FROM 	dbo.fd5_830_releases
			
	 				 
	 
	 order by 1,2,9  
	 
   
 	
TRUNCATE TABLE dbo.fd5_830_releases



INSERT #NetreleasePlan
        ( customerpart ,
          destination ,
          customerPO ,
          modelYear ,
          ReleaseNumber ,
          QtyQual ,
          Qty ,
          DateType ,
          ReleaseDate ,
          CustomerAccum
        )




SELECT	customerpart,
		destination,
		customerPO,
		modelYear,
		ReleaseNumber,
		'N',
		COALESCE((CustomerAccum-(SELECT MAX(rp2.CustomerAccum) FROM #releasePlan1 rp2 WHERE rp2.customerpart = rp1.customerpart AND rp2.destination = rp1.destination AND rp2.lineid<rp1.lineid)), rp1.CustomerAccum-(SELECT MAX(our_cum) FROM order_header JOIN part_eecustom ON order_header.blanket_part = part_eecustom.part AND ISNULL(NULLIF(order_header.status,''),'C') = 'A' WHERE order_header.customer_part =rp1.customerPart AND order_header.destination = rp1.destination )),
		'S',
		ReleaseDate,
		CustomerAccum 
FROM	#releasePlan1 rp1


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
			ISNULL(Qty,0),
			DateType,
			ReleaseDate,
			(Select sum(Qty) from #NetreleasePlan RP2 
				where RP2.customerPart = #NetreleasePlan.customerPart and 
							RP2.destination = #NetReleasePlan.destination  and 
							RP2.lineid <= #NetreleasePlan.lineid),
			#NetreleasePlan.CustomerAccum,
			(Select sum(Qty) from #NetreleasePlan RP2 
				where RP2.customerPart = #NetreleasePlan.customerPart and 
							RP2.destination = #NetReleasePlan.destination  and 
							RP2.lineid <= #NetreleasePlan.lineid)+COALESCE((SELECT	order_header.our_cum 
																FROM	order_header 
																JOIN	part_eecustom ON order_header.blanket_part = part_eecustom.part 
																WHERE	ISNULL(NULLIF(order_header.status,''),'C') = 'A' AND 
																		order_header.customer_part = #NetreleasePlan.CustomerPart AND
																		order_header.destination = #NetreleasePlan.destination), CustomerAccum,0)
	 FROM #NetreleasePlan
	 order by destination, customerpart, ReleaseDate       



DELETE	#CumulativereleasePlan
WHERE	(Accum-(ISNULL(EmpireAccum,0)-CustomerAccum))<=0



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
		ISNULL(Qty,0),
		'S',
		ReleaseDate
FROM	#CumulativereleasePlan



Update	order_header
set			custom01 = rtrim(udf2)
FROM 		"raw_830_order"
	 	LEFT OUTER JOIN 	"edi_setups"  ON rtrim("raw_830_order"."n104_1") = "edi_setups"."parent_destination"
	  JOIN	"order_header"   ON edi_setups.destination = order_header.destination
	  WHERE rtrim(raw_830_order.udf1) = order_header.customer_part
	  

--SELECT	*
--FROM	#Netreleaseplan
--ORDER BY destination, customerpart, releaseDate

----SELECT	*
----FROM	#CumulativereleasePlan1
----ORDER BY destination, customerpart, releaseDate


--SELECT	*
--FROM	#CumulativereleasePlan
--ORDER BY destination, customerpart, releaseDate

--SELECT	*
--FROM	m_in_release_plan

 
--EXEC dbo.ftsp_DistributeReleasePlan


SELECT	'Processed Visteon EDI Sales Orders'
GO
