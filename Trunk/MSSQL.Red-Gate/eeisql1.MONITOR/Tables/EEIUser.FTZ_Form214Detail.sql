CREATE TABLE [EEIUser].[FTZ_Form214Detail]
(
[Box6_ZoneAdmissionNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL,
[Box15a_PackageCount] [decimal] (18, 6) NULL,
[Box15b_CountryofOrigin] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box16_MerchandiseDescription] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box17_HTSUS] [varchar] (12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box18_Quantity] [decimal] (18, 6) NULL,
[Box19a_GrossWeight] [decimal] (18, 6) NULL,
[Box19b_UOM] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box20_Value] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[FTZ_Form214Detail] ADD CONSTRAINT [PK_FTZ_Form214Detail] PRIMARY KEY CLUSTERED  ([Box6_ZoneAdmissionNo], [RowID]) ON [PRIMARY]
GO
