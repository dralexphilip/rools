const mappings = [
    {
        oldField: "filename",
        newField: "ORIGINAL_TRADING_PARTNER_FILENAME",
    },
    {
        oldField: "source_type",
        newField: "TRADING_PARTNER_SOURCE_TYPE",
    },    
    {
        oldField: "policy_id_alt",
        newField: "TRADING_PARTNER_POLICYHOLDER_ALTERNATE_ID",
    },
    {
        oldField: "policy_id",
        newField: "TRADING_PARTNER_POLICYHOLDER_ID",
    },
    {
        oldField: "policy_hic",
        newField: "TRADING_PARTNER_POLICYHOLDER_MEDICARE_ID",
    },
    {
        oldField: "policy_employer_name",
        newField: "TRADING_PARTNER_POLICYHOLDER_EMPLOYER_NAME",
    },
    {
        oldField: "policy_employer_addr1",
        newField: "TRADING_PARTNER_POLICYHOLDER_EMPLOYER_ADDRESS_1",
    },
    {
        oldField: "policy_employer_city",
        newField: "TRADING_PARTNER_POLICYHOLDER_EMPLOYER_CITY",
    },
    {
        oldField: "policy_employer_state",
        newField: "TRADING_PARTNER_POLICYHOLDER_EMPLOYER_STATE",
    },
    {
        oldField: "policy_employer_zip",
        newField: "TRADING_PARTNER_POLICYHOLDER_EMPLOYER_ZIP",
    },
    {
        oldField: "carrier_name",
        newField: "TRADING_PARTNER_CARRIER_NAME",
    },
    {
        oldField: "group_name",
        newField: "TRADING_PARTNER_GROUP_NAME",
    },
    {
        oldField: "subgroup_number",
        newField: "TRADING_PARTNER_SUB_GROUP_NUMBER",
    },
    {
        oldField: "group_number",
        newField: "TRADING_PARTNER_GROUP_NUMBER",
    },
    {
        oldField: "group_desc",
        newField: "TRADING_PARTNER_GROUP_DESCRIPTION",
    },
    {
        oldField: "pbm_name",
        newField: "TRADING_PARTNER_PBM_NAME",
    },
    {
        oldField: "pbm_card_holder_id",
        newField: "TRADING_PARTNER_PBM_CARD_HOLDER_ID",
    }, 
    {
        oldField: "pbm_person_code",
        newField: "TRADING_PARTNER_PERSON_CODE",
    },
    {
        oldField: "pbm_bin",
        newField: "TRADING_PARTNER_BIN",
    },
    {
        oldField: "pbm_pcn",
        newField: "TRADING_PARTNER_PCN",
    },
    {
        oldField: "vision_name",
        newField: "TRADING_PARTNER_VISION_NAME",
    },
    {
        oldField: "vision_policy_number",
        newField: "TRADING_PARTNER_VISION_POLICY_NUMBER",
    },
    {
        oldField: "dental_name",
        newField: "TRADING_PARTNER_DENTAL_NAME",
    },
    {
        oldField: "dental_policy_number",
        newField: "TRADING_PARTNER_DENTAL_POLICY_NUMBER",
    },
    {
        oldField: "medical_name",
        newField: "TRADING_PARTNER_MEDICAL_NAME",
    },
    {
        oldField: "medical_product",
        newField: "TRADING_PARTNER_MEDICAL_PRODUCT",
    },
    {
        oldField: "medical_policy_number",
        newField: "TRADING_PARTNER_MEDICAL_POLICY_NUMBER",
    },
    {
        oldField: "member_id_alt",
        newField: "TRADING_PARTNER_POLICYHOLDER_ALTERNATE_ID",
    },
    {
        oldField: "member_hic",
        newField: "TRADING_PARTNER_POLICYHOLDER_MEDICARE_ID",
    },
    {
        oldField: "member_id",
        newField: "TRADING_PARTNER_MEMBER_KEY",
    },
    {
        oldField: "Submitter",
        newField: "TRADING_PARTNER_IDENTIFICATION",
    },
    {
        oldField: "plan_type",
        newField: "TRADING_PARTNER_PLAN_TYPE",
    },
    {
        oldField: "lob",
        newField: "TRADING_PARTNER_LOB",
    },
    {
        oldField: "division_code",
        newField: "TRADING_PARTNER_DIVISION_CODE",
    },
    {
        oldField: "member_state",
        newField: "TRADING_PARTNER_MEMBER_STATE",
    },
    {
        oldField: "member_city",
        newField: "TRADING_PARTNER_MEMBER_CITY",
    },
    {
        oldField: "policy_ssn",
        newField: "TRADING_PARTNER_MEDICAL_POLICY_NUMBER", //to be updated
    },
    {
        oldField: "member_ssn",
        newField: "TRADING_PARTNER_MEMBER_KEY",  //to be updated
    },
];

module.exports = { mappings };