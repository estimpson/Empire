SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[tet]
AS
SELECT     TOP 100 PERCENT dbo.object.location, dbo.AuditTrail_26.serial, dbo.AuditTrail_26.date_stamp, dbo.AuditTrail_26.part, dbo.AuditTrail_26.quantity, 
                      dbo.AuditTrail_26.from_loc, dbo.AuditTrail_26.to_loc
FROM         dbo.AuditTrail_26 LEFT OUTER JOIN
                      dbo.object ON dbo.AuditTrail_26.serial = dbo.object.serial
ORDER BY dbo.AuditTrail_26.to_loc, dbo.AuditTrail_26.serial
GO
