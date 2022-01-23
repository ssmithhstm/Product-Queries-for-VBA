

-------HCCS_02 Corporate Compliance-------
Drop table if exists #course_ids


Declare 

@AO_Key INT = 
,@Query_Start_Date DATE = 
,@Query_End_Date DATE = 



SELECT [course_id]
    
	into #course_ids
  FROM [dbo].[course]

  where 
course_name like '%corporate compliance%'
or course_name like '%fy%corporate compliance%'
or course_name like '%fy%compliance%'
or course_name like '%Corporate Compliance%Course Survey%'
or course_name like '%Corporate%Compliance%Attestation%'
or course_name like  '%Corporate%Compliance%New%Hire%Training%'
or course_name like  '%Corporate%Compliance%Annual%Training%'
or course_name like '%information security%acceptable use workforce communication attestation%'

select distinct
----------------------------------------------------------------------
us.user_student_id,
o.org_name,
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
on u.user_id = ci.user_id
inner join dbo.course_instance_status cis with (nolock)
on cis.course_instance_status_id = ci.course_instance_status_id


inner join dbo.course_category_course_mapping cccm with (nolock)
on ci.course_id = cccm.course_id

inner join dbo.course_category cc with (nolock)
on cccm.course_category_id = cc.course_category_id
----------------------------------------------------------------------
inner join dbo.user_student us with (nolock)
on us.user_student_id = ci.user_student_id
inner join dbo.org_node dept with (nolock)
on us.org_node_id = dept.org_node_id and dept.is_deleted = 0
inner join dbo.org_node inst with (nolock)
on dept.parent_org_node_id = inst.org_node_id and inst.is_deleted = 0
----------------------------------------------------------------------

where










o.is_deleted = 0
and ci.enrollment_datetime >= @query_start_date  -- Replace Date Here
and ci.enrollment_datetime <= @query_end_date
and o.external_org_id = @ao_key



and u.username not like '%test%'
and u.last_name not like '%test%'

and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and ci.course_instance_interaction_mode_id not in ('1','6','7') 

and ci.course_id in (select * from #course_ids)
and ci.course_name_at_time_of_enrollment not in ('Corporate Compliance and Ethics')
and ci.course_name_at_time_of_enrollment not like '%Corporate%Compliance%Ethics%E%tica%y%Cumplimiento%Corporativo%'
and ci.course_name_at_time_of_enrollment not IN ('Corporate Compliance Standards of Conduct')
and ci.course_name_at_time_of_enrollment not IN ('Getting Started With Pyxis Medstation & Supply Station & Corporate Compliance')


and ci.course_name_at_time_of_enrollment not IN ('Corporate Compliance-Privacy-Information Security - Managers')
and ci.course_name_at_time_of_enrollment not IN ('Corporate Compliance-Privacy-Information Security - Employees')


--and ci.course_name_at_time_of_enrollment in (

--'FY20 Compliance',
--'Corporate Compliance New Hire Training',
--'Corporate Compliance Annual Training',
--'Corporate Compliance 01: Introduction',
--'Corporate Compliance 02: Compliance Risk Areas',
--'Corporate Compliance 03: Compliance Program',
--'Corporate Compliance 04: Stark Law',
--'Corporate Compliance 05: Anti-Kickback Statute',
--'Corporate Compliance 06: Documentation',
--'Corporate Compliance: Attestation',
--'Corporate Compliance: Course Survey',
--'FY21 Corporate Compliance')
