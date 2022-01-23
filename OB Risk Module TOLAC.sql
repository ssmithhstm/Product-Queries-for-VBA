Select Distinct

u.username,
ci.enrollment_datetime,
ci.completion_datetime,
ci.course_name_at_time_of_enrollment,
o.external_org_id as AO_Key,
o.org_name,
inst.org_node_name as Institution,
dept.org_node_name as Department,
ci.course_id,
ci.course_instance_id,
ci.course_instance_interaction_mode_id,
ci.estimated_completion_seconds,
cis.description as course_instance_status,
us.user_student_id,
inst.org_node_id as Institution_ID,
dept.org_node_code as Dept_ID



from
dbo.org o with (nolock)

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


where o.is_deleted = 0
and ci.enrollment_datetime >= @Query_Start_Date  -- Replace Date Here
and ci.enrollment_datetime <= @Query_End_Date  -- Replace Date Here

and u.username not like '%test%'
and u.last_name not like '%test%'
and o.external_org_id = @AO_Key 

and ((ci.unenrollment_reason_type_id not in ('1','4','5')) or (ci.unenrollment_reason_type_id is null)) --remove unenrollments where record shouldn't be counted

and ((ci.enrollment_datetime <= ci.completion_datetime) or (ci.completion_datetime is null)) --remove imported records

and ci.course_instance_interaction_mode_id not in ('1','6','7') 

and ci.course_id in (

'f29368c3-c3f4-e811-bdde-005056b1380a',
'89fc152c-bdc3-e611-a4a4-005056b1633e',
'6a863024-1836-e911-bf14-005056b1418b',
'05ce1c84-26c4-e911-814d-005056b14d10'



)
order by 1
