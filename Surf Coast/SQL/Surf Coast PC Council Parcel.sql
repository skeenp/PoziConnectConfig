select
    *,
    case
        when plan_number <> '' and lot_number = '' then plan_number
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_number
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_number
        when plan_number <> '' then lot_number || '\' || plan_number
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\PP' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as spi,
    case
        when plan_numeral <> '' and lot_number = '' then plan_numeral
        when plan_number <> '' and sec <> '' then lot_number || '~' || sec || '\' || plan_numeral
        when plan_number <> '' and block <> '' then lot_number || '~' || block || '\' || plan_numeral
        when plan_numeral <> '' then lot_number || '\' || plan_numeral
        when ( parish_code <> '' or township_code <> '' ) then
            subdivision ||
            case when subdivision <> '' and ( portion <> '' or allotment <> '' ) then '~' else '' end ||
            portion ||
            case when portion <> '' and allotment <> '' then '~' else '' end ||
            allotment ||
            case when sec <> '' then '~' else '' end ||
            sec ||
            '\' ||
            case when township_code <> '' then township_code else parish_code end
        else ''
    end as simple_spi
from
(
select
    cast ( auprparc.ass_num as varchar ) as propnum,
    case auprparc.pcl_flg
        when 'R' then 'A'
        when 'P' then 'P'
    end as status,
    cast ( auprparc.pcl_num as varchar ) as crefno,
    case ttl_no2
        when 'Y' then 'P'
        else ''
    end as part,
    case
        when auprparc.ttl_cde = 6 then ''
        else case
            when auprparc.ttl_cde = 1 then 'PS'
            when auprparc.ttl_cde = 2 then 'PC'
            when auprparc.ttl_cde = 3 then 'LP'
            when auprparc.ttl_cde = 4 then 'CP'
            when auprparc.ttl_cde = 5 then 'CS'
            when auprparc.ttl_cde = 7 then 'RP'
            when auprparc.ttl_cde = 8 then 'SP'
            when auprparc.ttl_cde = 9 then 'TP'
            when auprparc.ttl_cde = 11 then 'CP'
            when auprparc.ttl_cde = 20 then 'TP'
        end || auprparc.ttl_no5
    end as plan_number,
    case
        when auprparc.ttl_cde = 1 then 'PS'
        when auprparc.ttl_cde = 2 then 'PC'
        when auprparc.ttl_cde = 3 then 'LP'
        when auprparc.ttl_cde = 4 then 'CP'
        when auprparc.ttl_cde = 5 then 'CS'
        when auprparc.ttl_cde = 7 then 'RP'
        when auprparc.ttl_cde = 8 then 'SP'
        when auprparc.ttl_cde = 9 then 'TP'
        when auprparc.ttl_cde = 11 then 'CP'
        when auprparc.ttl_cde = 20 then 'TP'
        else ''
    end as plan_prefix,
    case
        when auprparc.ttl_cde = 6 then ''
        else auprparc.ttl_no5
    end as plan_numeral,
    case
        when auprparc.ttl_cde = 6 then ''
        else ifnull ( auprparc.ttl_no1 , '' )
    end as lot_number,
    case
        when auprparc.ttl_cde = 6 then auprparc.ttl_no1
        else ''
    end as allotment,
    case
        when auprparc.ttl_cde <> 6 then ''
        else ifnull ( ttl_no4 , '' )
    end as sec,
    '' as block,
    '' as portion,
    '' as subdivision,
    ifnull ( udn_cd2 , '' ) as parish_code,
    '' as township_code,
    fmt_ttl as summary,
    '365' as lga_code,
    cast ( auprparc.ass_num as varchar ) as assnum
from
    authority_auprparc as auprparc join
    authority_aurtmast aurtmast on auprparc.ass_num = aurtmast.ass_num join
    authority_auprstad auprstad on auprparc.pcl_num = auprstad.pcl_num
where
    auprparc.pcl_flg in ( 'R' , 'P' )
)
