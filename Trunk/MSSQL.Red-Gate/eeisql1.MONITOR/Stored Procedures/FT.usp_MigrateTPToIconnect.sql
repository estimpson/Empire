SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


--Autoliv go live date 8/10/2016
CREATE procedure [FT].[usp_MigrateTPToIconnect]

as 
begin
 
 declare @CurrentDT DATETIME = getdate()

if @CurrentDT> '2016-10-03 09:55:00.000' AND @CurrentDT < '2016-10-03 10:05:00.000'
Begin
update 
	EDI.XMLShipNotice_ASNDataRootFunction
set 
	status = 0,
	CompleteFlagDefault = 1,
	FTPMailBoxDefault = 1 
where 
	ASNOverlayGroup in ('GM5', 'GM2')

UPDATE 
	edi_setups
SET
	auto_create_asn = 'N'
WHERE
	auto_create_asn = 'Y' and
	asn_overlay_group in ('GM5', 'GM2')
	

End
end

GO
