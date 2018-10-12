SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[VW_TRW_LotInfo] as

SELECT        UPPER(SUBSTRING(CONVERT(varchar(10), DATEPART(year, audit_trail.date_stamp)), 3, 2) + CONVERT(varchar(25), DATEPART(dy, audit_trail.date_stamp))) AS TRWLot, TRW_LOG.Lote AS MoldingLot, 
                         TRW_LOG.FGSerial AS BOXSerialNumber, TRW_LOG.RawIDLabel AS ReactionPlateSerialNumber, TRW_LOG.UnitWeight as UnitWeight
FROM            Sistema.dbo.TRW_LOG AS TRW_LOG INNER JOIN
                         EEH.dbo.audit_trail AS audit_trail ON audit_trail.serial = TRW_LOG.FGSerial AND audit_trail.type = 'P'
WHERE        (TRW_LOG.Lote IS NOT NULL) AND (TRW_LOG.FGSerial >= 30207738)
GO
