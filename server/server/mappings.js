const mappings = [
    {
        oldField: "filename",
        newField: "ORIGINAL_FILENAME",
    },
    {
        oldField: "source_type",
        newField: "SOURCE_DATA_TYPE",
    },    
    {
        oldField: "policy_id_alt",
        newField: "POLICYHOLDER_ALTERNATE_ID",
    },
    {
        oldField: "policy_id",
        newField: "POLICYHOLDER_ID",
    },
    {
        oldField: "policy_hic",
        newField: "POLICYHOLDER_MEDICARE_ID",
    },
    {
        oldField: "policy_employer_name",
        newField: "POLICYHOLDER_EMPLOYER_NAME",
    },
    {
        oldField: "policy_employer_addr1",
        newField: "POLICYHOLDER_EMPLOYER_ADDRESS_1",
    },
    {
        oldField: "policy_employer_city",
        newField: "POLICYHOLDER_EMPLOYER_CITY",
    },
    {
        oldField: "policy_employer_state",
        newField: "POLICYHOLDER_EMPLOYER_STATE",
    },
    {
        oldField: "policy_employer_zip",
        newField: "POLICYHOLDER_EMPLOYER_ZIP",
    },
    {
        oldField: "carrier_name",
        newField: "CARRIER_NAME",
    },
    {
        oldField: "group_name",
        newField: "GROUP_NAME",
    },
    {
        oldField: "subgroup_number",
        newField: "SUB_GROUP_NUMBER",
    },
    {
        oldField: "group_number",
        newField: "GROUP_NUMBER",
    },
    {
        oldField: "group_desc",
        newField: "GROUP_DESCRIPTION",
    },    
    {
        oldField: "pbm_person_code",
        newField: "PBM_PERSON_CODE",
    },
    {
        oldField: "pbm_bin",
        newField: "PBM_BIN",
    },
    {
        oldField: "pbm_pcn",
        newField: "PBM_PCN",
    },
    {
        oldField: "medical_name",
        newField: "MEDICAL_NAME",
    },
    {
        oldField: "medical_product",
        newField: "MEDICAL_PRODUCT",
    },
    {
        oldField: "member_id_alt",
        newField: "MEMBER_ALTERNATE_ID",
    },
    {
        oldField: "member_hic",
        newField: "MEMBER_MEDICARE_ID",
    },
    {
        oldField: "member_id",
        newField: "MEMBER_KEY",
    },
    {
        oldField: "Submitter",
        newField: "TRADING_PARTNER_IDENTIFICATION",
    },
    {
        oldField: "plan_type",
        newField: "PLAN_TYPE",
    },
    {
        oldField: "lob",
        newField: "LINE_OF_BUSINESS",
    },
];

module.exports = { mappings };