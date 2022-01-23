

-------HCCS_40 Preventing Sexual Harassment-------
drop table if exists #course_ids

Declare
@Query_Start_Date DATE,
@Query_End_Date DATE,
@AO_Key int




---------Update the 3 rows below to your query parameters----------------------------------

set @AO_Key = 285 --update with AO Key
set @Query_Start_Date = '2/1/2021' --update with your query start date
set @Query_End_Date = '10/27/2021' --update with your query end date

---------------------------------------------------------------





SELECT [course_id]
    
	into #course_ids
  FROM [dbo].[course]

  where 
course_name like '%preventing sexual harassment%'

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
and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date
and o.external_org_id = @AO_Key


 and u.username not like '%test%'
and u.last_name not like '%test%'


and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and ci.course_instance_interaction_mode_id not in ('1','6','7') 

and ci.course_id in (select * from #course_ids)

-- and ci.course_name_at_time_of_enrollment in (

--'Preventing Sexual Harassment 01: Introduction',
--'Preventing Sexual Harassment 02: Types of Harassment',
--'Preventing Sexual Harassment 03: Seeking Guidance',
--'Preventing Sexual Harassment 04: Impact of Sexual Harassment',
--'Preventing Sexual Harassment 05: Sexual Harassment Protection in the Workplace',
--'Preventing Sexual Harassment 06: Sexual Harassment Policy and Procedure',
--'Preventing Sexual Harassment 07: Inappropriate and Harassing Behavior',
--'Preventing Sexual Harassment 08: Determining When and How to Take Action',
--'Preventing Sexual Harassment 09: Formal Complaints',
--'Preventing Sexual Harassment 10: State Specific Regulations',
--'Preventing Sexual Harassment 11: Sexual Harassment Awareness',
--'Preventing Sexual Harassment: Course Survey'
--)

order by 1
