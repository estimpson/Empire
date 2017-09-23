CREATE TABLE [EEIUser].[acctg_rgni_comparison]
(
[id] [varchar] (75) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Prior_Vendor_Code] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prior_Changed_Date] [datetime] NULL,
[Prior_Purchase_Order] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prior_Bill_of_Lading] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prior_Item] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Prior_Quantity_Received] [decimal] (18, 6) NULL,
[Prior_Unit_Cost] [decimal] (18, 6) NULL,
[Prior_Total_Cost] [decimal] (18, 6) NULL,
[Current_Vendor_Code] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Changed_Date] [datetime] NULL,
[Current_Purchase_Order] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Bill_of_Lading] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Item] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Current_Quantity_Received] [decimal] (18, 6) NULL,
[Current_Unit_Cost] [decimal] (18, 6) NULL,
[Current_Total_Cost] [decimal] (18, 6) NULL,
[PeriodChange] [decimal] (18, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [EEIUser].[acctg_rgni_comparison] ADD CONSTRAINT [PK_actg_rgni_comparison] PRIMARY KEY CLUSTERED  ([id]) ON [PRIMARY]
GO
