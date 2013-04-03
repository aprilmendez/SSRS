USE [GartmanReport]
GO

/****** Object:  View [dbo].[CustomerYTDSales]    Script Date: 03/17/2013 13:10:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[CustomerYTDSales]
AS
SELECT dbo.CustomerSalesDetail.InvoiceDate, dbo.CustomerSalesDetail.Company, 
               dbo.CustomerSalesDetail.SalesName, dbo.CustomerSalesDetail.BillToCustID, dbo.CustomerSalesDetail.BillToCustName, dbo.CustomerSalesDetail.BillToCity, 
               dbo.CustomerSalesDetail.BillToState, dbo.CustomerSalesDetail.VendorNum, dbo.CustomerSalesDetail.VendorName, dbo.CustomerSalesDetail.FamilyCode, 
               dbo.CustomerSalesDetail.FamilyCodeDesc, dbo.CustomerSalesDetail.Division, dbo.CustomerSalesDetail.DivisionDesc, dbo.SalesDivision.SalesDivision, 
               SUM(dbo.CustomerSalesDetail.ExtendedPrice) AS Price, SUM(dbo.CustomerSalesDetail.ExtendedCost) AS Cost, SUM(dbo.CustomerSalesDetail.Profit) 
               AS Profit
FROM  dbo.CustomerSalesDetail LEFT OUTER JOIN
               dbo.SalesDivision ON dbo.CustomerSalesDetail.FamilyCode = dbo.SalesDivision.FamilyCode

WHERE 
(
	(InvoiceDate between DATEADD(yy, DATEDIFF(yy,0,GETDATE())-1, 0)
	 and DATEADD(yy, -1, getdate()-3) 
	)
or	(InvoiceDate between DATEADD(yy, DATEDIFF(yy,0,GETDATE()), 0) 
	 and (getdate()-3)
	)
)
	
AND dbo.CustomerSalesDetail.Company = 1


GROUP BY dbo.CustomerSalesDetail.InvoiceDate, dbo.CustomerSalesDetail.Company, 
               dbo.CustomerSalesDetail.BillToCustID, dbo.CustomerSalesDetail.BillToCustName, dbo.CustomerSalesDetail.BillToCity, dbo.CustomerSalesDetail.BillToState, 
               dbo.CustomerSalesDetail.VendorNum, dbo.CustomerSalesDetail.VendorName, dbo.CustomerSalesDetail.FamilyCode, dbo.CustomerSalesDetail.FamilyCodeDesc, 
               dbo.CustomerSalesDetail.Division, dbo.CustomerSalesDetail.DivisionDesc, dbo.CustomerSalesDetail.SalesName, dbo.SalesDivision.SalesDivision



GO

