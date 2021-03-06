/* Count the ITEMRECH irsrc 'I' transactions for total Net $ */

-- Insert data into DB table on Server from AS400
INSERT CycleCountReport (co,loc,[date],Measurement,Value)

-- Query the daily data from the AS400
SELECT irco				AS Co
	,irloc				AS Loc
	,irdate				AS [Date]
	,'Net'				AS Measurement
	,NetColumn
	
FROM OPENQUERY(GSFL2K,'
 
SELECT irco
	,irloc 
	,irdate
	,SUM(irqty * ircost) AS NetColumn
FROM itemrech ir
WHERE ir.irsrc = ''I''
	  AND ir.irdate = CURRENT_DATE
	  AND ir.irco IN (1,2)
	  AND ir.irloc IN (4,44,64,50,52,41,57,60,42,59,80,81,84)
GROUP BY irco
	,irloc
	,irdate
')