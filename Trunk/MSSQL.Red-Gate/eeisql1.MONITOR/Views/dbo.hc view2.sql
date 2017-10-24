SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[hc view2]
AS
SELECT     dbo.bill_of_material.parent_part AS Parentpart, dbo.[HC VIEW].*
FROM         dbo.bill_of_material INNER JOIN
                      dbo.[HC VIEW] ON dbo.bill_of_material.part = dbo.[HC VIEW].parent_part
GO
