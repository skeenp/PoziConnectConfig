## Adding Address PFI

The aim is to determine if a parcel contains a primary address so that rules can be adapted to prevent any parcel that contains a primary address being 'transferred' out of a property.

The first attempt has been to add a field here for `address_pfi`.

```
select
    parcel.parcel_pfi as parcel_pfi,
    parcel.parcel_spi as spi,
    ...
    ifnull ( ( select pfi from vmadd_address address where st_within ( address.geometry , parcel.geometry ) order by is_primary desc limit 1 ) , '' ) as address_pfi,
    parcel.geometry as geometry
```

However it massively degrades the query's performance. Using West Wimmera's data, the query went from under 1 sec to over 3 min.

The following websites detail how to optimise spatial queries.

* https://www.gaia-gis.it/fossil/libspatialite/wiki?name=SpatialIndex
* http://www.surfaces.co.il/spatialite-speedup-your-query-with-spatial-indexing/
* https://groups.google.com/forum/#!original/spatialite-users/RpNSY4q4Hdc/6R75MZzAvYYJ

Further improvements were made by using a filter on the property pfi to include only properties that were related to the parcel.

The `order by` clause causes a syntax error in Pozi Connect (but not Spatialite GUI), so the query was restructured to return only primary addresses.

Resulting clause:

```
ifnull ( (
    select pfi
    from vmadd_address address
    where
        address.property_pfi = property_lut.property_pfi and
        address.is_primary = 'Y' and
        st_within ( address.geometry , parcel.geometry ) and
        address.rowid in ( select rowid from spatialindex where f_table_name = 'vmadd_address' and search_frame = parcel.geometry )
    limit 1 ) , '' ) as primary_address_pfi,
```

After the property pfi filter was introduced, it was no longer efficient to use the `search_frame` method. By removing it, the time taken for the query at Manningham went from 30 seconds down to 7 seconds.


```
ifnull ( (
    select pfi
    from vmadd_address address
    where
        address.property_pfi = property_lut.property_pfi and
        address.is_primary = 'Y' and
        st_within ( address.geometry , parcel.geometry )
    limit 1 ) , '' ) as primary_address_pfi,
```