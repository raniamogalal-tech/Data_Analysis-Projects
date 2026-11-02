select*from admission
select*from bed
select*from billing
select*from department
select*from diagnostic_test
select*from disease
select*from doctor
select*from drug
select*from drug_inventory
select*from drug_manufacturer
select*from employee
select*from insurance_provider
select*from patient
select*from patient_diagnostic
select*from patient_insurance
select*from prescription
select*from staff_assignment
select*from ward
select department_id,department_name from department

select bed_id,bed_status from bed
where bed_status='Available'

select drug_name,unit_cost from drug
where unit_cost>200

select patient_id,gender from patient
where blood_group in('O-','A-')

select bill_id,total_amount from billing
where total_amount between 50000 and 100000

select bill_id,total_amount,insurance_covered_amount,patient_payable_amount from billing
where insurance_covered_amount >0

select bill_id,total_amount,insurance_covered_amount,patient_payable_amount from billing
where insurance_covered_amount =0

SELECT COUNT(*) AS total_patients_with_insurance
FROM billing
WHERE insurance_covered_amount > 0;

SELECT COUNT(*) AS total_patients_without_insurance
FROM billing
WHERE insurance_covered_amount = 0;

SELECT count(*) total_emergency_cases
FROM admission
WHERE admission_type = 'Emergency';

SELECT count(*) total_elective_cases
FROM admission
WHERE admission_type = 'Elective';

SELECT  count(*) available_beds
FROM bed
WHERE bed_status = 'Available';

SELECT  count(*) Occupied_beds
FROM bed
WHERE bed_status = 'Occupied';

select count(*) as insurance_payment_mode
from billing
where payment_mode='Insurance'

select count(*) as card_payment_mode
from billing
where payment_mode='Card'

select count(*) as UPI_payment_mode
from billing
where payment_mode='UPI'

select count(*) as cash_payment_mode
from billing
where payment_mode='Cash'

select payment_status,payment_mode from billing
where payment_mode='Card' and payment_status='Pending'

select department_name from department
where floor_number=2

select department_name from department
where department_type='Clinical'

SELECT COUNT(*) AS clinical_departments_count
FROM department
WHERE department_type = 'Clinical';

SELECT 
    D.department_name, 
    T.test_category, 
    T.test_name
FROM diagnostic_test T
INNER JOIN department D ON T.department_id = D.department_id;

select doctor_id,qualification from doctor
where experience_years>20 and specialization='Pulmonology'

select country='USA' from drug_manufacturer 
where reliability_rating > 3.5 and contract_status='Active'

SELECT COUNT(*) AS total_count
FROM drug_manufacturer
WHERE reliability_rating > 3.5
  AND contract_status = 'Active'
  AND country = 'USA';

select count(*) as total_doctors
from doctor
select count(*) as total_emp
from employee
select count(*) as total_patients
from patient
select count(*) as total_beds
from bed
select count(*) as total_wards
from ward

select count(*) as morning_shift
from staff_assignment where shift='Morning'
select count(*) as evening_shift
from staff_assignment where shift='Evening'
select count(*) as night_shift
from staff_assignment where shift='Night'


SELECT SUM(total_amount) as total_revenue
FROM billing;

SELECT COUNT(patient_id) AS female_patients_count 
FROM patient 
WHERE gender = 'Female';
SELECT COUNT(patient_id) AS male_patients_count 
FROM patient 
WHERE gender = 'Male';

select count(*) as patients_2020
from admission where admission_date like'%2020%'
select count(*) as patients_2021
from admission where admission_date like'%2021%'
select count(*) as patients_2022
from admission where admission_date like'%2022%'
select count(*) as patients_2023
from admission where admission_date like'%2023%'
select count(*) as patients_2024
from admission where admission_date like'%2024%'
select count(*) as patients_2025
from admission where admission_date like'%2025%'



SELECT
    d.disease_name,
    dr.drug_name,
    p.frequency
FROM prescription p
JOIN admission a ON p.admission_id = a.admission_id
JOIN disease d ON a.disease_id = d.disease_id
JOIN drug dr ON p.drug_id = dr.drug_id;

SELECT
    d.department_name,
    w.ward_type,
    SUM(w.total_beds) AS total_beds
FROM department d
JOIN ward w ON d.department_id = w.department_id
 
GROUP BY d.department_name, w.ward_type;

SELECT
    shift,
    COUNT(*) AS staff_count
FROM staff_assignment
GROUP BY shift;

select 
d.drug_name,
di.current_stock
from drug d
join drug_inventory di on d.drug_id=di.drug_id


CREATE VIEW vw_patient_admission_details AS
SELECT 
    a.admission_id,
    p.patient_id,
    p.gender,
    p.city,
    d.disease_name,
    dep.department_name,
    w.ward_name,
    b.bed_number,
    a.admission_status,
    DATEDIFF(day, a.admission_date,a.discharge_date) AS days_spent
FROM admission a
JOIN patient p ON a.patient_id = p.patient_id
LEFT JOIN disease d ON a.disease_id = d.disease_id
LEFT JOIN department dep ON a.department_id = dep.department_id
LEFT JOIN ward w ON a.ward_id = w.ward_id
LEFT JOIN bed b ON a.bed_id = b.bed_id;    


CREATE VIEW vw_billing_summary AS
SELECT 
    b.bill_id,
    a.admission_id,
    p.patient_id,
    b.bill_date,
    b.total_amount,
    b.insurance_covered_amount,
    b.patient_payable_amount,
    b.payment_status
FROM billing b
JOIN admission a ON b.admission_id = a.admission_id
JOIN patient p ON a.patient_id = p.patient_id;

CREATE VIEW vw_prescription_details AS
SELECT 
    pr.prescription_id,
    pr.admission_id,
    dr.drug_name,
    dr.drug_category,
    pr.dosage,
    pr.frequency,
    pr.duration_days,
    dm.manufacturer_name
FROM prescription pr
JOIN drug dr ON pr.drug_id = dr.drug_id
LEFT JOIN drug_manufacturer dm ON dr.manufacturer_id = dm.manufacturer_id;

CREATE VIEW vw_bed_details AS
SELECT 
    w.ward_name,
    COUNT(b.bed_id) AS total_beds,
    SUM(CASE WHEN b.bed_status = 'Occupied' THEN 1 ELSE 0 END) AS occupied_beds,
    SUM(CASE WHEN b.bed_status = 'Available' THEN 1 ELSE 0 END) AS available_beds
FROM bed b
JOIN ward w ON b.ward_id = w.ward_id
GROUP BY w.ward_name;



CREATE VIEW vw_patient_insurance_details AS
SELECT 
    p.patient_id,
    ip.provider_name,
    pi.coverage_percentage,
    pi.policy_start_date,
    pi.policy_end_date
FROM patient_insurance pi
JOIN patient p ON pi.patient_id = p.patient_id
JOIN insurance_provider ip ON pi.insurance_provider_id = ip.insurance_provider_id;

CREATE VIEW vw_hospital_kpis AS
SELECT
    (SELECT COUNT(*) FROM patient) AS total_patients,
    (SELECT COUNT(*) FROM doctor) AS total_doctors,
    (SELECT COUNT(*) FROM employee) AS total_employees,
    (SELECT COUNT(*) FROM bed) AS total_beds,
    (SELECT COUNT(*) FROM ward) AS total_wards,
    (SELECT COUNT(*) FROM admission WHERE admission_type='Emergency') AS total_emergency_cases,
    (SELECT COUNT(*) FROM admission WHERE admission_type='Elective') AS total_elective_cases,
    (SELECT SUM(total_amount) FROM billing) AS total_revenue;

CREATE VIEW vw_admissions_by_year AS
SELECT 
    YEAR(admission_date) AS admission_year,
    COUNT(*) AS total_patients
FROM admission
GROUP BY YEAR(admission_date);

CREATE VIEW vw_payment_mode_summary AS
SELECT 
    payment_mode,
    COUNT(*) AS total_transactions,
    SUM(total_amount) AS total_amount
FROM billing
GROUP BY payment_mode;

create view vw_bed_states as
select
(SELECT COUNT(*) FROM bed WHERE bed_status='Available') AS total_Available_beds,
(SELECT COUNT(*) FROM bed WHERE bed_status='Occupied') AS total_Occupied_beds

create view vw_department_details as
SELECT
    department_type,
    COUNT(*) AS total_departments
FROM department
GROUP BY department_type;

CREATE VIEW vw_gender_distribution AS
SELECT 
    gender,
    COUNT(*) AS total_patients
FROM patient
GROUP BY gender;