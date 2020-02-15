USE [DentistClinicDB]
GO
/****** Object:  UserDefinedFunction [dbo].[CalculateTotal]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
			
CREATE FUNCTION [dbo].[CalculateTotal] (@AptTimeDiff FLOAT, @BlockTime INT, @BlockCost FLOAT, @TreatmentSum FLOAT) RETURNS FLOAT AS 
			BEGIN
				RETURN CONVERT(FLOAT, @TreatmentSum + (@BlockCost*CEILING(@AptTimeDiff / @BlockTime))) 
			END
GO
/****** Object:  UserDefinedFunction [dbo].[getPatientTotalPayableAmount]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE 
  FUNCTION [dbo].[getPatientTotalPayableAmount](@PatientID INT) 
returns MONEY AS 
BEGIN
DECLARE @total MONEY
SELECT @total = ( 
                  SELECT   Sum(totalamount) 
                  FROM     invoice 
                  JOIN     appointment 
                  ON       appointment.aptid = invoice.appointmentid 
                  WHERE    patientid = @PatientID 
                  GROUP BY patientid)
				  RETURN @total 
END
GO
/****** Object:  Table [dbo].[Appointment]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Appointment](
	[AptID] [int] NOT NULL,
	[AptDate] [date] NOT NULL,
	[AptTime] [time](7) NOT NULL,
	[AptStatus] [char](1) NOT NULL,
	[VisitReason] [varchar](max) NOT NULL,
	[PatientID] [int] NOT NULL,
	[ProvideID] [int] NOT NULL,
	[RoomID] [int] NULL,
	[ProviderID] [int] NULL,
 CONSTRAINT [PK_Appointment] PRIMARY KEY CLUSTERED 
(
	[AptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BlockTime]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BlockTime](
	[BlockID] [int] NOT NULL,
	[BlockTD] [int] NOT NULL,
	[BlockRate] [float] NOT NULL,
	[ProviderID] [int] NULL,
 CONSTRAINT [PK_BlockTime] PRIMARY KEY CLUSTERED 
(
	[BlockID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConfidentialDocument]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConfidentialDocument](
	[ConfDocID] [bigint] NOT NULL,
	[SSN] [char](9) NOT NULL,
	[AccountNumber] [bigint] NOT NULL,
	[RountingNumber] [bigint] NOT NULL,
	[BankName] [char](100) NOT NULL,
	[TaxIDNumber] [bigint] NOT NULL,
	[ProviderID] [int] NULL,
 CONSTRAINT [PK_ConfidentialDocument] PRIMARY KEY CLUSTERED 
(
	[ConfDocID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Equipment]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Equipment](
	[EqID] [int] NOT NULL,
	[EqName] [varchar](255) NOT NULL,
	[NextMaintenance] [date] NULL,
	[RoomID] [int] NULL,
 CONSTRAINT [PK_Equipment] PRIMARY KEY CLUSTERED 
(
	[EqID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExaminationRecord]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExaminationRecord](
	[ExaminationRecordID] [int] NOT NULL,
	[Plaque] [char](1) NOT NULL,
	[Stains] [char](1) NOT NULL,
	[Abrasions] [char](1) NOT NULL,
	[Overhang] [char](1) NOT NULL,
	[ContactPost] [char](1) NULL,
	[GumColour] [char](1) NOT NULL,
	[GumRecession] [char](1) NULL,
	[Pockets] [char](1) NOT NULL,
	[AppointmentID] [int] NOT NULL,
 CONSTRAINT [PK_ExaminationRecord] PRIMARY KEY CLUSTERED 
(
	[ExaminationRecordID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Insurance]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Insurance](
	[InsuranceID] [int] NOT NULL,
	[InsuranceNumber] [bigint] NOT NULL,
	[InsuranceCompany] [varchar](100) NOT NULL,
	[PatientID] [int] NULL,
 CONSTRAINT [PK_Insurance] PRIMARY KEY CLUSTERED 
(
	[InsuranceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Invoice]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Invoice](
	[TotalAmount] [float] NOT NULL,
	[AppointmentID] [int] NOT NULL,
	[InvoiceID] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[InvoiceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[License]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[License](
	[LicenseID] [int] NOT NULL,
	[LicenseNumber] [bigint] NOT NULL,
	[Speciality] [varchar](50) NULL,
	[LicenseExpiryDate] [date] NOT NULL,
	[LicenseStatus] [varchar](50) NOT NULL,
	[ProviderID] [int] NOT NULL,
 CONSTRAINT [PK_License] PRIMARY KEY CLUSTERED 
(
	[LicenseID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[LocID] [int] NOT NULL,
	[StreetName] [varchar](255) NULL,
	[City] [varchar](50) NOT NULL,
	[State] [char](2) NOT NULL,
	[ZipCode] [char](5) NOT NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[LocID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Patient]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Patient](
	[PatientID] [int] NOT NULL,
	[PatientFN] [varchar](100) NOT NULL,
	[PatientLN] [varchar](100) NOT NULL,
	[PatientAddL1] [varchar](max) NOT NULL,
	[PatientAddL2] [varchar](max) NOT NULL,
	[PatientCity] [varchar](100) NOT NULL,
	[PatientState] [char](2) NOT NULL,
	[PatientZip] [int] NOT NULL,
	[PatientPhone] [bigint] NOT NULL,
	[PatientGender] [char](1) NOT NULL,
	[PatientDOB] [date] NOT NULL,
	[PatientEmail] [varchar](100) NOT NULL,
	[PatientEmergencyName] [varchar](100) NOT NULL,
	[PatientEmergencyNo] [bigint] NOT NULL,
 CONSTRAINT [PK_Patient] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PatientHistory]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PatientHistory](
	[PatientHistoryID] [int] NOT NULL,
	[PatientGenHealth] [varchar](100) NULL,
	[PatientAllergy] [varchar](100) NULL,
	[PatientMedication] [varchar](200) NULL,
	[PatientBP] [char](6) NOT NULL,
	[PatientID] [int] NOT NULL,
 CONSTRAINT [PK_PatientHistory] PRIMARY KEY CLUSTERED 
(
	[PatientHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment](
	[PaymentID] [int] NOT NULL,
	[PaymentMethod] [varchar](250) NOT NULL,
	[PaidAmount] [float] NOT NULL,
	[DateOfPayment] [date] NOT NULL,
	[PaymentDoneBy] [varchar](250) NOT NULL,
	[InvoiceID] [int] NULL,
 CONSTRAINT [PK_Payment] PRIMARY KEY CLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Prescription]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Prescription](
	[PrescriptionID] [int] NOT NULL,
	[PrescriptionImage] [image] NOT NULL,
	[Pharmacy] [varchar](100) NULL,
	[TreatmentID] [int] NOT NULL,
 CONSTRAINT [PK_Prescription] PRIMARY KEY CLUSTERED 
(
	[PrescriptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Provider]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Provider](
	[ProviderID] [int] NOT NULL,
	[ProviderFN] [varchar](100) NOT NULL,
	[ProviderLN] [varchar](100) NOT NULL,
	[ProviderRole] [varchar](20) NOT NULL,
	[ProviderAddL1] [varchar](200) NOT NULL,
	[ProviderAddL2] [varchar](200) NOT NULL,
	[ProviderCity] [varchar](50) NOT NULL,
	[ProviderState] [varchar](50) NOT NULL,
	[ProviderZipCode] [int] NOT NULL,
	[ProviderPhone] [int] NOT NULL,
	[ProviderGender] [char](1) NOT NULL,
	[ProviderEmail] [varchar](50) NOT NULL,
	[ProviderDOB] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Provider] PRIMARY KEY CLUSTERED 
(
	[ProviderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Room]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Room](
	[RoomID] [int] NOT NULL,
	[RoomNumber] [int] NOT NULL,
	[LocID] [int] NULL,
	[EqID] [int] NOT NULL,
 CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supply]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supply](
	[SupplyID] [int] NOT NULL,
	[SupplyName] [varchar](50) NOT NULL,
	[SupplyQty] [int] NOT NULL,
	[LocID] [int] NULL,
 CONSTRAINT [PK_Supply] PRIMARY KEY CLUSTERED 
(
	[SupplyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SystemAccount]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SystemAccount](
	[AccountID] [int] NOT NULL,
	[Username] [varchar](100) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Role] [varchar](100) NOT NULL,
 CONSTRAINT [PK_SystemAccount] PRIMARY KEY CLUSTERED 
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TeethInformation]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TeethInformation](
	[TeethInfoID] [int] NOT NULL,
	[TotalTeeth] [int] NOT NULL,
	[FakeTeeth] [int] NOT NULL,
	[GenCondition] [varchar](255) NULL,
	[PatientID] [int] NULL,
 CONSTRAINT [PK_TeethInformation] PRIMARY KEY CLUSTERED 
(
	[TeethInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TreatmentCatalog]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TreatmentCatalog](
	[TCID] [int] NOT NULL,
	[TreatmentName] [varchar](150) NOT NULL,
	[TreatmentCharge] [float] NOT NULL,
 CONSTRAINT [PK_TreatmentCatalog] PRIMARY KEY CLUSTERED 
(
	[TCID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TreatmentSummary]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TreatmentSummary](
	[TreatmentID] [int] NOT NULL,
	[Notes] [varchar](max) NULL,
	[AppointmentID] [int] NOT NULL,
	[TCID] [int] NULL,
 CONSTRAINT [PK_TreatmentSummary] PRIMARY KEY CLUSTERED 
(
	[TreatmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[BlockTime] ([BlockID], [BlockTD], [BlockRate], [ProviderID]) VALUES (1, 15, 20, 6)
GO
INSERT [dbo].[BlockTime] ([BlockID], [BlockTD], [BlockRate], [ProviderID]) VALUES (3, 20, 20, 6)
GO
INSERT [dbo].[BlockTime] ([BlockID], [BlockTD], [BlockRate], [ProviderID]) VALUES (4, 20, 26, 6)
GO
INSERT [dbo].[Insurance] ([InsuranceID], [InsuranceNumber], [InsuranceCompany], [PatientID]) VALUES (322, 1238191113, N'Blue Cross Blue Sheild', 1)
GO
INSERT [dbo].[License] ([LicenseID], [LicenseNumber], [Speciality], [LicenseExpiryDate], [LicenseStatus], [ProviderID]) VALUES (121, 78555, N'Dentist', CAST(N'2022-01-08' AS Date), N'Valid', 1)
GO
INSERT [dbo].[Location] ([LocID], [StreetName], [City], [State], [ZipCode]) VALUES (100, N'22 huj', N'mumb', N'MA', N'2120 ')
GO
INSERT [dbo].[Patient] ([PatientID], [PatientFN], [PatientLN], [PatientAddL1], [PatientAddL2], [PatientCity], [PatientState], [PatientZip], [PatientPhone], [PatientGender], [PatientDOB], [PatientEmail], [PatientEmergencyName], [PatientEmergencyNo]) VALUES (1, N'Jayshil', N'Jain', N'33 Calumet street', N'Apt 33', N'Boston', N'MA', 2120, 6175463425, N'M', CAST(N'1994-11-22' AS Date), N'sanghvi.ki@husky.neu.edu', N'Tilak', 647362534)
GO
INSERT [dbo].[PatientHistory] ([PatientHistoryID], [PatientGenHealth], [PatientAllergy], [PatientMedication], [PatientBP], [PatientID]) VALUES (723, N'Normal', N'Latex, Penaut, Balsam', N'None', N'120/80', 1)
GO
INSERT [dbo].[PatientHistory] ([PatientHistoryID], [PatientGenHealth], [PatientAllergy], [PatientMedication], [PatientBP], [PatientID]) VALUES (724, N'Heart Patient', N'Pollen', N'None', N'140/80', 1)
GO
INSERT [dbo].[PatientHistory] ([PatientHistoryID], [PatientGenHealth], [PatientAllergy], [PatientMedication], [PatientBP], [PatientID]) VALUES (725, N'Normal', N'None', N'None', N'130/69', 1)
GO
INSERT [dbo].[PatientHistory] ([PatientHistoryID], [PatientGenHealth], [PatientAllergy], [PatientMedication], [PatientBP], [PatientID]) VALUES (726, N'Normal', N' Penaut, Balsam', N'None', N'110/80', 1)
GO
INSERT [dbo].[PatientHistory] ([PatientHistoryID], [PatientGenHealth], [PatientAllergy], [PatientMedication], [PatientBP], [PatientID]) VALUES (727, N'Heart Patient', N'Latex, Insects', N'None', N'162/80', 1)
GO
INSERT [dbo].[PatientHistory] ([PatientHistoryID], [PatientGenHealth], [PatientAllergy], [PatientMedication], [PatientBP], [PatientID]) VALUES (728, N'Diagnosed with Diabetes', N'Sugar, Penaut, Balsam', N'None', N'173/56', 1)
GO
INSERT [dbo].[Provider] ([ProviderID], [ProviderFN], [ProviderLN], [ProviderRole], [ProviderAddL1], [ProviderAddL2], [ProviderCity], [ProviderState], [ProviderZipCode], [ProviderPhone], [ProviderGender], [ProviderEmail], [ProviderDOB]) VALUES (1, N'Kinnari', N'Sanghvi', N'Dentist', N'33 Calumet street', N'Apt 33', N'Boston', N'MA', 2120, 6177, N'F', N'sanghvi.ki@husky.neu.edu', CAST(N'1994-11-22T00:00:00.0000000' AS DateTime2))
GO
INSERT [dbo].[Provider] ([ProviderID], [ProviderFN], [ProviderLN], [ProviderRole], [ProviderAddL1], [ProviderAddL2], [ProviderCity], [ProviderState], [ProviderZipCode], [ProviderPhone], [ProviderGender], [ProviderEmail], [ProviderDOB]) VALUES (6, N'Robinet', N'Comben', N'Assistant', N'00710 Sherman Avenue', N'2 Oakridge Plaza', N'Waterbury', N'Connecticut', 6721, 2039140004, N'M', N'rcomben5@umich.edu', CAST(N'1994-07-21T00:00:00.0000000' AS DateTime2))
GO
INSERT [dbo].[SystemAccount] ([AccountID], [Username], [Password], [Role]) VALUES (21, N'Admin', N'admin', N'Administrator')
GO
INSERT [dbo].[TeethInformation] ([TeethInfoID], [TotalTeeth], [FakeTeeth], [GenCondition], [PatientID]) VALUES (0, 30, 2, N'Moderate', 1)
GO
INSERT [dbo].[TreatmentCatalog] ([TCID], [TreatmentName], [TreatmentCharge]) VALUES (13, N'Tooth Cleaning', 12.99)
GO
/****** Object:  Index [PaymentID]    Script Date: 2/15/2020 5:25:53 PM ******/
ALTER TABLE [dbo].[Payment] ADD  CONSTRAINT [PaymentID] UNIQUE NONCLUSTERED 
(
	[PaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TeethInformation] ADD  DEFAULT ((0)) FOR [FakeTeeth]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [A patient can book multiple appointments] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [A patient can book multiple appointments]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [A provider can have multiple appointments] FOREIGN KEY([ProviderID])
REFERENCES [dbo].[Provider] ([ProviderID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [A provider can have multiple appointments]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [A provider can take many appointments] FOREIGN KEY([ProvideID])
REFERENCES [dbo].[Provider] ([ProviderID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [A provider can take many appointments]
GO
ALTER TABLE [dbo].[Appointment]  WITH CHECK ADD  CONSTRAINT [A room can be used for many appointments] FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[Appointment] CHECK CONSTRAINT [A room can be used for many appointments]
GO
ALTER TABLE [dbo].[BlockTime]  WITH CHECK ADD  CONSTRAINT [Every block will be related to a provider] FOREIGN KEY([ProviderID])
REFERENCES [dbo].[Provider] ([ProviderID])
GO
ALTER TABLE [dbo].[BlockTime] CHECK CONSTRAINT [Every block will be related to a provider]
GO
ALTER TABLE [dbo].[ConfidentialDocument]  WITH CHECK ADD  CONSTRAINT [Every confidential document will be related to one provider] FOREIGN KEY([ProviderID])
REFERENCES [dbo].[Provider] ([ProviderID])
GO
ALTER TABLE [dbo].[ConfidentialDocument] CHECK CONSTRAINT [Every confidential document will be related to one provider]
GO
ALTER TABLE [dbo].[Equipment]  WITH CHECK ADD  CONSTRAINT [A room can have multiple equipments] FOREIGN KEY([RoomID])
REFERENCES [dbo].[Room] ([RoomID])
GO
ALTER TABLE [dbo].[Equipment] CHECK CONSTRAINT [A room can have multiple equipments]
GO
ALTER TABLE [dbo].[ExaminationRecord]  WITH CHECK ADD  CONSTRAINT [An appointment can have only one Examination Record] FOREIGN KEY([AppointmentID])
REFERENCES [dbo].[Appointment] ([AptID])
GO
ALTER TABLE [dbo].[ExaminationRecord] CHECK CONSTRAINT [An appointment can have only one Examination Record]
GO
ALTER TABLE [dbo].[Insurance]  WITH CHECK ADD  CONSTRAINT [A patient can have multiple insurances] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[Insurance] CHECK CONSTRAINT [A patient can have multiple insurances]
GO
ALTER TABLE [dbo].[Invoice]  WITH CHECK ADD  CONSTRAINT [An appoinment can have many invoices] FOREIGN KEY([AppointmentID])
REFERENCES [dbo].[Appointment] ([AptID])
GO
ALTER TABLE [dbo].[Invoice] CHECK CONSTRAINT [An appoinment can have many invoices]
GO
ALTER TABLE [dbo].[License]  WITH CHECK ADD  CONSTRAINT [A provider should have one or many licenses] FOREIGN KEY([ProviderID])
REFERENCES [dbo].[Provider] ([ProviderID])
GO
ALTER TABLE [dbo].[License] CHECK CONSTRAINT [A provider should have one or many licenses]
GO
ALTER TABLE [dbo].[PatientHistory]  WITH CHECK ADD  CONSTRAINT [A patient history can be related to only one patient] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[PatientHistory] CHECK CONSTRAINT [A patient history can be related to only one patient]
GO
ALTER TABLE [dbo].[Payment]  WITH CHECK ADD  CONSTRAINT [An invoice can have different types OF payment] FOREIGN KEY([InvoiceID])
REFERENCES [dbo].[Invoice] ([InvoiceID])
GO
ALTER TABLE [dbo].[Payment] CHECK CONSTRAINT [An invoice can have different types OF payment]
GO
ALTER TABLE [dbo].[Prescription]  WITH CHECK ADD  CONSTRAINT [A prescription is related to only one treatment summary] FOREIGN KEY([TreatmentID])
REFERENCES [dbo].[TreatmentSummary] ([TreatmentID])
GO
ALTER TABLE [dbo].[Prescription] CHECK CONSTRAINT [A prescription is related to only one treatment summary]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [A location can have many Rooms] FOREIGN KEY([LocID])
REFERENCES [dbo].[Location] ([LocID])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [A location can have many Rooms]
GO
ALTER TABLE [dbo].[Room]  WITH CHECK ADD  CONSTRAINT [A room can have multiple equipment] FOREIGN KEY([EqID])
REFERENCES [dbo].[Equipment] ([EqID])
GO
ALTER TABLE [dbo].[Room] CHECK CONSTRAINT [A room can have multiple equipment]
GO
ALTER TABLE [dbo].[Supply]  WITH CHECK ADD  CONSTRAINT [A location can have many supplies] FOREIGN KEY([LocID])
REFERENCES [dbo].[Location] ([LocID])
GO
ALTER TABLE [dbo].[Supply] CHECK CONSTRAINT [A location can have many supplies]
GO
ALTER TABLE [dbo].[TeethInformation]  WITH CHECK ADD  CONSTRAINT [A patient can have many teeth information records] FOREIGN KEY([PatientID])
REFERENCES [dbo].[Patient] ([PatientID])
GO
ALTER TABLE [dbo].[TeethInformation] CHECK CONSTRAINT [A patient can have many teeth information records]
GO
ALTER TABLE [dbo].[TreatmentSummary]  WITH CHECK ADD  CONSTRAINT [A treatment can be related to many Treatment Summary] FOREIGN KEY([TCID])
REFERENCES [dbo].[TreatmentCatalog] ([TCID])
GO
ALTER TABLE [dbo].[TreatmentSummary] CHECK CONSTRAINT [A treatment can be related to many Treatment Summary]
GO
ALTER TABLE [dbo].[TreatmentSummary]  WITH CHECK ADD  CONSTRAINT [An appointment can have multiple treatment summaries] FOREIGN KEY([AppointmentID])
REFERENCES [dbo].[Appointment] ([AptID])
GO
ALTER TABLE [dbo].[TreatmentSummary] CHECK CONSTRAINT [An appointment can have multiple treatment summaries]
GO
/****** Object:  StoredProcedure [dbo].[BlockTimeProc]    Script Date: 2/15/2020 5:25:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[BlockTimeProc](
@BlockID int,
@BlockTD int,
@BlockRate money,
@ProviderID int,
@StatementType nvarchar(20) = ''
)
as
begin
if @StatementType = 'Insert'
begin
insert into BlockTime values (@BlockID, @BlockTD, @BlockRate, @ProviderID)
end
if @StatementType = 'Select'
begin
select * from BlockTime
end
IF @StatementType = 'Update'  
BEGIN  
UPDATE BlockTime SET  
 BlockTD= @BlockTD, ProviderID = @ProviderID,  
BlockRate = @BlockRate  
WHERE BlockID = @BlockID
END  
else IF @StatementType = 'Delete'  
BEGIN  
DELETE FROM BlockTime WHERE BlockID = @BlockID
end
end
GO
