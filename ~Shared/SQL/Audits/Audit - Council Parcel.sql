select
    spi as council_parcel_desc,
    crefno as council_crefno,
    propnum as council_propnum,
    summary as council_summary,
    status as council_status,
    case
        when spi like '\%' then 'Invalid: plan number format not recognised'
        when length ( spi ) < 5 then 'Invalid: plan number format not recognised'
        when plan_numeral like '0%' then 'Invalid: plan number contains leading zero'
        when plan_numeral <> '' and substr ( plan_numeral , -1 , 1 ) not in ( '1' , '2' , '3' , '4' , '5' , '6' , '7' , '8' , '9' , '0' ) then 'Invalid: plan number contains suffix letter'
        when lot_number like '%&%' or lot_number like '% %' or lot_number like '%-%' then 'Invalid: lot number contains invalid character'
        when plan_prefix in ( 'CS' , 'LP' , 'PS' , 'RP' , 'SP' ) and lot_number = '' then 'Invalid: lot number missing for ' || plan_prefix
        when plan_prefix in ( 'CP' , 'PC' ) and lot_number <> '' then 'Invalid: lot number not valid for ' || plan_prefix
        when plan_prefix = 'CP' and not ( ( 100000 <= cast ( plan_numeral as integer ) <= 109999 ) or ( 150000 <= plan_numeral <= 199999 ) ) then 'Invalid: plan number not in valid range for CP'
        when plan_prefix = 'CS' and not ( 1000 <= cast ( plan_numeral as integer ) <= 10000 ) then 'Invalid: plan number not in valid range for CS'
        when plan_prefix = 'LP' and not ( ( 1 <= cast ( plan_numeral as integer ) <= 99999 ) or ( 110000 <= cast ( plan_numeral as integer ) <= 149999 ) or ( 200000 <= cast ( plan_numeral as integer ) <= 299999 ) ) then 'Invalid: plan number not in valid range for LP'
        when plan_prefix = 'PC' and not ( ( 350001 <= cast ( plan_numeral as integer ) <= 400000 ) or ( 450001 <= cast ( plan_numeral as integer ) <= 500000 ) or ( 550001 <= cast ( plan_numeral as integer ) <= 600000 ) or ( 600001 <= cast ( plan_numeral as integer ) <= 650000 ) ) then 'Invalid: plan number not in valid range for PC'
        when plan_prefix = 'PS' and not ( ( 300001 <= cast ( plan_numeral as integer ) <= 350000 ) or ( 400001 <= cast ( plan_numeral as integer ) <= 450000 ) or ( 500001 <= cast ( plan_numeral as integer ) <= 550000 ) or ( 600001 <= cast ( plan_numeral as integer ) <= 650000 ) ) then 'Invalid: plan number not in valid range for PS'
        when plan_prefix = 'RP' and not ( cast ( plan_numeral as integer ) <= 19926 ) then 'Invalid: plan number not in valid range for RP'
        when plan_prefix = 'SP' and not ( 19927 <= cast ( plan_numeral as integer ) <= 40000 ) then 'Invalid: plan number not in valid range for SP'
        when parish_code <> '' and ( cast ( parish_code as integer ) < 2000 or cast ( parish_code as integer ) > 3999 ) then 'Invalid: parish number not in valid range'
        when township_code not in ( '' , '9999' ) and ( cast ( township_code as integer ) < 5000 or cast ( township_code as integer ) > 5999 ) then 'Invalid: township number not in valid range'
        else ''
    end as council_parcel_desc_validity,
    ifnull ( ( select num_props from pc_council_parcel_property_count cppc where cppc.spi = cp.spi ) , 0 ) as num_council_props,
    ifnull ( ( select num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = cp.spi ) , 0 ) as num_vicmap_props,
    ifnull ( ( select count(*) from pc_council_parcel x where x.spi = cp.spi ) , 0 ) as parcel_desc_match_in_council,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.spi = cp.spi ) , 0 ) as parcel_desc_match_in_vicmap,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.simple_spi = cp.simple_spi ) , 0 ) as parcel_desc_partial_match_in_vicmap,
    ifnull ( ( select count(*) from pc_vicmap_parcel vp where vp.further_description = cp.spi ) , 0 ) as alternative_parcel_desc_match_in_vicmap,
    ifnull ( ( select spi from pc_vicmap_parcel vp where vp.spi <> cp.spi and vp.propnum = cp.propnum and vp.crefno = cp.crefno and ( vp.crefno <> '' or vp.spi in ( select spi from pc_vicmap_parcel_property_parcel_count vpppc where num_parcels_in_prop = 1 ) ) ) , '' ) as suggested_parcel_desc,
    ifnull ( ( select crefno from pc_vicmap_parcel vp where vp.spi = cp.spi ) , '' ) as vicmap_crefno,
    case ( select num_props from pc_vicmap_parcel_property_count vppc where vppc.spi = cp.spi )
        when 0 then '(none)'
        when 1 then ( select propnum from pc_vicmap_parcel vp where vp.spi = cp.spi )
        else '(multiple)'
    end as vicmap_propnum,
    ifnull ( ( select edit_code from M1 where m1.spi = cp.spi limit 1 ) , '' ) as current_m1_edit_code,
    ifnull ( ( select comments from M1 where m1.spi = cp.spi limit 1 ) , '' ) as current_m1_comments,
    cp.*
from PC_Council_Parcel cp
where spi <> ''
order by council_parcel_desc_validity desc, ( case plan_number when '' then 'zzz' else plan_number end ) , parish_code, township_code, sec, lot_number, allotment

