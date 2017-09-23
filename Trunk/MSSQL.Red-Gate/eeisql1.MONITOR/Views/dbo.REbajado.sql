SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[REbajado]
AS
SELECT     serial, part, SUM(quantity) AS rebajado, remarks, operator, notes, to_loc, date_stamp
FROM         dbo.audit_trail
GROUP BY serial, part, remarks, operator, notes, to_loc, date_stamp
HAVING      (remarks = 'mat issue') AND (NOT (part LIKE 'ckt%') AND NOT (part LIKE 'tm%') AND NOT (part LIKE 'spl%') AND NOT (part LIKE 'dbl-%') AND 
                      NOT (part LIKE 'pot%')) AND (to_loc = 'piso9-24') AND (date_stamp >= CONVERT(DATETIME, '2006-09-01 00:00:00', 102))
GO
