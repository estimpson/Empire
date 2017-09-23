SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SaveAuditTrail]( @Desde datetime, @Hasta Datetime ) AS

DELETE FROM EEH_ProduccionDelPeriodoRangoExtendido

INSERT INTO EEH_ProduccionDelPeriodoRangoExtendido ( part, quantity, remarks, type, date_stamp ) 
SELECT audit_trail.part, audit_trail.quantity, audit_trail.remarks, part.type, audit_trail.date_stamp 
FROM audit_trail INNER JOIN part ON audit_trail.part = part.part 
WHERE (((audit_trail.part) Not Like 'X%' And (audit_trail.part) Not Like 'MET%' And (audit_trail.part) Not Like 'J%' And (audit_trail.part) Not Like 'AUT0001%') AND ((audit_trail.remarks)='Job Comp') AND ((part.type)='F') AND ((audit_trail.date_stamp) Between @Desde And @Hasta) AND ((part.product_line)='Wire Harn-EEH'));



GO
