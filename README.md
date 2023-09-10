# Linux-kernels
[![General badge](https://img.shields.io/badge/kernel.org-archives-black.svg?logo=linux)](https://cdn.kernel.org/pub/linux/kernel/)

```bash
 "4.14.277",
 ```

https://gemfury.com/squarecapadmin/python:Pygments/-/content/lexers/configs.py



```sql
create EXTENSION if not exists semver;

drop view if exists configs;
drop view if exists all_versions;
create or replace VIEW all_versions AS
with list_versions as (
    SELECT id, jsonb_object_keys(versions) as version
    from kconfig
), semver_versions as (
    SELECT id, to_semver(version) as semver_version, version
    from list_versions
    order by semver_version
)
select id, jsonb_agg(version) as versions, jsonb_agg(semver_version) as s_versions
from semver_versions
group by id;

drop view if exists architectures;
create or replace view architectures as
select name, jsonb_agg(architecture) as architectures
from kconfig
group by name;


drop view if exists configs;
create or replace view configs as
select kconfig.id,
       kconfig.name,
       all_versions.versions->>-1 as last_appearance,
       kconfig.introduced_in,
       kconfig.architecture,
       kconfig.version,
       kconfig.permalink,
       kconfig.file,
       kconfig.created_at,
       kconfig.updated_at,
       data || jsonb_build_object(
               'versions', all_versions.versions,
               'architectures', architectures.architectures,
               'lastAppearance', all_versions.versions->>-1,
               'introducedIn', all_versions.versions->>0,
               'updatedAt', kconfig.updated_at
           ) as data
from kconfig
         left join all_versions on kconfig.id = all_versions.id
         left join architectures on kconfig.name = architectures.name;


-- generic architecture
select data
from configs
where configs.architecture = '';

-- architecture-specific 
select json_agg(data)
from configs
where configs.architecture != '';
```


CONFIG_FTAPE