SELECT
    ass_num AS propnum,
    pcl_num AS crefno,
    fmt_ttl AS title_desc
FROM
    AUTHORITY_auprparc AS auprparc
WHERE
    auprparc.pcl_flg in ( 'R' , 'P' ) AND
    auprparc.ass_num <> 0
ORDER BY
    ass_num