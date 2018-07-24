SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE VIEW [EDI_XML_Autosystems_ASN].[ASNLines]
AS
SELECT
	ShipperID = s.id
,	CustomerPart = sd.customer_part
,	QtyPacked = SUM(CONVERT(INT, sd.alternative_qty))
,	Unit = 'EA'
,	AccumShipped = MAX(sd.accum_shipped)
,	CustomerPO = MAX(COALESCE( AutoSystemsPO, sd.customer_po ))
,	RowNumber = ROW_NUMBER() OVER (PARTITION BY s.id ORDER BY sd.customer_part)
FROM
	dbo.shipper s
	JOIN dbo.shipper_detail sd
		ON sd.shipper = s.id
	JOIN dbo.edi_setups es
		ON es.destination = s.destination
		AND es.asn_overlay_group LIKE 'AO%'
	LEFT JOIN
					EDIAutoSystems.BlanketOrders bo ON bo.BlanketOrderNo = sd.order_no
				OUTER APPLY
					( SELECT TOP 1 cpr.CustomerPO AutoSystemsPO
						FROM 
							EDI4010.CurrentPlanningReleases() cpr
						JOIN
						EDI4010.PlanningHeaders ph ON ph.RawDocumentGUID = cpr.RawDocumentGUID
						WHERE 
							ShipFromCode = 'US0842' AND
							cpr.ShipToCode = bo.EDIShipToCode AND
							cpr.CustomerPart = bo.CustomerPart
                        
						ORDER BY ph.DocumentDT DESC	
					) AutoSystemsEDIRelease
WHERE
	COALESCE(s.type, 'N') IN ('N', 'M')
	GROUP BY 
		s.id, sd.customer_part


GO
