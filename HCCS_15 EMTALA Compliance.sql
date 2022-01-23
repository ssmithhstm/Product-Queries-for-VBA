

-------HCCS_15 EMTALA Compliance-------

Declare
@Query_Start_Date DATE,
@Query_End_Date DATE,
@AO_Key int




---------Update the 3 rows below to your query parameters----------------------------------

set @AO_Key = 63961 --update with AO Key
set @Query_Start_Date = '5/1/2021' --update with your query start date
set @Query_End_Date = '12/31/2021' --update with your query end date

---------------------------------------------------------------

select distinct
----------------------------------------------------------------------
us.user_student_id,
inst.org_node_id as Institution_ID,
inst.org_node_name as Institution,
dept.org_node_code as Dept_ID,
dept.org_node_name as Department,
inst.org_node_type_id,
----------------------------------------------------------------------

u.last_name,
u.first_name,
u.system_identifier,
u.username,
ci.course_instance_id,
ci.course_name_at_time_of_enrollment,
ci.course_id,
ci.course_instance_id,
ci.course_instance_interaction_mode_id,
ci.estimated_completion_seconds,
cis.description as course_instance_status,
ci.enrollment_datetime,
ci.completion_datetime,
ci.is_deleted,
ci.unenrollment_reason_type_id,
ci.course_instance_status_id




from
dbo.org o with (nolock)
inner join dbo.[user] u with (nolock)
on o.org_id = u.org_id and u.is_deleted = 0
inner join dbo.course_instance ci with (nolock)
on u.user_id = ci.user_id and ci.is_deleted = 0
inner join dbo.course_instance_status cis with (nolock)
on cis.course_instance_status_id = ci.course_instance_status_id




----------------------------------------------------------------------
inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id
inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0
inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0
----------------------------------------------------------------------

where o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date
and o.external_org_id = @AO_Key



and u.username not like '%test%'
and u.last_name not like '%test%'


and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and ci.course_instance_interaction_mode_id not in ('1','6','7') 

and ci.course_name_at_time_of_enrollment like '%emtala compliance%'





--and ci.course_id in (

--'85969D83-D3D9-E611-8744-005056B16BE3',
--'E45BE489-D3D9-E611-8744-005056B16BE3',
--'843109AC-D3D9-E611-8744-005056B16BE3',
--'40EDC0B3-D3D9-E611-8744-005056B16BE3',
--'C5D9DCB9-D3D9-E611-8744-005056B16BE3',
--'672EAAAA-F51C-EA11-8811-005056B17E34',
--'0E5E7352-F61C-EA11-8811-005056B17E34',
--'775901C7-F61C-EA11-8811-005056B17E34',
--'50446A1B-F71C-EA11-8811-005056B17E34',
--'EDCAB562-F71C-EA11-8811-005056B17E34'

--)
Order by 1
