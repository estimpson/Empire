CREATE TABLE [EEIUser].[acctg_csm_material_cost_detail]
(
[Release_ID] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Row_ID] [int] NOT NULL,
[BasePart] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Version] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartUsedForCost] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EffectiveYear] [int] NOT NULL,
[EffectiveDT] [datetime] NULL,
[MaterialCost] [decimal] (18, 6) NULL,
[Header_ID] [int] NOT NULL,
[Period] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE trigger [EEIUser].[tr_csm_material_cost_detail_IUD] on [EEIUser].[acctg_csm_material_cost_detail] for insert, update, delete
as
delete
	t
from
	EEIUser.acctg_csm_material_cost_tabular t
where
	t.ID in
		(	select
		 		i.Header_ID
		 	from
		 		Inserted i
			union all
			select
				d.Header_ID
			from
				Deleted d
		)


insert
	EEIUser.acctg_csm_material_cost_tabular
(
	[ID]
,	[RELEASE_ID]
,	[ROW_ID]
,	[BASE_PART]
,	[VERSION]
,	[INCLUSION]
,	[PartUsedForCost]
,	[EFFECTIVE_DATE]

,	[JAN_08]
,   [FEB_08]
,   [MAR_08]
,   [APR_08]
,   [MAY_08]
,   [JUN_08]
,   [JUL_08]
,   [AUG_08]
,   [SEP_08]
,   [OCT_08]
,   [NOV_08]
,   [DEC_08]

,	[JAN_09]
,   [FEB_09]
,   [MAR_09]
,   [APR_09]
,   [MAY_09]
,   [JUN_09]
,   [JUL_09]
,   [AUG_09]
,   [SEP_09]
,   [OCT_09]
,   [NOV_09]
,   [DEC_09]

,	[JAN_10]
,   [FEB_10]
,   [MAR_10]
,   [APR_10]
,   [MAY_10]
,   [JUN_10]
,   [JUL_10]
,   [AUG_10]
,   [SEP_10]
,   [OCT_10]
,   [NOV_10]
,   [DEC_10]

,	[JAN_11]
,   [FEB_11]
,   [MAR_11]
,   [APR_11]
,   [MAY_11]
,   [JUN_11]
,   [JUL_11]
,   [AUG_11]
,   [SEP_11]
,   [OCT_11]
,   [NOV_11]
,   [DEC_11]

,	[JAN_12]
,   [FEB_12]
,   [MAR_12]
,   [APR_12]
,   [MAY_12]
,   [JUN_12]
,   [JUL_12]
,   [AUG_12]
,   [SEP_12]
,   [OCT_12]
,   [NOV_12]
,   [DEC_12]

,	[JAN_13]
,   [FEB_13]
,   [MAR_13]
,   [APR_13]
,   [MAY_13]
,   [JUN_13]
,   [JUL_13]
,   [AUG_13]
,   [SEP_13]
,   [OCT_13]
,   [NOV_13]
,   [DEC_13]

,	[JAN_14]
,   [FEB_14]
,   [MAR_14]
,   [APR_14]
,   [MAY_14]
,   [JUN_14]
,   [JUL_14]
,   [AUG_14]
,   [SEP_14]
,   [OCT_14]
,   [NOV_14]
,   [DEC_14]

,	[JAN_15]
,   [FEB_15]
,   [MAR_15]
,   [APR_15]
,   [MAY_15]
,   [JUN_15]
,   [JUL_15]
,   [AUG_15]
,   [SEP_15]
,   [OCT_15]
,   [NOV_15]
,   [DEC_15]

,	[JAN_16]
,   [FEB_16]
,   [MAR_16]
,   [APR_16]
,   [MAY_16]
,   [JUN_16]
,   [JUL_16]
,   [AUG_16]
,   [SEP_16]
,   [OCT_16]
,   [NOV_16]
,   [DEC_16]

,	[JAN_17]
,   [FEB_17]
,   [MAR_17]
,   [APR_17]
,   [MAY_17]
,   [JUN_17]
,   [JUL_17]
,   [AUG_17]
,   [SEP_17]
,   [OCT_17]
,   [NOV_17]
,   [DEC_17]

,	[JAN_18]
,   [FEB_18]
,   [MAR_18]
,   [APR_18]
,   [MAY_18]
,   [JUN_18]
,   [JUL_18]
,   [AUG_18]
,   [SEP_18]
,   [OCT_18]
,   [NOV_18]
,   [DEC_18]

,	[JAN_19]
,   [FEB_19]
,   [MAR_19]
,   [APR_19]
,   [MAY_19]
,   [JUN_19]
,   [JUL_19]
,   [AUG_19]
,   [SEP_19]
,   [OCT_19]
,   [NOV_19]
,   [DEC_19]

,	[JAN_20]
,   [FEB_20]
,   [MAR_20]
,   [APR_20]
,   [MAY_20]
,   [JUN_20]
,   [JUL_20]
,   [AUG_20]
,   [SEP_20]
,   [OCT_20]
,   [NOV_20]
,   [DEC_20]

,   [DEC_21]
,   [DEC_22]
,   [DEC_23]
,   [DEC_24]
,   [DEC_25]
)
select
	h.ID
,	h.Release_ID 
,	h.Row_ID
,	h.BasePart
,	h.[Version]
,	h.Inclusion
,	h.PartUsedForCost
,	null

,	[JAN_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M01')
,   [FEB_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M02')
,   [MAR_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M03')
,   [APR_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M04')
,   [MAY_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M05')
,   [JUN_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M06')
,   [JUL_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M07')
,   [AUG_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M08')
,   [SEP_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M09')
,   [OCT_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M10')
,   [NOV_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M11')
,   [DEC_08] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2008 and Period = 'M12')
						
,	[JAN_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M01')
,   [FEB_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M02')
,   [MAR_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M03')
,   [APR_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M04')
,   [MAY_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M05')
,   [JUN_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M06')
,   [JUL_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M07')
,   [AUG_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M08')
,   [SEP_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M09')
,   [OCT_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M10')
,   [NOV_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M11')
,   [DEC_09] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2009 and Period = 'M12')
				
,	[JAN_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M01')
,   [FEB_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M02')
,   [MAR_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M03')
,   [APR_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M04')
,   [MAY_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M05')
,   [JUN_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M06')
,   [JUL_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M07')
,   [AUG_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M08')
,   [SEP_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M09')
,   [OCT_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M10')
,   [NOV_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M11')
,   [DEC_10] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2010 and Period = 'M12')
						
,	[JAN_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M01')
,   [FEB_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M02')
,   [MAR_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M03')
,   [APR_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M04')
,   [MAY_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M05')
,   [JUN_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M06')
,   [JUL_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M07')
,   [AUG_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M08')
,   [SEP_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M09')
,   [OCT_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M10')
,   [NOV_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M11')
,   [DEC_11] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2011 and Period = 'M12')
						
,	[JAN_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M01')
,   [FEB_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M02')
,   [MAR_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M03')
,   [APR_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M04')
,   [MAY_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M05')
,   [JUN_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M06')
,   [JUL_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M07')
,   [AUG_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M08')
,   [SEP_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M09')
,   [OCT_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M10')
,   [NOV_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M11')
,   [DEC_12] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2012 and Period = 'M12')
						  
,	[JAN_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M01')
,   [FEB_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M02')
,   [MAR_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M03')
,   [APR_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M04')
,   [MAY_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M05')
,   [JUN_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M06')
,   [JUL_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M07')
,   [AUG_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M08')
,   [SEP_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M09')
,   [OCT_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M10')
,   [NOV_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M11')
,   [DEC_13] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2013 and Period = 'M12')
						  
,	[JAN_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M01')
,   [FEB_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M02')
,   [MAR_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M03')
,   [APR_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M04')
,   [MAY_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M05')
,   [JUN_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M06')
,   [JUL_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M07')
,   [AUG_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M08')
,   [SEP_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M09')
,   [OCT_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M10')
,   [NOV_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M11')
,   [DEC_14] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2014 and Period = 'M12')
					
,	[JAN_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M01')
,   [FEB_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M02')
,   [MAR_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M03')
,   [APR_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M04')
,   [MAY_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M05')
,   [JUN_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M06')
,   [JUL_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M07')
,   [AUG_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M08')
,   [SEP_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M09')
,   [OCT_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M10')
,   [NOV_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M11')
,   [DEC_15] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2015 and Period = 'M12')
						  
,	[JAN_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M01')
,   [FEB_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M02')
,   [MAR_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M03')
,   [APR_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M04')
,   [MAY_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M05')
,   [JUN_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M06')
,   [JUL_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M07')
,   [AUG_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M08')
,   [SEP_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M09')
,   [OCT_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M10')
,   [NOV_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M11')
,   [DEC_16] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2016 and Period = 'M12')
						  
,	[JAN_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M01')
,   [FEB_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M02')
,   [MAR_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M03')
,   [APR_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M04')
,   [MAY_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M05')
,   [JUN_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M06')
,   [JUL_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M07')
,   [AUG_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M08')
,   [SEP_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M09')
,   [OCT_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M10')
,   [NOV_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M11')
,   [DEC_17] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2017 and Period = 'M12')
						   
,	[JAN_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M01')
,   [FEB_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M02')
,   [MAR_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M03')
,   [APR_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M04')
,   [MAY_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M05')
,   [JUN_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M06')
,   [JUL_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M07')
,   [AUG_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M08')
,   [SEP_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M09')
,   [OCT_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M10')
,   [NOV_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M11')
,   [DEC_18] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2018 and Period = 'M12')
						 
,	[JAN_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M01')
,   [FEB_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M02')
,   [MAR_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M03')
,   [APR_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M04')
,   [MAY_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M05')
,   [JUN_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M06')
,   [JUL_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M07')
,   [AUG_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M08')
,   [SEP_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M09')
,   [OCT_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M10')
,   [NOV_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M11')
,   [DEC_19] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2019 and Period = 'M12')
						  
,	[JAN_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M01')
,   [FEB_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M02')
,   [MAR_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M03')
,   [APR_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M04')
,   [MAY_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M05')
,   [JUN_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M06')
,   [JUL_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M07')
,   [AUG_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M08')
,   [SEP_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M09')
,   [OCT_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M10')
,   [NOV_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M11')
,   [DEC_20] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2020 and Period = 'M12')
						  
,   [DEC_21] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2021 and Period = 'CY')
,   [DEC_22] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2022 and Period = 'CY')
,   [DEC_23] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2023 and Period = 'CY')
,   [DEC_24] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2024 and Period = 'CY')
,   [DEC_25] = (select min(MaterialCost) from EEIUser.acctg_csm_material_cost_detail where Header_ID = ID and EffectiveYear = 2025 and Period = 'CY')

from
	EEIUser.acctg_csm_material_cost_header h
where
	h.ID in
		(	select
		 		i.Header_ID
		 	from
		 		Inserted i
			union all
			select
				d.Header_ID
			from
				Deleted d
		)


--delete
--SalesForecast (table that was once a view)

--insert
--SalesForecast View (table that was once a view)
GO
ALTER TABLE [EEIUser].[acctg_csm_material_cost_detail] ADD CONSTRAINT [PK__acctg_mcd__9E9692CDC3AB6F4] PRIMARY KEY CLUSTERED  ([Release_ID], [EffectiveYear], [Header_ID], [Period]) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_csm_material_cost_detail] ADD CONSTRAINT [UQ__acctg_cs__E728916EF7A17C44] UNIQUE NONCLUSTERED  ([Release_ID], [Row_ID], [BasePart], [EffectiveYear], [Period]) ON [PRIMARY]
GO
