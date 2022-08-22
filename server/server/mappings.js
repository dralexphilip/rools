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
        oldField: "policy_id",
        newField: "POLICYHOLDER_ID",
    },
    {
        oldField: "policy_id_alt",
        newField: "POLICYHOLDER_ALTERNATE_ID",
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
        oldField: "carrier_name",
        newField: "CARRIER_NAME",
    },
    {
        oldField: "group_name",
        newField: "GROUP_NAME",
    },
    {
        oldField: "subgroup_number",
        newField: "SUBGROUP_NUMBER",
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
        oldField: "Submitter",
        newField: "SUBMITTER",
    },
    {
        oldField: "plan_type",
        newField: "PLAN_TYPE",
    },
];

module.exports = { mappings };