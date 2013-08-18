select
    *,
    ltrim ( blg_unit_prefix_1 || blg_unit_id_1 || blg_unit_suffix_1 ||
        case when ( blg_unit_id_2 <> '' or blg_unit_suffix_2 <> '' ) then '-' else '' end ||
        blg_unit_prefix_2 || blg_unit_id_2 || blg_unit_suffix_2 ||
        case when ( blg_unit_id_1 <> '' or blg_unit_suffix_1 <> '' ) then '/' else '' end ||
        house_prefix_1 || house_number_1 || house_suffix_1 ||
        case when ( house_number_2 <> '' or house_suffix_2 <> '' ) then '-' else '' end ||
        house_prefix_2 || house_number_2 || house_suffix_2 ||
        rtrim ( ' ' || road_name ) ||
        rtrim ( ' ' || road_type ) ||
        rtrim ( ' ' || road_suffix )) as num_road_address
from (

select distinct
	cast ( auprparc.ass_num as varchar(10) ) as propnum,
	'' as base_propnum,
	'' as is_primary,
    '' as hsa_flag,
    '' as hsa_unit_id,
	'' as blg_unit_type,   
    '' as blg_unit_prefix_1,
    ifnull ( auprstad.pcl_unt , '' ) as blg_unit_id_1,
    ifnull ( auprstad.unt_alp , '' ) as blg_unit_suffix_1,
    '' as blg_unit_prefix_2,
    '' as blg_unit_id_2,
    '' as blg_unit_suffix_2,
    '' as floor_type,
    ifnull ( auprstad.flo_pre , '' ) as floor_prefix_1,
    ifnull ( auprstad.flo_num , '' ) as floor_no_1,
    '' as floor_suffix_1,
    '' as floor_prefix_2,
    '' as floor_no_2,
    '' as floor_suffix_2,
    ifnull ( upper ( auprparc.ttl_nme ) , '' ) as building_name,
    '' as complex_name,
    '' as location_descriptor,
    '' as house_prefix_1,
    ifnull ( auprstad.hou_num , '' ) as house_number_1,
    ifnull ( auprstad.hou_alp , '' ) as house_suffix_1,
    '' as house_prefix_2,
    ifnull ( auprstad.hou_end , '' ) as house_number_2,
    ifnull ( auprstad.end_alp , '' ) as house_suffix_2,
    case
        when upper ( auprstad.str_nme ) = 'PARK AVENUE NORTH' then 'PARK'
        when upper ( auprstad.str_nme ) = 'HILLSIDE (SOUTH)' then 'HILLSIDE'
        when upper ( auprstad.str_nme ) like '%-LEFT ARM' then replace (upper( auprstad.str_nme ),'-',' ')
        when upper ( auprstad.str_nme ) like '%-RIGHT ARM' then replace (upper( auprstad.str_nme ),'-',' ')
        when upper ( auprstad.str_nme ) like '%-FIRST' then replace (upper( auprstad.str_nme ),'-',' ')        
        else replace ( upper ( auprstad.str_nme ) , '''' , '' )
    end as road_name,
    case
        when upper ( auprstad.str_nme ) like '% AVENUE NORTH' then 'AVENUE'
        when auprstad.str_typ in ( 'AV','AVE','AVEE','AVEN','AVES','AVEW','AVEX' ) then 'AVENUE'
        when auprstad.str_typ = 'BND' then 'BEND'
        when auprstad.str_typ = 'BVD' then 'BOULEVARD'
        when auprstad.str_typ = 'CL' then 'CLOSE'
        when auprstad.str_typ = 'CON' then 'CONNECTION'
        when auprstad.str_typ in ( 'CR','CRES' ) then 'CRESCENT'
        when auprstad.str_typ = 'CT' then 'COURT'
        when auprstad.str_typ = 'DR' then 'DRIVE'
        when auprstad.str_typ = 'GR' then 'GROVE'
        when auprstad.str_typ = 'HTS' then 'HEIGHTS'
        when auprstad.str_typ = 'HWY' then 'HIGHWAY'
        when auprstad.str_typ = 'LA' then 'LANE'
        when auprstad.str_typ = 'ML' then 'MALL'
        when auprstad.str_typ = 'MW' then 'MEWS'
        when auprstad.str_typ = 'PDE' then 'PARADE'
        when auprstad.str_typ = 'PK' then 'PARK'
        when auprstad.str_typ = 'PL' then 'PLACE'
        when auprstad.str_typ in ( 'RD','RDE','RDN','RDS','RDW','RDEX','RDX' ) then 'ROAD'
        when auprstad.str_typ = 'RES' then 'RESERVE'
        when auprstad.str_typ = 'RL' then 'RISE'
        when auprstad.str_typ in ( 'ST','STE','STN','STS','STW','STEX','STX','SSTH' ) then 'STREET'
        when auprstad.str_typ = 'TCE' then 'TERRACE'
        when auprstad.str_typ = 'TR' then 'TRACK'
        when auprstad.str_typ = 'WK' then 'WALK'
        when auprstad.str_typ = 'WY' then 'WAY'
        when auprstad.str_typ in ( 'WYD','WYND' ) then 'WYND'
        when auprstad.str_typ = 'CH' then 'CHASE'
        when auprstad.str_typ = 'RND' then 'ROUND'
        when auprstad.str_typ = 'HILL' then 'HILL'
        else ''
    end as road_type,
    case
        when auprstad.str_typ in ( 'AVEN' , 'RDN' , 'STN' ) then 'N'
        when auprstad.str_typ in ( 'AVES' , 'RDS' , 'STS' , 'SSTH' ) then 'S'
        when auprstad.str_typ in ( 'AVEE' , 'RDE' , 'STE' ) then 'E'
        when auprstad.str_typ in ( 'AVEW' , 'RDW' , 'STW' ) then 'W'
        when auprstad.str_typ in ( 'AVEX' , 'RDEX' , 'STEX' ) then 'EX'
        when UPPER ( auprstad.str_nme ) like '% AVENUE NORTH' then 'N'
        when UPPER ( auprstad.str_nme ) like '% (SOUTH)' then 'S'
        else ''
    end as road_suffix, 
	upper ( auprstad.sbr_nme ) as locality_name,
    '' as postcode,
    '' as access_type,
    '355' as lga_code
from
    AUTHORITY_auprparc as auprparc ,
    AUTHORITY_auprstad as auprstad
where
    auprparc.pcl_num = auprstad.pcl_num AND
    auprparc.pcl_flg in ( 'R' , 'P' ) AND
    auprparc.ass_num <> 0 AND
    auprstad.seq_num = 0
)