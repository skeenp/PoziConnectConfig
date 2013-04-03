SELECT
   
   MissingCProps.PR_PFI AS "property_PFI",
	'' AS "parcel_PFI",
	'' AS "multi_assess",
	MissingCProps.PROPNUM1 AS "retired_propnum",
	'' AS "base_propnum",
	'' AS "propnum",
	'' AS "crefno",
	'' AS "spi",
	'' AS "part_p",
	'' AS "plan_number",
	'' AS "lot_number",
	'' AS "allotment",
	'' AS "section_p",
	'' AS "portion",
	'' AS "block_c",
	'' AS "subdivision",
	'' AS "parish_code",
	'' AS "township_code",
    MissingCProps.su_type AS "su_type",
    MissingCProps.su_prefix_1 AS "su_prefix_1",
    MissingCProps.su_no_1 AS "su_no_1",
    MissingCProps.su_suff_1 AS "su_suff_1",
    '' AS "su_prefix_2",
    MissingCProps.su_no_2 AS "su_no_2",
    MissingCProps.su_suff_2 AS "su_suff_2",
    MissingCProps.fl_type AS "fl_type",
    '' AS "fl_prefix_1",
    MissingCProps.fl_no_1 AS "fl_no_1",
    '' AS "fl_suff_1",
    '' AS "fl_prefix_2",
   MissingCProps.fl_no_2 AS "fl_no_2",
    '' AS "fl_suff_2",
    '' AS "pr_name_1",
    '' AS "pr_name_2",
    MissingCProps.loc_desc AS "loc_desc",
    '' AS "house_prefix_1",
    MissingCProps.house_number_1 AS "house_number_1",
    MissingCProps.house_suffix_1 AS "house_suffix_1",
    '' AS "house_prefix_2",
    MissingCProps.house_number_2 AS "house_number_2",
    MissingCProps.house_suffix_2 AS "house_suffix_2",
    '' AS "display_prefix_1",
    '' AS "display_no_1",
    '' AS "display_suffix_1",
    '' AS "display_prefix_2",
    '' AS "display_no_2",
    '' AS "display_suffix_2",
    MissingCProps.street_name AS "street_name",
    MissingCProps.street_type AS "street_type",
    MissingCProps.street_suffix AS "street_suffix",
    MissingCProps.locality AS "locality",
    '' AS "postcode",
	
	CASE
        WHEN  MissingCProps.MultAss ='N'  THEN 'E'
		ELSE 'R'
	END AS "edit_code"
	
	
	
FROM
    TMP_VM_COMPARE_MissingCouncilProps_usingPropno AS MissingCProps 
