CREATE TABLE [dbo].[tariff_lists]
(
[id] [int] NOT NULL IDENTITY(1, 1),
[Country_Imposing_Tariff] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTS_Code] [varchar] (16) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[HTS_Description] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country_of_Origin_Affected] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Country_of_Origin_Exceptions] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MFN_Duty] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tariff_Rate] [decimal] (18, 4) NULL,
[Total_Duty] [varchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Tariff_Effective_Date] [date] NULL,
[Tariff_Name] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tariff_lists] ADD CONSTRAINT [pk_tariff_lists] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
