SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CDIsp_asn_detail_serial_test] ( @SHIPPER INTEGER )
AS --[dbo].[CDIsp_asn_detail_serial_test] 47715 
    BEGIN
        CREATE TABLE #atr_package_type
            (
              part VARCHAR(25) NULL ,
              package_type VARCHAR(25) NULL ,
              pack_qty DECIMAL(20, 6) NULL ,
			  PackGroup INTEGER NULL,
              package_count INTEGER NULL
             
            )
        CREATE TABLE #atr_objects
            (
              serial INTEGER NULL ,
              part VARCHAR(25) NULL ,
              package_quantity VARCHAR(25) NULL ,
              package_type VARCHAR(25) NULL ,
              SerialCounter INT IDENTITY
            )
  
        INSERT  INTO #atr_objects
                ( serial ,
                  part ,
                  package_quantity ,
                  package_type
                )
                SELECT  audit_trail.serial ,
                        audit_trail.part ,
                        audit_trail.quantity ,
                        ISNULL(audit_trail.package_type, 'CTN90')
                FROM    audit_trail
                WHERE   audit_trail.type = 'S'
                        AND audit_trail.part <> 'PALLET'
                        AND audit_trail.shipper = CONVERT(VARCHAR(25), @shipper)
      
        INSERT  INTO #atr_package_type
				(	 part,
					package_type,
					pack_qty,
					package_count
				)
                SELECT  atrobjects.part ,
						atrobjects.package_type ,
						atrobjects.package_quantity ,
						COUNT(SERIAL)
                FROM    #atr_objects atrobjects
                GROUP BY atrobjects.part ,
                        atrobjects.package_type ,
                        atrobjects.package_quantity
                        
        SELECT  edi_setups.prev_cum_in_asn ,
                shipper_detail.customer_part ,
                shipper_detail.alternative_qty ,
                shipper_detail.alternative_unit ,
                shipper_detail.net_weight ,
                shipper_detail.gross_weight ,
                shipper_detail.accum_shipped ,
                shipper_detail.shipper ,
                shipper_detail.customer_po ,
                accum2 = ( SELECT   ISNULL(MAX(sd2.accum_shipped), 0)
                           FROM     shipper_detail AS sd2
                           WHERE    sd2.order_no = shipper_detail.order_no
                                    AND ( sd2.date_shipped ) <= ( SELECT
                                                              MAX(sd3.date_shipped)
                                                              FROM
                                                              shipper_detail
                                                              AS sd3
                                                              WHERE
                                                              sd3.order_no = shipper_detail.order_no
                                                              AND sd3.date_shipped < shipper_detail.date_shipped
                                                              )
                         ) ,
                #atr_package_type.package_type ,
                #atr_package_type.package_count ,
                #atr_package_type.pack_qty ,
                #atr_objects.serial ,
                order_header.engineering_level ,
                ( SELECT    COUNT(1)
                  FROM      shipper_detail sd2
                  WHERE     sd2.shipper = @SHIPPER
                            AND sd2.part_original <= shipper_detail.part_original
                ) AS LineItem ,
                CONVERT(VARCHAR(3), ( SELECT    COUNT(1)
                                      FROM      shipper_detail sd2
                                      WHERE     sd2.shipper = @SHIPPER
                                                AND sd2.part_original <= shipper_detail.part_original
                                    )) + dbo.shipper_detail.customer_part AS GCustomerPart ,
                part_original ,
                #atr_objects.serialcounter,
                CEILING(#atr_objects.serialcounter/200.1) AS PackageGroup
        FROM    edi_setups ,
                shipper_detail ,
                shipper ,
                order_header ,
                #atr_package_type ,
                #atr_objects
        WHERE   ( shipper.destination = edi_setups.destination )
                AND ( order_header.order_no = shipper_detail.order_no )
                AND ( shipper.id = @shipper )
                AND ( #atr_package_type.part = shipper_detail.part_original )
                AND ( #atr_objects.part = shipper_detail.part_original )
                AND ( #atr_objects.part = #atr_package_type.part )
                AND ( #atr_objects.package_quantity = #atr_package_type.pack_qty )
                AND ( #atr_objects.package_type = #atr_package_type.package_type )
                AND ( (shipper_detail.shipper = @shipper) )
        ORDER BY part_original ASC ,
                11 ASC ,
                12 ASC ,
                13 ASC ,
                14 ASC
    END



GO
