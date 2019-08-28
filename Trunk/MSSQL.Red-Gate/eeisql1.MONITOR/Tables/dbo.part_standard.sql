CREATE TABLE [dbo].[part_standard]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [numeric] (20, 6) NULL,
[cost] [numeric] (20, 6) NULL,
[account_number] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[material] [numeric] (20, 6) NULL,
[labor] [numeric] (20, 6) NULL,
[burden] [numeric] (20, 6) NULL,
[other] [numeric] (20, 6) NULL,
[cost_cum] [numeric] (20, 6) NULL,
[material_cum] [numeric] (20, 6) NULL,
[burden_cum] [numeric] (20, 6) NULL,
[other_cum] [numeric] (20, 6) NULL,
[labor_cum] [numeric] (20, 6) NULL,
[flag] [int] NULL,
[premium] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[qtd_cost] [numeric] (20, 6) NULL,
[qtd_material] [numeric] (20, 6) NULL,
[qtd_labor] [numeric] (20, 6) NULL,
[qtd_burden] [numeric] (20, 6) NULL,
[qtd_other] [numeric] (20, 6) NULL,
[qtd_cost_cum] [numeric] (20, 6) NULL,
[qtd_material_cum] [numeric] (20, 6) NULL,
[qtd_labor_cum] [numeric] (20, 6) NULL,
[qtd_burden_cum] [numeric] (20, 6) NULL,
[qtd_other_cum] [numeric] (20, 6) NULL,
[planned_cost] [numeric] (20, 6) NULL,
[planned_material] [numeric] (20, 6) NULL,
[planned_labor] [numeric] (20, 6) NULL,
[planned_burden] [numeric] (20, 6) NULL,
[planned_other] [numeric] (20, 6) NULL,
[planned_cost_cum] [numeric] (20, 6) NULL,
[planned_material_cum] [numeric] (20, 6) NULL,
[planned_labor_cum] [numeric] (20, 6) NULL,
[planned_burden_cum] [numeric] (20, 6) NULL,
[planned_other_cum] [numeric] (20, 6) NULL,
[frozen_cost] [numeric] (20, 6) NULL,
[frozen_material] [numeric] (20, 6) NULL,
[frozen_burden] [numeric] (20, 6) NULL,
[frozen_labor] [numeric] (20, 6) NULL,
[frozen_other] [numeric] (20, 6) NULL,
[frozen_cost_cum] [numeric] (20, 6) NULL,
[frozen_material_cum] [numeric] (20, 6) NULL,
[frozen_burden_cum] [numeric] (20, 6) NULL,
[frozen_labor_cum] [numeric] (20, 6) NULL,
[frozen_other_cum] [numeric] (20, 6) NULL,
[cost_changed_date] [datetime] NULL,
[qtd_changed_date] [datetime] NULL,
[planned_changed_date] [datetime] NULL,
[frozen_changed_date] [datetime] NULL
) ON [PRIMARY]
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Hiran Coello
-- Create date: Apr/10/2019
-- Description:	Update the Cost_Change_date to current time when the material cost is changed and do a rollup, so we are reflectig there was a change; 
--				It is only tracing the change on the material cost because this is convert o transfer price in EEH; and the update of the part_stanard.price in HN
--				when it detect a change.
-- =============================================
CREATE TRIGGER [dbo].[TG_UpdateChangeDate] 
   ON  [dbo].[part_standard]
   AFTER UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Insert statements for trigger here
	if	update(material_cum) begin
		update	part_standard
		set		cost_changed_date = getdate()
		from	part_standard
				join inserted on part_standard.part = inserted.part
				join deleted on part_standard.part = deleted.part
		where	isnull(deleted.material_cum,0) <> isnull(inserted.material_cum, 0)
    end

END
GO
ALTER TABLE [dbo].[part_standard] ADD CONSTRAINT [PK__part_standard__18AC8967] PRIMARY KEY NONCLUSTERED  ([part]) WITH (FILLFACTOR=80) ON [PRIMARY]
GO
ALTER TABLE [dbo].[part_standard] ADD CONSTRAINT [FK__part_stand__part__0FB750B3] FOREIGN KEY ([part]) REFERENCES [dbo].[part] ([part])
GO
