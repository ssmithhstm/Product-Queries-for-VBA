


SELECT 
[adhoc].[UserData].[Affiliation] AS 'Facility', [adhoc].[UserData].[User Full Name] AS 'User Full Name', 
[adhoc].[UserData].[User ID] AS 'User ID', [adhoc].[UserData].[Is Active] 'Active', 
[adhoc].[Assessment].[Name] AS 'Assessment', 
[adhoc].[Assessment].[State] AS 'Status', [adhoc].[AssessmentSection].[Name] AS 'Section', 
[adhoc].[Assessment].[Assessment Start Date] AS 'Assessment Start Date', 
[adhoc].[Assessment].[Assessment Due Date] AS 'Assessment Due Date'

FROM [adhoc].[UserData] WITH(NOLOCK) 
INNER JOIN [adhoc].[Assessment] WITH(NOLOCK)  ON [adhoc].[Assessment].[Student ID]=[adhoc].[UserData].[User Student Key]
INNER JOIN [adhoc].[AssessmentSection] WITH(NOLOCK)  ON [adhoc].[AssessmentSection].[Assessment ID]=[adhoc].[Assessment].[Assessment ID]

WHERE  ([adhoc].[Assessment].[Assessment Start Date] BETWEEN '2021-01-01' AND '2021-12-31') --UPDATE DATES HERE
AND ([adhoc].[Assessment].[Interaction Mode] = N'Standard') 
and [adhoc].[UserData].[External_Org_ID] = 57278 --INSERT AO KEY

GROUP BY [adhoc].[UserData].[Affiliation], [adhoc].[UserData].[User Full Name], [adhoc].[UserData].[User ID], 
[adhoc].[UserData].[Is Active], [adhoc].[Assessment].[Name], [adhoc].[Assessment].[State], [adhoc].[AssessmentSection].[Name], 
[adhoc].[Assessment].[Assessment Start Date], [adhoc].[Assessment].[Assessment Due Date];

