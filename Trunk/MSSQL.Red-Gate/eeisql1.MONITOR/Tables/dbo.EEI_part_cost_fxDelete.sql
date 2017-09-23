CREATE TABLE [dbo].[EEI_part_cost_fxDelete]
(
[part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[price] [numeric] (20, 6) NULL,
[rounded_price] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EEI_part_cost_fxDelete] ADD CONSTRAINT [PK__EEI_part_cost__1CF15040] PRIMARY KEY CLUSTERED  ([part]) ON [PRIMARY]
GO
