SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create view [EDI].[ShippedSerialsLast90Days]
as
Select * from audit_trail
where type= 'S' and date_stamp>= getdate()-90
GO
