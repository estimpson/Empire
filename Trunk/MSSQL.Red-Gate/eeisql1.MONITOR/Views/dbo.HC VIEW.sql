SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[HC VIEW]
AS
SELECT     x.*, dbo.part.type AS Expr1
FROM         (SELECT     part.name, bill_of_material.parent_part, bill_of_material.part
                       FROM          Monitor.dbo.bill_of_material bill_of_material, Monitor.dbo.part part
                       WHERE      bill_of_material.part = part.part AND ((part.name LIKE 'W3 LAMP%'))) x INNER JOIN
                      dbo.part ON x.parent_part COLLATE SQL_Latin1_General_CP1_CI_AS = dbo.part.part
WHERE     (dbo.part.type <> 'F')
GO
