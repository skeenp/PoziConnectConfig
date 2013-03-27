SELECT

			
	(Select PR_PFI from TMP_VM_PROPERTY_ADDRESS  where TMP_VM_PROPERTY_ADDRESS.PROPNUM = DiffVMAddr.PROPNUM) AS "property_PFI",		
	'' AS "parcel_PFI",
	'' AS "multi_assess",
	'' AS "retired_propnum",
	'' AS "base_propnum",
	CounAddr.propnum AS "propnum",
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
    CounAddr.su_type AS "su_type",
    '' AS su_prefix_1,
    CounAddr.su_no_1,
    CounAddr.su_suff_1 AS su_suff_1,
    '' AS "su_prefix_2",
	CounAddr.su_no_2 AS "su_no_2",
    CounAddr.su_suff_2 AS "su_suff_2",
    CounAddr.fl_type AS "fl_type",
    '' AS fl_prefix_1,
   CounAddr.fl_no_1 AS "fl_no_1",
   CounAddr.fl_suff_1 AS "fl_suff_1",
   '' AS fl_prefix_2,
    '' AS fl_no_2,
    '' AS fl_suff_2,
    '' AS pr_name_1,
    '' AS pr_name_2,
    CounAddr.loc_des AS "loc_des",
    '' AS house_prefix_1,
    CounAddr.house_number_1 AS "house_number_1",
    CounAddr.house_suffix_1 AS "house_suffix_1",
    '' AS house_prefix_2,
    CounAddr.house_number_2 AS "house_number_2",
    CounAddr.house_suffix_2 AS "house_suffix_2",
    '' AS display_prefix_1,
    '' AS display_no_1,
    '' AS display_suffix_1,
    '' AS display_prefix_2,
    '' AS display_no_2,
    '' AS display_suffix_2,
    CounAddr.street_name AS "street_name",
    CounAddr.street_type AS "street_type",
    CounAddr.street_suffix AS "street_suffix",
    CounAddr.locality AS "locality",
    CounAddr.postcode AS "postcode",
	'' AS "dist_related_flag",
	'' AS "primary",
	'' AS "easting",
	'' AS "northing",
	'' AS "datum/proj",
	'' AS "os_property",
	
	'S' AS edit_code,
	'Inccorect Address in Vicmap - Council Address updated' AS Comments
	

FROM
    TMP_VM_COMPARE_DiffVMAddr_usingPropNo AS DiffVMAddr 
LEFT JOIN
Temp_PIQA_Address CounAddr ON DiffVMAddr.PROPNUM = CounAddr.propnum

where CounAddr.AddressCount = 1
	