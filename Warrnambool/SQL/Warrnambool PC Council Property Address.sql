select
    *,
    ltrim ( num_road_address ||
        rtrim ( ' ' || locality_name ) ) as ezi_address
from (

select
    *,
    ltrim ( road_name_combined ||
        rtrim ( ' ' || locality_name ) ) as road_locality,
    ltrim ( num_address ||
        rtrim ( ' ' || road_name_combined ) ) as num_road_address
from (

select
    *,
    blg_unit_prefix_1 || blg_unit_id_1 || blg_unit_suffix_1 ||
        case when ( blg_unit_id_2 <> '' or blg_unit_suffix_2 <> '' ) then '-' else '' end ||
        blg_unit_prefix_2 || blg_unit_id_2 || blg_unit_suffix_2 ||
        case when ( blg_unit_id_1 <> '' or blg_unit_suffix_1 <> '' ) then '/' else '' end ||
        case when hsa_flag = 'Y' then hsa_unit_id || '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 as num_address,
    ltrim ( road_name ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix ) ) as road_name_combined
from (

select
    cast ( P.property_no as varchar ) as propnum,
    case P.status
        when 'F' then 'P'
        else ''
    end as status,
    '' as base_propnum,
    '' as is_primary,
    '' as distance_related_flag,
    '' as hsa_flag,
    '' as hsa_unit_id,
    case
        when a.formatted_address like 'ABOVE %' then 'ABOVE'
        when a.formatted_address like 'BELOW %' then 'BELOW'
        when a.formatted_address like 'REAR %' then 'REAR'
        else ''
    end as location_descriptor,
    '' as blg_unit_type,
    '' as blg_unit_prefix_1,
    case
        when A.unit_no = '0' then ''
        else ifnull ( A.unit_no , '' )
    end as blg_unit_id_1,
    upper ( ifnull ( A.unit_no_suffix , '' ) ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    case
        when A.unit_no_to = '0' then ''
        else ifnull ( A.unit_no_to , '' )
    end as blg_unit_id_2,
    upper ( ifnull ( A.unit_no_to_suffix , '' ) ) as blg_unit_suffix_2,
    '' as floor_type,
    '' as floor_prefix_1,
    case
        when A.floor_no = '0' then ''
        else ifnull ( A.floor_no , '' )
    end as floor_no_1,
    upper ( ifnull ( A.floor_suffix , '' ) ) as floor_suffix_1,
    '' as floor_prefix_2,
    case
        when A.floor_no_to = '0' then ''
        else ifnull ( A.floor_no_to , '' )
    end as floor_no_2,
    upper ( ifnull ( A.floor_suffix_to , '' ) ) as floor_suffix_2,
    '' as building_name,
    '' as complex_name,
    '' as house_prefix_1,
    case
        when A.house_no = '0' then ''
        else ifnull ( A.house_no , '' )
    end as house_number_1,
    upper ( ifnull ( A.house_no_suffix , '' ) ) as house_suffix_1,
    '' as house_prefix_2,
    case
        when A.house_no_to = '0' then ''
        else ifnull ( A.house_no_to , '' )
    end as house_number_2,
    upper ( ifnull ( A.house_no_to_suffix , '' ) ) as house_suffix_2,
    replace ( replace ( case
        when upper ( S.street_name ) = 'THE HILL CT' then 'THE HILL'
        when upper ( S.street_name ) like 'THE %' then upper ( S.street_name )
        when upper ( substr ( S.street_name , -3 ) ) in ( ' CL' , ' CT' , ' DR' , ' GR' , ' RD' , ' PL' , ' SQ' , ' ST' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 3 ) )
        when upper ( substr ( S.street_name , -4 ) ) in ( ' AVE' , ' BVD' , ' HWY' , ' PDE' , ' TCE' , ' TRL' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 4 ) )
        when upper ( substr ( S.street_name , -5 ) ) in ( ' CRES' , ' LANE' ) then upper ( substr ( S.street_name , 1 , length ( S.street_name ) - 5 ) )
        else upper ( S.street_name )
    end , '`' , '' ) , '''' , '' ) as road_name,
    case
        when upper ( S.street_name ) = 'THE HILL CT' then 'COURT'
        when upper ( S.street_name ) like 'THE %' then ''
        when S.street_name like '% AVE' then 'AVENUE'
        when S.street_name like '% BVD%' then 'BOULEVARD'
        when S.street_name like '% CL' then 'CLOSE'
        when S.street_name like '% CRES' then 'CRESCENT'
        when S.street_name like '% CT' then 'COURT'
        when S.street_name like '% DR' then 'DRIVE'
        when S.street_name like '% GR' then 'GROVE'
        when S.street_name like '% HWY' then 'HIGHWAY'
        when S.street_name like '% LANE' then 'LANE'
        when S.street_name like '% PDE' then 'PARADE'
        when S.street_name like '% PL' then 'PLACE'
        when S.street_name like '% RD' then 'ROAD'
        when S.street_name like '% ST%' then 'STREET'
        when S.street_name like '% SQ' then 'SQUARE'
        when S.street_name like '% TCE' then 'TERRACE'
        when S.street_name like '% TRL%' then 'TRAIL'
        else ''
    end as road_type,
    '' as road_suffix,
    L.locality_name as locality_name,
    L.postcode as postcode,
    '' as access_type,
    '' as easting,
    '' as northing,
    '' as datum_proj,
    '' as outside_property,
    '369' as lga_code,
    '' as crefno,
    a.formatted_address as summary
from
    techone_nucproperty P
    join techone_nucaddress A on A.property_no = P.property_no
    join techone_nucstreet S on S.street_no = A.street_no
    join techone_nuclocality L on L.locality_ctr = S.locality_ctr
where
    P.status in ( 'C' , 'F' ) and
    P.property_no <> 1
)
)
)
