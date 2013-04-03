SELECT

	DiffVMAddr.LGA_Code AS "lga_code",
	'' AS "new_sub",		
	(Select PR_PFI from TMP_VM_PROPERTY_ADDRESS  where TMP_VM_PROPERTY_ADDRESS.PROPNUM = DiffVMAddr.PROPNUM) AS "property_PFI",		
	'' AS "parcel_PFI",
	(Select Ad_PFI from TMP_VM_PROPERTY_ADDRESS  where TMP_VM_PROPERTY_ADDRESS.PROPNUM = DiffVMAddr.PROPNUM) AS "Address_PFI",
	'' AS "spi",
	'' AS "plan_number",
	'' AS "lot_number",
	'' AS "base_propnum",
	CounAddr.propnum AS "propnum",
	'' AS "crefno",
	'' AS "hsa_flag",
	'' AS "hsa_unit_id",
	CounAddr.su_type AS "blg_unit_type",
    '' AS "blg_unit_prefix_1",
    CounAddr.su_no_1 AS "blg_unit_id_1",
    CounAddr.su_suff_1 AS "blg_unit_suffix_1",
    '' AS "blg_unit_prefix_2",
	CounAddr.su_no_2 AS "blg_unit_id_2",
    CounAddr.su_suff_2 AS "blg_unit_suffix_2",
    CounAddr.fl_type AS "floor_type",
    '' AS "floor_prefix_1",
   CounAddr.fl_no_1 AS "floor_no_1",
   CounAddr.fl_suff_1 AS "floor_suffix_1",
   '' AS floor_prefix_2,
    '' AS floor_no_2,
    '' AS floor_suffix_2,
    '' AS building_name,
    '' AS complex_name,
    CounAddr.loc_des AS "location_descriptor",
   '' AS house_prefix_1,
    CounAddr.house_number_1 AS "house_number_1",
    CounAddr.house_suffix_1 AS "house_suffix_1",
    '' AS house_prefix_2,
    CounAddr.house_number_2 AS "house_number_2",
    CounAddr.house_suffix_2 AS "house_suffix_2",
	'' AS access_type,
	'' AS new_road,
    CounAddr.street_name AS "road_name",
    CounAddr.street_type AS "road_type",
    CounAddr.street_suffix AS "road_suffix",
    CounAddr.locality AS "locality_name",
	'' AS "distance_related_flag",
	'' AS "is_primary",
	'' AS "easting",
	'' AS "northing",
	'' AS "datum/proj",
	'' AS "outside_property",
	'S' AS edit_code,
	'Incorrect Address in Vicmap - Council Address updated' AS Comments
	

FROM
    TMP_VM_COMPARE_DiffVMAddr_usingPropNo AS DiffVMAddr 
LEFT JOIN
Temp_PIQA_Address CounAddr ON DiffVMAddr.PROPNUM = CounAddr.propnum
	