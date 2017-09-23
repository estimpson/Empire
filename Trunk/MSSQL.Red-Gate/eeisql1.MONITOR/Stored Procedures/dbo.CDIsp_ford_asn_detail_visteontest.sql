SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CDIsp_ford_asn_detail_visteontest]  (@shipper integer)
as

BEGIN

--[dbo].[CDIsp_ford_asn_detail_visteontest] 47841

CREATE TABLE #atr_package_type_serials
            (
				serial INT NULL,	
              part VARCHAR(25) NULL ,
              package_type VARCHAR(25) NULL ,
              pack_qty DECIMAL(20, 6) NULL ,
			  PartPackQtyGroup INTEGER NULL)
			  
CREATE TABLE #atr_package_type_serials_group
            (
				GroupCount INT NULL,
				serial INT NULL,	
              part VARCHAR(25) NULL ,
              package_type VARCHAR(25) NULL ,
              pack_qty DECIMAL(20, 6) NULL,
              PartPackQtyGroup INTEGER NULL )



   CREATE TABLE #atr_objects
            (
              serial INTEGER NULL ,
              part VARCHAR(25) NULL ,
              package_quantity VARCHAR(25) NULL ,
              package_type VARCHAR(25) NULL 
            )
            
    CREATE TABLE #ShipperDetail (
				PreviousAccumFlag VARCHAR(3),
				CustomerPart VARCHAR(35), 
				QtyShipped NUMERIC(20,6), 
				UM VARCHAR(4), 
				NetWeight NUMERIC(20,6), 
				GrossWeight NUMERIC(20,6), 
				Accum NUMERIC(20,6), 
				Shipper Int, 
				CustomerPO VARCHAR(35),
				PriorAccum NUMERIC(20,6))
				
 	INSERT #ShipperDetail
	        ( PreviousAccumFlag,
				CustomerPart ,
	          QtyShipped ,
	          UM ,
	          NetWeight ,
	          GrossWeight ,
	          Accum ,
	          Shipper ,
	          CustomerPO ,
	          PriorAccum
	        )
	SELECT 	MAX(edi_setups.prev_cum_in_asn),
		shipper_detail.customer_part, 
		SUM(shipper_detail.alternative_qty), 
		MAX(shipper_detail.alternative_unit), 
		SUM(shipper_detail.net_weight), 
		SUM(shipper_detail.gross_weight), 
		MAX(shipper_detail.accum_shipped), 
		MAX(shipper_detail.shipper), 
		MAX(shipper_detail.customer_po),
		MAX(shipper_detail.accum_shipped) as accum2
      FROM 	dbo.shipper_detail
      JOIN	dbo.shipper ON dbo.shipper_detail.shipper = dbo.shipper.id AND shipper.id = @shipper
      JOIN	dbo.edi_setups ON dbo.shipper.destination = dbo.edi_setups.destination
      GROUP  BY dbo.shipper_detail.customer_part
	



  INSERT  INTO #atr_objects
                (	serial ,
					part ,
					package_quantity,
					package_type
                )
                SELECT	audit_trail.serial ,
                        (SELECT MIN(customer_part) FROM shipper_detail WHERE shipper = @shipper AND part_original = audit_trail.part),
                        audit_trail.quantity ,
                        ISNULL(audit_trail.package_type, 'CTN90')
                       
                FROM    audit_trail
                WHERE   audit_trail.type = 'S'
                        AND audit_trail.part <> 'PALLET'
                        AND audit_trail.shipper = CONVERT(VARCHAR(25),@shipper)
                 ORDER BY	audit_trail.serial ,
							audit_trail.part ,
							audit_trail.quantity ,
							ISNULL(audit_trail.package_type, 'CTN90')
                
      
      INSERT  INTO #atr_package_type_serials
				(		serial,
						part,
						package_type,
						pack_qty,
						PartPackQtyGroup
				)
                SELECT  atrobjects.serial,
						atrobjects.part,
						atrobjects.package_type ,
						atrobjects.package_quantity ,
						CEILING((SELECT	COUNT(1) 
						FROM	#atr_objects objects2 
						Where	objects2.package_type = atrobjects.package_type AND objects2.package_quantity = atrobjects.package_quantity AND objects2.part = atrobjects.part AND objects2.serial<=atrobjects.serial )/200.1)
                FROM    #atr_objects atrobjects
                
							
	INSERT #atr_package_type_serials_group 
			(	serial,
				part,
				package_type,
				pack_qty,
				GroupCount,
				PartPackQtyGroup) 
	SELECT	serial,
			part,
			package_type,
			pack_qty,
			(SELECT COUNT(1) 
			FROM	#atr_package_type_serials atg2
			WHERE	atg2.part = atg1.part AND
					atg2.package_type = atg1.package_type AND
					atg2.pack_qty = atg1.pack_qty AND
					atg2.PartPackQtyGroup = atg1.PartPackQtyGroup),
					PartPackQtyGroup
	FROM	#atr_package_type_serials atg1
	
/*	SELECT	*
	FROM	#atr_package_type_serials_group*/
	
SELECT 	PreviousAccumFlag ,
        CustomerPart ,
        QtyShipped ,
        UM ,
        NetWeight ,
        GrossWeight ,
        Accum ,
        Shipper ,
        CustomerPO ,
        PriorAccum ,
        package_type ,
        GroupCount ,
        pack_qty ,
        serial ,
        PartPackQtyGroup
FROM 	#shipperDetail sd
JOIN	#atr_package_type_serials_group atpg ON sd.CustomerPart = atpg.part
END          

GO
