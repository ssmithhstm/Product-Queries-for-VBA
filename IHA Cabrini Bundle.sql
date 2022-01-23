


-----IHA CABRINI BUNDLE----------



Declare
@Query_Start_Date DATE,
@Query_End_Date DATE,
@AO_Key int




---------Update the 3 rows below to your query parameters----------------------------------

set @AO_Key =  --update with AO Key
set @Query_Start_Date =  --update with your query start date
set @Query_End_Date =  --update with your query end date

---------------------------------------------------------------



select distinct

ci.enrollment_datetime,
ci.course_name_at_time_of_enrollment,
u.username,
u.last_name,
u.first_name,
o.org_name,
inst.org_node_name as Institution,
dept.org_node_name as Department,
ci.course_instance_id,
ci.course_id,
ci.score,
ci.course_instance_interaction_mode_id,
ci.estimated_completion_seconds,
cis.description as course_instance_status,
ci.completion_datetime,
ci.is_deleted,
ci.unenrollment_reason_type_id,
us.job_title_id,
jt.job_title_name,
jt.job_title_code,


o.external_org_id as AO_Key,
us.user_student_id,
inst.org_node_id as Institution_ID,
dept.org_node_code as Dept_ID,
inst.org_node_type_id
----------------------------------------------
from
dbo.org o with (nolock)
----------------------------------------------------------------------
inner join dbo.[user] u with (nolock)
on o.org_id = u.org_id and u.is_deleted = 0

inner join dbo.course_instance ci with (nolock)
on u.user_id = ci.user_id  	and ci.is_deleted in (0,1)

inner join dbo.course_instance_status cis with (nolock)
on cis.course_instance_status_id = ci.course_instance_status_id

inner join dbo.course_category_course_mapping cccm with (nolock)
on ci.course_id = cccm.course_id

inner join dbo.course_category cc with (nolock)
on cccm.course_category_id = cc.course_category_id

inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id

inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0

inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0

inner join dbo.job_title jt
on jt.job_title_id = us.job_title_id
----------------------------------------------------------------------

where o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date  -- Replace Date Here

and u.username not like '%test%'
and u.last_name not like '%test%'
and o.external_org_id = @AO_Key 

and (ci.unenrollment_reason_type_id not in ('1','5') or ci.unenrollment_reason_type_id is null) --remove unenrollments where record shouldn't be counted

and (ci.enrollment_datetime <= ci.completion_datetime or ci.completion_datetime is null) --remove imported records

and ci.course_instance_interaction_mode_id <> 6 --remove exempt users from data

and ci.course_instance_status_id = 3

and ci.course_id in (
'E932616C-14A2-EB11-80E1-005056B107A8', 
'3B1A7B1D-19A2-EB11-80E1-005056B107A8', 
'CCAC71A9-19A2-EB11-80E1-005056B107A8', 
'93AD8D33-DA04-EC11-80E4-005056B108B1', 
'85FAEA7F-DB04-EC11-80E4-005056B108B1', 
'3C597A98-DC04-EC11-80E4-005056B108B1', 
'79FFC2EA-1CF6-EB11-80E4-005056B1202E', 
'7C26043C-103B-EC11-80E8-005056B1202E', 
'BDBEF37F-8DA6-EB11-80E0-005056B134EC', 
'2E7A9AF4-C6A9-EB11-80E0-005056B134EC', 
'8AA5F2EE-C7A9-EB11-80E0-005056B134EC', 
'BEDF50E1-DCB8-EB11-80E2-005056B135DF', 
'DE7E3252-D1A9-EB11-80E0-005056B13961', 
'40564F1E-D2A9-EB11-80E0-005056B13961', 
'B160B204-91A6-EB11-80E1-005056B13D3F', 
'733A71FD-93A6-EB11-80E1-005056B13D3F', 
'8B7CD6A7-96A6-EB11-80E1-005056B13D3F', 
'79B2B1F7-97A6-EB11-80E1-005056B13D3F', 
'019319E8-99A6-EB11-80E1-005056B13D3F', 
'FFC0ABCF-9AA6-EB11-80E1-005056B13D3F', 
'218A6391-BF17-EC11-80E7-005056B143AA', 
'535BD701-85FF-EB11-80E6-005056B145B3', 
'3161532B-86FF-EB11-80E6-005056B145B3', 
'26FF4084-86FF-EB11-80E6-005056B145B3', 
'C0ADFCDC-86FF-EB11-80E6-005056B145B3', 
'6947E39D-AEA2-EB11-80E0-005056B14C8B', 
'532936DC-B0A2-EB11-80E0-005056B14C8B', 
'0048B834-B5A2-EB11-80E0-005056B14C8B', 
'C6EEEB1B-B6A2-EB11-80E0-005056B14C8B', 
'87F2D414-9914-EC11-80E7-005056B14E20', 
'72B8598A-9A14-EC11-80E7-005056B14E20', 
'592F4DF1-9A14-EC11-80E7-005056B14E20', 
'F99BB65E-9B14-EC11-80E7-005056B14E20', 
'21E9F361-12B8-EB11-80E1-005056B17014', 
'07ECE970-0805-EC11-80E8-005056B17C18', 
'7F432F23-0905-EC11-80E8-005056B17C18', 
'66385BA5-0905-EC11-80E8-005056B17C18', 
'67A21A20-0A05-EC11-80E8-005056B17C18', 
'2F3180E9-0A05-EC11-80E8-005056B17C18', 
'22344740-0B05-EC11-80E8-005056B17C18', 
'4AE01132-4F16-EC11-80E8-005056B17C18', 
'2E77DAC4-4F16-EC11-80E8-005056B17C18', 
'37A54F53-5016-EC11-80E8-005056B17C18', 
'8A9276B4-5016-EC11-80E8-005056B17C18', 
'96DC1D00-96B1-EB11-80E2-005056B11ACC', 
'DC988ED8-9EB1-EB11-80E2-005056B11ACC', 
'0D5C70AD-A2B1-EB11-80E2-005056B11ACC', 
'0B883E46-D34B-E911-B50B-005056B11EEE', 
'61B0696F-C0B1-EB11-80E1-005056B12BBF', 
'96AD0BA6-CFB1-EB11-80E1-005056B12BBF', 
'83C46ACC-639D-E711-8747-005056B13023', 
'2D170103-BDF5-E411-A643-005056B130EF', 
'BE1904AD-BDA6-EB11-80E1-005056B135DF', 
'3DB09C7D-64A7-EB11-80E1-005056B135DF', 
'05FEA5AD-8CA7-EB11-80E1-005056B135DF', 
'065B625A-94A7-EB11-80E1-005056B135DF', 
'1691339F-1FA8-EB11-80E1-005056B135DF', 
'8EB22149-25A8-EB11-80E1-005056B135DF', 
'E3D10160-2AA8-EB11-80E1-005056B135DF', 
'2BE02769-30A8-EB11-80E1-005056B135DF', 
'0BE2A054-3AA8-EB11-80E1-005056B135DF', 
'52B58AD6-6ACF-EB11-80E3-005056B135DF', 
'6E2D4E99-1763-E611-B8CD-005056B136CB', 
'E17175C6-4306-E511-A6A0-005056B1380A', 
'37C7C038-3271-EB11-80DE-005056B14204', 
'C41FA864-3371-EB11-80DE-005056B14204', 
'42F4492C-BC8C-EB11-80DF-005056B14204', 
'C3E31222-9AAE-EB11-80E1-005056B143F3', 
'46B69FD6-9FAE-EB11-80E1-005056B143F3', 
'F2E38865-DDA1-EB11-80E0-005056B14C8B', 
'CC5BD922-E5A1-EB11-80E0-005056B14C8B', 
'C12DB413-EBA1-EB11-80E0-005056B14C8B', 
'EAF973A1-EEA1-EB11-80E0-005056B14C8B', 
'FB8D5B3F-F4A1-EB11-80E0-005056B14C8B', 
'EC770D65-FAA1-EB11-80E0-005056B14C8B', 
'7A008553-08A2-EB11-80E0-005056B14C8B', 
'475DFE2E-18A2-EB11-80E0-005056B14C8B', 
'6D2B6A38-1EA2-EB11-80E0-005056B14C8B', 
'7541F386-5CBD-EB11-80E1-005056B14C8B', 
'DDF6F28C-6ABD-EB11-80E1-005056B14C8B', 
'86AC04A9-6EBD-EB11-80E1-005056B14C8B', 
'B959C0E1-6246-E911-942C-005056B14F90', 
'EE25047E-9AB1-EB11-80E1-005056B150D4', 
'8C986DF0-9CB1-EB11-80E1-005056B150D4', 
'085A79C5-9FB1-EB11-80E1-005056B150D4', 
'3A136C97-A0B1-EB11-80E1-005056B150D4', 
'B5B31BA0-A1B1-EB11-80E1-005056B150D4', 
'BB624343-F5FD-EA11-B419-005056B1594F', 
'02B09AE1-12FE-EA11-B419-005056B1594F', 
'C98462FF-A3E7-EA11-A251-005056B15B8C', 
'CD5ED9D1-DB4B-E911-91BB-005056B16096', 
'CD3C21AF-4F9D-EB11-80DE-005056B160AF', 
'05E2355B-F69D-EB11-80DE-005056B160AF', 
'BDCC8CF1-019E-EB11-80DE-005056B160AF', 
'B8440AF7-149E-EB11-80DE-005056B160AF', 
'78FC30E4-90B1-EB11-80E1-005056B16973', 
'36526B72-93B1-EB11-80E1-005056B16973', 
'C0D9CBBF-94B1-EB11-80E1-005056B16973', 
'3F39348A-99B1-EB11-80E1-005056B16973', 
'A530DA32-9BB1-EB11-80E1-005056B16973', 
'E74DAC0A-9EB1-EB11-80E1-005056B16973', 
'E8F50BE9-B2A2-EB11-80E0-005056B1753E', 
'43661211-DBB7-EB11-80E1-005056B176BA', 
'F0AAECA1-E6B7-EB11-80E1-005056B176BA', 
'D3B16520-A6A2-EB11-80E0-005056B17FCD', 
'388DE15C-6AC0-4AEE-907B-0377A653AEA8', 
'3982BA5B-7219-4444-A775-385CA410D537', 
'13BC4CD3-34B8-4E80-A795-3F61E76F1E4F', 
'EFF7A9D9-A18D-4769-B3D1-4BFBE3873D1D', 
'EC32027D-1062-47C6-B8EF-67D17312FB6D', 
'67C141CA-0ECB-496E-BCB2-77EDD606F762', 
'F1F7F16A-5A9D-4E9C-9B56-899A24662A43', 
'C3C3A819-AD8A-4089-BB0D-D50AC4D063F7', 
'B4023E4B-9C47-4521-AF79-D993E5E1C88E', 
'F3266AB6-EF5A-44DA-8E52-DD7891C41D17')

 order by 1