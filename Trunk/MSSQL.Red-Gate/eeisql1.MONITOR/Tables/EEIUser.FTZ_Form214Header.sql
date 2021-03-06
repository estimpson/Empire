CREATE TABLE [EEIUser].[FTZ_Form214Header]
(
[Box1_ZoneNo] [nvarchar] (400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box2_PortCode] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box3_ImportingVessel] [nvarchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box4_ExportDate] [datetime] NULL,
[Box5_ImportDate] [datetime] NULL,
[Box6_ZoneAdmissionNo] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Box7_USPortofUnlading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box8_ForeignPortofLading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box9_BillofLading] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box10_InwardManifestNo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box11_InbondCarrier] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box12a_ITNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box12b_ITDate] [datetime] NULL,
[Box13_ITFromPort] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box14_StatisticalAnalysis] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box21_HMF] [decimal] (18, 6) NULL,
[Box23_MerchadiseStatus] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box24_ApplicantFirmName] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box25_ApplicantFirmSignature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box26_ApplicantFirmTitle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box27_ApplicantFirmDate] [datetime] NULL,
[Box28_FTZOperatorSignature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box29_FTZOperatorTitle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box30_FTZOperatorDate] [datetime] NULL,
[Box31_PortDirectorSignature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box32_PortDirectorTitle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box33_PortDirecotrDate] [datetime] NULL,
[Box34_PortDirectorSignature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box35_PortDirectorTitle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box36_PortDirectorDate] [datetime] NULL,
[Box37_ApprovalExceptions] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box38_CBPOfficer] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box39_CBPTitle] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box40_CPBStation] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box41_CPBDate] [datetime] NULL,
[Box42_DriversSignature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box43_DriversCartman] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box44_DriversCHLNo] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box45_DriversDate] [datetime] NULL,
[Box46_ReceiptExceptions] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box47_FTZOperatorSignature] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box48_FTZTitle] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Box49_FTZDate] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[FTZ_Form214Header] ADD CONSTRAINT [PK_FTZ_Form214Headera] PRIMARY KEY CLUSTERED  ([Box6_ZoneAdmissionNo]) ON [PRIMARY]
GO
