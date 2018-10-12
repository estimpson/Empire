SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

Create view [HN].[vw_Part_ReceivingInspection_Details]
as
Select	data.*, 
		Visual = case when GruposPrueba.visual = 1 then  ReceivingInspection else null end,
		Testing = case when GruposPrueba.Testing = 1 then   ReceivingInspection*0.1 else null end
from	(
select	Data.part, 
		Data.CurrentYear,
		Data.semana, 
		TotalReceiving = qty, 
		ReceivingInspection=Case 
                                  when qty>=Samples.LotSize_min and isnull(Samples.LotSize_Max,0)=0 then SampleSize
                                  when qty>=Samples.LotSize_min and qty<=Samples.LotSize_Max then SampleSize else 0 end 		
from 
(select      audit_trail.part, semana = datepart(ISO_WEEK, date_stamp), qty = sum(std_quantity), received=max(isnull(custom3,'')),
CurrentYear=datepart(year,date_stamp), max(date_stamp) as date_stamp,part_inventory.StepRI, 
coalesce(max(part_inventory.LastDateRI),max(date_stamp)) as LastDateRI
from   audit_trail
             join part_inventory ON part_inventory.part = audit_trail.part and Receiving_Inspection=1
             JOIN part ON part.part = part_inventory.part
			 join eeh.HN.Part_CustomerDetails  Part_CustomerDetails on Part_CustomerDetails.part = part.part
WHERE Part_CustomerDetails.customer='Chrysler' and audit_trail.type ='R' 
             and date_stamp > dateadd(year, -1, getdate())
             and serial not in (select serial from audit_trail au
                                               join part_inventory ON part_inventory.part = au.part and Receiving_Inspection=1
                                               where type='R' and quantity<0 )              
group by audit_trail.part, datepart(ISO_WEEK, date_stamp), datepart(year,date_stamp),part_inventory.StepRI ) Data 
left join eeh.dbo.RI_WeeksExclude exclude on exclude.part = data.part and exclude.date_stamp=data.date_stamp and Data.semana=exclude.semana 
       cross join (Select *
                           from   eeh.dbo.TRWSampleSize_AQL) Samples
where  Case 
             when qty>=Samples.LotSize_min and isnull(Samples.LotSize_Max,0)=0 then SampleSize
             when qty>=Samples.LotSize_min and qty<=Samples.LotSize_Max then SampleSize else 0 end>0
       and exclude.ID  is null) Data
left join (Select Visual= sum(visual), Testing= sum(testing), parte
			from (
			SELECT distinct Visual=1, Testing=0, SA_Partes_Preguntas.Parte
			FROM sistema.dbo.SA_Partes_Preguntas 
			INNER JOIN sistema.dbo.SA_PreguntasLog ON SA_Partes_Preguntas.PreguntaID = SA_PreguntasLog.PreguntaID 
			WHERE SA_PreguntasLog.GrupoID = 75 and Estado=1
			union all
			SELECT distinct Visual=0, Testing=1, SA_Partes_Preguntas.Parte
			FROM sistema.dbo.SA_Partes_Preguntas 
			INNER JOIN sistema.dbo.SA_PreguntasLog ON SA_Partes_Preguntas.PreguntaID = SA_PreguntasLog.PreguntaID 
			WHERE SA_PreguntasLog.GrupoID = 76 and Estado=1) Pruebas
			group by parte
			) GruposPrueba
		on data.part = GruposPrueba.Parte

 
GO
