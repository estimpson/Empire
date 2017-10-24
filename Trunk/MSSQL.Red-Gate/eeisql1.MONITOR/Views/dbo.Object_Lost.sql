SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[Object_Lost]
AS
SELECT     TOP 100 PERCENT serial, part, location, last_date, status, operator, quantity, parent_serial
FROM         dbo.object
WHERE     (location = 'LOST')
ORDER BY last_date
GO
