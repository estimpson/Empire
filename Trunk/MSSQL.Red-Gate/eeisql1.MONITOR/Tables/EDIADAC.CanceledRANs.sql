CREATE TABLE [EDIADAC].[CanceledRANs]
(
[RANNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [EDIADAC].[CanceledRANs] ADD CONSTRAINT [PK_CanceledRANs_1_1] PRIMARY KEY CLUSTERED  ([RANNumber]) ON [PRIMARY]
GO