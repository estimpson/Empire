SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [HN].[tempalfredo] as
create table #x(Part varchar(25))

Insert into #x(Part) values('ALC0477%')
Insert into #x(Part) values('ALC0478%')
Insert into #x(Part) values('ALC0482%')
Insert into #x(Part) values('ALC0536%')
Insert into #x(Part) values('AUT0117%')
Insert into #x(Part) values('AUT0186%')
Insert into #x(Part) values('AUT0187%')
Insert into #x(Part) values('DOR0001%')
Insert into #x(Part) values('DOR0002%')
Insert into #x(Part) values('DOR0003%')
Insert into #x(Part) values('DOR0004%')
Insert into #x(Part) values('DOR0005%')
Insert into #x(Part) values('GUR0001%')
Insert into #x(Part) values('LEO0005%')
Insert into #x(Part) values('LEO0007%')
Insert into #x(Part) values('LEO0008%')
Insert into #x(Part) values('LEO0009%')
Insert into #x(Part) values('LEO0010%')
Insert into #x(Part) values('LEO0012%')
Insert into #x(Part) values('LEO0013%')
Insert into #x(Part) values('LEO0014%')
Insert into #x(Part) values('LEO0015%')
Insert into #x(Part) values('LEO0016%')
Insert into #x(Part) values('MAG0111%')
Insert into #x(Part) values('NAL0469%')
Insert into #x(Part) values('NAL0571%')
Insert into #x(Part) values('NAL0572%')
Insert into #x(Part) values('NAL0573%')
Insert into #x(Part) values('NOR0013%')
Insert into #x(Part) values('NOR0014%')
Insert into #x(Part) values('NOR0016%')
Insert into #x(Part) values('NOR0019%')
Insert into #x(Part) values('RMP0055%')
Insert into #x(Part) values('SLA0200%')
Insert into #x(Part) values('SLA0230%')
Insert into #x(Part) values('TOG0046%')
Insert into #x(Part) values('TRW0486%')
Insert into #x(Part) values('TRW0618%')
Insert into #x(Part) values('TRW0646%')
Insert into #x(Part) values('TRW0654%')
Insert into #x(Part) values('TRW0661%')
Insert into #x(Part) values('TRW0662%')
Insert into #x(Part) values('VSL0351%')
Insert into #x(Part) values('VSL0352%')
Insert into #x(Part) values('VSL0353%')
Insert into #x(Part) values('VSL0356%')

select	Toppart, childpart, XQty, default_vendor, CMSData.LaunchQuarter , CMSData.CSMFinal 
from	ft.XRt xrt
		join part on part.part = xrt.ChildPart
		join part_online PO on po.part = xrt.ChildPart
		left outer join (SELECT Part, CSMFinal, LaunchQuarter 
						 FROM EEH.dbo.VW_ENG_CapacityAnalysis) CMSData on CMSData.Part  = left(xrt.Toppart,7) 
where	BOMLevel > 0
		and part.type = 'R'
		and (xrt.TopPart in (	select	Max(part.PART)
							from	part
									join #x x on part.part like x.part and PART.part like '%-H%'
							where	x.part not in ('TRW0646%','NAL0573%','NAL0572%','NAL0571%','NAL0469%','GUR0001%','ALC0536%')
							group by x.part ) 
		or xrt.TopPart in (	select	Max(part.PART)
							from	part
									join #x x on part.part like x.part and PART.part like '%-PT%'
							where	x.part in ('TRW0646%','NAL0573%','NAL0572%','NAL0571%','NAL0469%','GUR0001%','ALC0536%') 
							group by x.part) )
order by TopPart, ChildPart


GO
