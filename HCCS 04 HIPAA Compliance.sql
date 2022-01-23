

-------HCCS 04 HIPAA Compliance-------

Drop table if exists #course_ids

Declare 

@AO_Key INT = 285
,@Query_Start_Date DATE = '2/1/2020'
,@Query_End_Date DATE = '1/31/2021'





SELECT [course_id]
    
	into #course_ids
  FROM [dbo].[course]

where 
course_name like '%hipaa compliance 0%'
or course_name like '%hipaa compliance 1%'
or course_name like '%hipaa Compliance%Attestation%'
or course_name like '%fy%hipaa%privacy%'
or course_name like '%fy%it%security%'
or course_name like '%FY20%HIPAA%Privacy%and%Security%'
or course_name like '%Childrens%National%Privacy%Security%Course%'
or course_name like '%HIPAA%Compliance%Course%Survey%'
or course_name like '%hipaa compliance%confidentiality statement%'


select distinct
----------------------------------------------------------------------
us.user_student_id,
o.org_name as Organization_Name,
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







--'FY20 HIPAA Privacy and Security',
--'HIPAA Compliance 01: Introduction',
--'HIPAA Compliance 02: HIPAA Awareness',
--'HIPAA Compliance 03: Privacy Rule Introduction',
--'HIPAA Compliance 04: Protected Health Information',
--'HIPAA Compliance 05: Patient Rights',
--'HIPAA Compliance 06: Working with Business Associates',
--'HIPAA Compliance 07: Law Enforcement Uses and Disclosures',
--'HIPAA Compliance 08: Security Rule Introduction',
--'HIPAA Compliance 09: Administrative',
--'HIPAA Compliance 12: Electronic Transactions',
--'HIPAA Compliance 13: Violations and Penalties',
--'HIPAA Compliance: Course Survey',
--'Childrens National Privacy/Security Course',
--'FY21 HIPAA Privacy',
--'FY21 IT Security')
