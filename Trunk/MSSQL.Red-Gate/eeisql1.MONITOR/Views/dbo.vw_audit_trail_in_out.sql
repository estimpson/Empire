SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [dbo].[vw_audit_trail_in_out]
as
SELECT     dbo.audit_trail.serial, dbo.audit_trail.part, dbo.audit_trail.date_stamp, dbo.audit_trail.type, dbo.audit_trail.remarks, dbo.audit_trail.std_quantity, 
                      dbo.audit_trail.cost, (CASE WHEN audit_trail.TYPE IN ('J', 'A', 'R', 'U') THEN 'IN' ELSE 'OUT' END) AS Expr1, 
                      (CASE WHEN part.TYPE = 'F' THEN 'Finished' WHEN part.TYPE = 'W' THEN 'WIP' WHEN part.TYPE = 'R' THEN 'Raw' ELSE 'Other' END) 
                      AS Expr2
FROM         dbo.audit_trail INNER JOIN
                      dbo.part ON dbo.audit_trail.part = dbo.part.part
WHERE     dbo.audit_trail.serial in (Select serial from audit_trail where type in  ('J', 'A', 'R', 'U') and date_stamp > '2006/04/01') AND 
				 dbo.audit_trail.type IN ('J', 'A', 'R', 'U', 'D', 'M', 'S', 'V', 'Q')
				
GO
