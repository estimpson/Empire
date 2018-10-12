SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[sp_rep_PaidWorkingHours]
(
@OwneId			int,
@CompId			Varchar(36),
@PersonId		Varchar(10),
@EmplCentCostId	varchar(max),
@EnteOrgaId		varchar(max),
@DateIni		varchar(10),
@DateEnd		varchar(10),
@UserId			varchar(30),
@EmplTypeStatus	INT,
@ScheId			VARCHAR(max)
)
--exec sp_rep_PaidWorkingHours 1,@CompId,'%','%','%','2010/12/02','2010/12/02',@UserId,1		

AS
SET DATEFIRST 1

declare @DateIniDays int, @DateEndDays int
set @DateIniDays = dbo.GetDateInt(convert(datetime,@DateIni, 111))
set @DateEndDays = dbo.GetDateInt(convert(datetime,@DateEnd, 111))

CREATE TABLE #Tabla  (ScheId INT)
 DECLARE @SQL varchar(max)
 SET @ScheId = '('''+@ScheId+''')'
 SET @ScheId=REPLACE(@ScheId,',','''),(''')
 SET @SQL = 'INSERT INTO #Tabla ( ScheId ) VALUES '+ @ScheId
 EXEC(@SQL)
select 
	A.PersonId
	,c.EmpIdAlternative
	,P.ParaName as ReportTypeName
	,isnull(b.PersonName,  ' ')+ ' ' + isnull(b.PersonLastName1, ' ' )  + ' ' +  IsNull(b.PersonLastName2, ' ') as PersonName 
	, a.MoveHistoryDateProcess
	,c.EmplCentCostId ,c.EnteOrgaId ,cc.StrucCenterCostName,eo.EnteOrgaName 
	 ,MIN(A.MoveHistoryHour) as MoveHistoryHour,MIN(A.MoveHistoryMinute) as MoveHistoryMinute

	,(select ((SUM(MoveHistoryTotalMinute)))/60
	From  MovementsHistory   
--		inner join Employee on a.OwneId = Employee.OwneId 
--		and a.PersonId = Employee.PersonId and Employee.EmplTypeStatus =@EmplTypeStatus 
--	Where a.OwneId = @OwneId 
--	and CONVERT(VARCHAR(5),MovementsHistory.personid) = A.PersonId 
	Where MovementsHistory.OwneId = a.OwneId 
	and MovementsHistory.personid = A.PersonId 
	AND MovementsHistory.MoveHistoryDateProcessDays >= @DateIniDays
	AND MovementsHistory.MoveHistoryDateProcessDays <= @DateEndDays
	AND MoveHistoryType = 'MTP'
--	AND (Employee.EmplCentCostId LIKE @EmplCentCostId) and Employee.EnteOrgaId like @EnteOrgaId
	) AS TotalMoveHistoryHour
	
	,(select ((SUM(MoveHistoryTotalMinute)))%60
	From  MovementsHistory   
--	inner join Employee  
--	on	MovementsHistory.OwneId = Employee.OwneId 
--	and MovementsHistory.PersonId = Employee.PersonId 
--	and Employee.EmplTypeStatus = 1 
--	Where a.OwneId = @OwneId 
--	and CONVERT(VARCHAR(5),MovementsHistory.personid) = A.PersonId  
	where MovementsHistory.OwneId = A.OwneId
	and MovementsHistory.personid = A.PersonId  
	AND MovementsHistory.MoveHistoryDateProcessDays >= @DateIniDays
	AND MovementsHistory.MoveHistoryDateProcessDays <= @DateEndDays 
	AND MoveHistoryType = 'MTP' 
--	AND (Employee.EmplCentCostId LIKE @EmplCentCostId)
--	and Employee.EnteOrgaId like @EnteOrgaId
	) AS TotalMoveHistoryMinute,
	datepart(dw, a.MoveHistoryDateProcess) ndayOfWeek
	,dbo.SchedulePersonHistory.ScheId,CASE WHEN cc.Supervisor IS NULL THEN 'Ninguno' ELSE cc.Supervisor END AS Supervisor

From  MovementsHistory a  
inner join PersonNatural b  on a.OwneId = b.OwneId and a.PersonId = b.PersonId 
inner join Employee c on b.OwneId = c.OwneId and b.PersonId = c.PersonId and c.EmplTypeStatus = @EmplTypeStatus
left outer join CenterCost cc ON cc.OwneId  =c.owneid and cc.CentCostid =c.EmplCentCostId 
left outer join EnterpriseOrganization eo ON eo.OwneId =c.owneid and eo.EnteOrgaId = c.EnteOrgaId 
left outer join Parameter P on P.OwneId = c.OwneId 
left outer join ParameterDetail PD on P.OwneId = PD.OwneId and   P.ParaId = PD.ParaId and PD.ParaDetaId = a.MoveHistoryType 
INNER JOIN dbo.SchedulePersonHistory ON SchedulePersonHistory.OwneId = c.OwneId AND SchedulePersonHistory.PersonId = c.PersonId
AND dbo.SchedulePersonHistory.ScheHistoryState = 'Activo' 
Where c.OwneId = @OwneId 
and   c.personid = case @PersonId when '%' then c.personid else convert(int, @personid) end
and Not exists (Select 1 from dbo.PersonRestrictions(@CompId,@UserId) where OwneId = c.OwneId and personid = c.personid)
--AND c.EmplCentCostId LIKE @EmplCentCostId + '%' 
--AND c.EnteOrgaId like @EnteOrgaId + '%'
AND c.EmplCentCostId in (SELECT * FROM dbo.fnSplitString(@EmplCentCostId,','))
AND c.EnteOrgaId in (SELECT * FROM dbo.fnSplitString(@EnteOrgaId,','))
AND a.MoveHistoryDateProcessDays >=@DateIniDays 
AND a.MoveHistoryDateProcessDays <=@DateEndDays
and P.ParaId = 'Type_HTP' 
AND MoveHistoryType = 'MTP'
AND  dbo.SchedulePersonHistory.ScheId  IN  (SELECT ScheId FROM #Tabla)  
GROUP BY A.PersonId,c.EmpIdAlternative, P.ParaName, b.PersonName, b.PersonLastName1, b.PersonLastName2,a.MoveHistoryDateProcess,c.EmplCentCostId ,c.EnteOrgaId ,cc.StrucCenterCostName,eo.EnteOrgaName, a.OwneId,dbo.SchedulePersonHistory.ScheId,Supervisor
order by A.PersonId, convert(varchar(10),MoveHistoryDateProcess,111)
GO
