


-------CE Unlimited-------

Drop Table if exists #freecourses

Declare
@Query_Start_Date DATE,
@Query_End_Date DATE,
@AO_Key int




---------Update the 3 rows below to your query parameters----------------------------------

set @AO_Key =  --update with AO Key
set @Query_Start_Date =  --update with your query start date
set @Query_End_Date = --update with your query end date

---------------------------------------------------------------


select distinct

course_id

into #freecourses

from dbo.course_category_course_mapping

where course_category_id in (


'3A295160-78E8-E111-9D49-001517135213', 
'611C4BD3-7C31-EA11-ADD4-005056B16096', 
'D52196F9-427B-E611-BBCB-005056B1689B', 
'3C7A3BF9-2F9B-E811-8B4A-005056B10F02', 
'A3FE8384-4C5E-EA11-B5F8-005056B1380A', 
'D7807258-5641-EB11-80DB-005056B13D3F', 
'E778B79F-126E-EA11-9AFA-005056B15839', 
'D097B9AD-126E-EA11-9AFA-005056B15839', 
'F628370D-437B-E611-BBCB-005056B1689B', 
'16F0B798-5D6E-E811-8702-005056B17E48', 
'766DA7CB-A453-11DD-ABE6-000423AF2167', 
'4CD880CE-4C5E-EA11-B5F8-005056B1380A', 
'52CDF038-5641-EB11-80DB-005056B13D3F', 
'B8E4A1C3-210C-E811-8B11-005056B160F2', 
'05677DF9-86DB-E311-A041-005056B1680C', 
'64DA746D-C134-E611-B688-005056B11774', 
'166ED48F-3B82-E011-B8A9-001517135213', 
'A0FD01D0-126E-EA11-9AFA-005056B15839', 
'60D793E5-126E-EA11-9AFA-005056B15839', 
'9BCB1FC6-91AF-DF11-8A59-001517135511')



select distinct

ci.completion_datetime,
ci.course_name_at_time_of_enrollment,
u.username,
u.last_name,
u.first_name,
o.org_name,
inst.org_node_name as Institution,
dept.org_node_name as Department,
ci.course_instance_id,
ci.course_id,
ci.course_instance_interaction_mode_id,
ci.estimated_completion_seconds,
cis.description as course_instance_status,

ci.is_deleted,
ci.unenrollment_reason_type_id,

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
----------------------------------------------------------------------

where o.is_deleted = 0
and ci.completion_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.completion_datetime <= @Query_End_Date  -- Replace Date Here
and u.username not like '%test%'
and u.last_name not like '%test%'

and o.external_org_id = @AO_Key 

and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and ci.course_instance_interaction_mode_id not in ('1','6','7') 

and cccm.course_category_id = '552455CB-0469-E811-B6FF-005056B10E33'

and ci.course_instance_status_id = 3

and ci.course_id not in (select course_id from #freecourses)
