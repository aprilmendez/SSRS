
USE ReportServer
GO


SELECT     Schedule.ScheduleID AS SQLAgent_Job_Name, 
			Subscriptions.Description AS sub_desc, 
			Subscriptions.DeliveryExtension AS sub_delExt, 
             [Catalog].[Description] AS Descript,
             [Catalog].Name AS ReportName, 
             [Catalog].Path AS ReportPath
FROM         ReportSchedule INNER JOIN
                      Schedule ON ReportSchedule.ScheduleID = Schedule.ScheduleID INNER JOIN
                      Subscriptions ON ReportSchedule.SubscriptionID = Subscriptions.SubscriptionID INNER JOIN
                      [Catalog] ON ReportSchedule.ReportID = [Catalog].ItemID AND Subscriptions.Report_OID = [Catalog].ItemID
WHERE [Catalog].Name LIKE 'JT%'
	--AND [Catalog].[Description] LIKE '%SQL01%'
