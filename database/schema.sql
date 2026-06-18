PRAGMA foreign_keys = ON;

--------------------------------------------------
-- BUSINESS TABLES
--------------------------------------------------

CREATE TABLE department (
    department_id INTEGER PRIMARY KEY,
    department_code TEXT,
    department_name TEXT,
    business_unit TEXT,
    division TEXT
);

CREATE TABLE position (
    position_id INTEGER PRIMARY KEY,
    position_code TEXT,
    position_name TEXT,
    grade TEXT,
    band TEXT,
    job_family TEXT
);

CREATE TABLE manager (
    manager_id INTEGER PRIMARY KEY,
    manager_name TEXT,
    manager_email TEXT
);

CREATE TABLE location (
    location_id INTEGER PRIMARY KEY,
    location_name TEXT,
    city TEXT,
    state TEXT,
    country TEXT
);

CREATE TABLE cost_center (
    cost_center_id INTEGER PRIMARY KEY,
    cost_center_code TEXT,
    cost_center_name TEXT
);

CREATE TABLE employee (
    employee_id INTEGER PRIMARY KEY,
    employee_number TEXT UNIQUE,
    first_name TEXT,
    last_name TEXT,
    full_name TEXT,
    email TEXT,
    mobile TEXT,
    gender TEXT,
    date_of_birth DATE,
    joining_date DATE,
    employee_status TEXT,
    employment_type TEXT,
    department_id INTEGER,
    position_id INTEGER,
    manager_id INTEGER,
    location_id INTEGER,
    cost_center_id INTEGER,
    created_date TIMESTAMP,

    FOREIGN KEY(department_id) REFERENCES department(department_id),
    FOREIGN KEY(position_id) REFERENCES position(position_id),
    FOREIGN KEY(manager_id) REFERENCES manager(manager_id),
    FOREIGN KEY(location_id) REFERENCES location(location_id),
    FOREIGN KEY(cost_center_id) REFERENCES cost_center(cost_center_id)
);

--------------------------------------------------
-- ONBOARDING
--------------------------------------------------

CREATE TABLE onboarding (
    onboarding_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    onboarding_status TEXT,
    offer_date DATE,
    joining_date DATE,
    completion_date DATE,
    onboarding_days INTEGER,

    FOREIGN KEY(employee_id)
    REFERENCES employee(employee_id)
);

CREATE TABLE document_type (
    document_type_id INTEGER PRIMARY KEY,
    document_name TEXT,
    mandatory_flag TEXT
);

CREATE TABLE employee_document (
    employee_document_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    document_type_id INTEGER,
    received_flag TEXT,
    verified_flag TEXT,
    verification_date DATE
);

CREATE TABLE asset_type (
    asset_type_id INTEGER PRIMARY KEY,
    asset_name TEXT
);

CREATE TABLE employee_asset (
    employee_asset_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    asset_type_id INTEGER,
    serial_number TEXT,
    allocation_date DATE,
    status TEXT
);

CREATE TABLE training (
    training_id INTEGER PRIMARY KEY,
    training_name TEXT,
    mandatory_flag TEXT
);

CREATE TABLE employee_training (
    employee_training_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    training_id INTEGER,
    completion_status TEXT,
    completion_date DATE
);

CREATE TABLE compliance (
    compliance_id INTEGER PRIMARY KEY,
    compliance_name TEXT
);

CREATE TABLE employee_compliance (
    employee_compliance_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    compliance_id INTEGER,
    completion_status TEXT,
    completion_date DATE
);

CREATE TABLE access_provision (
    access_id INTEGER PRIMARY KEY,
    employee_id INTEGER,
    email_created TEXT,
    ad_account_created TEXT,
    vpn_access TEXT,
    application_access TEXT
);

--------------------------------------------------
-- METADATA MESH
--------------------------------------------------

CREATE TABLE metadata_domain (
    domain_id INTEGER PRIMARY KEY,
    domain_code TEXT,
    domain_name TEXT,
    owner_name TEXT
);

CREATE TABLE metadata_source (
    source_id INTEGER PRIMARY KEY,
    source_name TEXT,
    source_type TEXT,
    connection_type TEXT
);

CREATE TABLE metadata_entity (
    entity_id INTEGER PRIMARY KEY,
    domain_id INTEGER,
    entity_name TEXT,
    business_definition TEXT
);

CREATE TABLE metadata_attribute (
    attribute_id INTEGER PRIMARY KEY,
    entity_id INTEGER,
    source_id INTEGER,
    physical_name TEXT,
    business_name TEXT,
    datatype TEXT,
    business_definition TEXT
);

CREATE TABLE metadata_business_term (
    term_id INTEGER PRIMARY KEY,
    business_term TEXT,
    definition TEXT
);

CREATE TABLE metadata_metric (
    metric_id INTEGER PRIMARY KEY,
    metric_name TEXT,
    formula_definition TEXT
);

CREATE TABLE metadata_classification (
    classification_id INTEGER PRIMARY KEY,
    attribute_id INTEGER,
    classification_name TEXT,
    confidence_score REAL
);

CREATE TABLE metadata_attribute_mapping (
    mapping_id INTEGER PRIMARY KEY,
    source_attribute TEXT,
    canonical_attribute TEXT,
    confidence_score REAL
);

CREATE TABLE metadata_lineage (
    lineage_id INTEGER PRIMARY KEY,
    source_object TEXT,
    target_object TEXT,
    transformation_name TEXT
);

CREATE TABLE metadata_data_product (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT,
    owner_name TEXT,
    sla_hours INTEGER
);

CREATE TABLE metadata_dashboard (
    dashboard_id INTEGER PRIMARY KEY,
    dashboard_name TEXT,
    dashboard_type TEXT
);

CREATE TABLE metadata_agent (
    agent_id INTEGER PRIMARY KEY,
    agent_name TEXT,
    agent_type TEXT
);

--------------------------------------------------
-- FUTURE ATTRIBUTE INTELLIGENCE
--------------------------------------------------

CREATE TABLE canonical_attribute (
    canonical_attribute_id INTEGER PRIMARY KEY,
    canonical_name TEXT,
    business_definition TEXT
);

CREATE TABLE attribute_pool (
    pool_id INTEGER PRIMARY KEY,
    source_table TEXT,
    source_column TEXT,
    inferred_name TEXT,
    datatype TEXT
);

--------------------------------------------------
-- GOLD DATA PRODUCTS
--------------------------------------------------

CREATE VIEW employee_onboarding_360 AS
SELECT
    e.employee_id,
    e.employee_number,
    e.full_name,
    d.department_name,
    p.position_name,
    m.manager_name,
    l.city,
    l.country,
    o.onboarding_status,
    o.joining_date,
    o.onboarding_days
FROM employee e
LEFT JOIN department d
ON e.department_id = d.department_id
LEFT JOIN position p
ON e.position_id = p.position_id
LEFT JOIN manager m
ON e.manager_id = m.manager_id
LEFT JOIN location l
ON e.location_id = l.location_id
LEFT JOIN onboarding o
ON e.employee_id = o.employee_id;

CREATE VIEW onboarding_kpi AS
SELECT
    COUNT(*) total_joiners,
    SUM(CASE WHEN onboarding_status='Completed' THEN 1 ELSE 0 END) completed,
    SUM(CASE WHEN onboarding_status='Pending' THEN 1 ELSE 0 END) pending,
    ROUND(
        SUM(CASE WHEN onboarding_status='Completed' THEN 1 ELSE 0 END)
        *100.0/COUNT(*),2
    ) completion_rate,
    ROUND(AVG(onboarding_days),2) avg_onboarding_days
FROM onboarding;

CREATE VIEW training_compliance_360 AS
SELECT
    e.employee_id,
    e.full_name,
    et.completion_status training_status,
    ec.completion_status compliance_status
FROM employee e
LEFT JOIN employee_training et
ON e.employee_id = et.employee_id
LEFT JOIN employee_compliance ec
ON e.employee_id = ec.employee_id;