SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
















CREATE FUNCTION [FT].[fn_ReturnSchedulerEMailAddress]
(	@SchedulerInitials NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
--- <Body>
/*	Return Schedulers e-mail adress by initials. If no match occurs, send to email groups */
	DECLARE @EmailAddress VARCHAR(MAX)

	SELECT @EmailAddress
		= (CASE COALESCE(UPPER(@SchedulerInitials),'')
						WHEN 'SZ'			THEN 'syhernandez@empire.hn'
						WHEN 'GU'			THEN 'gurbina@empireelect.com'
						WHEN 'JST'			THEN 'JStoehr@empireelect.com;SSawyers@empireelect.com '
						WHEN 'SSAW'			THEN 'JStoehr@empireelect.com;SSawyers@empireelect.com '
						WHEN 'SLars'		THEN 'shesse@empireelect.com'
						WHEN 'SHES'			THEN 'shesse@empireelect.com'
						WHEN 'VC'			THEN 'IAragon@empireelect.com'
						WHEN 'JJF'			THEN 'jjFlores@empire.hn;jflores@empireelect.com'
						WHEN 'IA'			THEN 'IAragon@empireelect.com'
						WHEN 'CV'			THEN 'CVanBibber@empireelect.com'
						WHEN 'GCHA'			THEN 'gchavez@empire.hn;gchavez@empireelect.com'
						WHEN 'BHAL'			THEN 'BHalaquist@empireelect.com'
						WHEN 'OFAJ'			THEN 'ofajardo@empire.hn'
						ELSE 'eeischedulers@empireelect.com; eeischedulers@empire.hn'
						END) + ';IAragon@empireelect.com'

		RETURN @EmailAddress


END















GO
