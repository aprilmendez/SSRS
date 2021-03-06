

/********************************************
*											*
* Programmer: James Tuttle					*
* Date: 06/08/2012							*
*											*
* Purpose: Create a report in SQL that		*
* mirrors the manual report that marketing  *
* built in Excel							*
*											*
* Others Invovled: Thomas V and Holiday		*
*-------------------------------------------*
* PGR: James Tuttle		DATE:06/14/2012		*
* Added Search by George per Holiday to		*
*  seperate the co1 & 2 searches on the		*
*  As400: HPRO -co1 and KPRO for co2		*
*********************************************/

-- 09/06/2013 SR# James Tuttle
-- 11/15/2013 SR# 15925 James TUttle

ALTER PROC [dbo].[JT_TAS_products_displays_samples_PM] AS
BEGIN
	SELECT *
	FROM OPENQUERY(GSFL2K,
		  'SELECT imcolimit as Company
		  ,imsamp as Parent_Sku
		  ,imitem as Sample_Sku
		  ,imdesc as Product_Description
		  ,CASE
			WHEN imdrop = ''D'' THEN ''Drop''
			ELSE '' ''
		   END as Drops
	/*------- Contiguous US locations ----------------------------------------------------------------------------------*/				
		  ,(SELECT COALESCE(SUM(itembal.ibqoh),0) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc NOT IN(84,81) AND itembal.ibitem = im.imitem) AS Cont_US_Stock
		  ,(SELECT COALESCE(SUM((itembal.ibqoh) - (itembal.ibqoo)),0)FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc NOT IN(84,81) AND itembal.ibitem = im.imitem) AS Cont_US_Avbl
		  ,(SELECT COALESCE(SUM(ooline.olqbo),0) FROM ooline WHERE ooline.olico = 2
				AND ooline.oliloc NOT IN(84,81) AND ooline.olitem = im.imitem) AS Cont_US_BO	
		  ,(SELECT COALESCE(SUM(poline.plqord - poline.plqrec),0) FROM poline WHERE poline.plco = 2
				AND poline.plloc NOT IN(84,81) AND poline.plitem = im.imitem) AS Cont_US_PO	
	/*------- Anchorage locations --------------------------------------------------------------------------------------*/				
		  ,(SELECT COALESCE(SUM(itembal.ibqoh),0) FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc = 81 AND itembal.ibitem = im.imitem) AS AK_Stock
		  ,(SELECT COALESCE(SUM((itembal.ibqoh) - (itembal.ibqoo)),0)FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc = 81 AND itembal.ibitem = im.imitem) AS AK_Avbl
		  , (SELECT	COALESCE(SUM(ooline.olqbo),0) FROM ooline WHERE ooline.olico = 2
				AND ooline.oliloc = 81 AND ooline.olitem = im.imitem) AS AK_BO	
		  ,(SELECT COALESCE(SUM(poline.plqord - poline.plqrec),0) FROM poline WHERE poline.plco = 2
				AND poline.plloc = 81 AND poline.plitem = im.imitem) AS AK_PO		
	/*------- Hawaii location -----------------------------------------------------------------------------------------*/
		  ,(SELECT COALESCE(SUM(itembal.ibqoh),0) FROM itembal WHERE itembal.ibco = 2
				AND itembal.ibloc = 84 AND itembal.ibitem = im.imitem) AS HI_Stock
		  ,(SELECT COALESCE(SUM((itembal.ibqoh) - (itembal.ibqoo)),0)FROM itembal WHERE itembal.ibco = 2 
				AND itembal.ibloc = 84 AND itembal.ibitem = im.imitem) AS HI_Avbl
		  , (SELECT	COALESCE(SUM(ooline.olqbo),0) FROM ooline WHERE ooline.olico = 2
				AND ooline.oliloc = 84 AND ooline.olitem = im.imitem) AS Hi_BO
		  ,(SELECT COALESCE(SUM(poline.plqord - poline.plqrec),0) FROM poline WHERE poline.plco = 2
				AND poline.plloc = 84 AND poline.plitem = im.imitem) AS HI_PO	
	/*------- End of locations -----------------------------------------------------------------------------------------*/						
		  ,''        '' as Comments
		  FROM itemxtra ix
		   JOIN itemmast im
				ON im.imitem = ix.imxitm
		  WHERE ((ix.imsearch LIKE ''%HPRO%'') OR (ix.imsearch LIKE ''%KPRO%''))
			AND ix.imcolimit IN (0,2)
			AND im.imdrop != ''D''
			
		  ORDER BY ix.imcolimit
				,im.imitem
		  ')
END

GO


