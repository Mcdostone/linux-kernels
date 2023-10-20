# Linux-kernels
[![General badge](https://img.shields.io/badge/kernel.org-archives-black.svg?logo=linux)](https://cdn.kernel.org/pub/linux/kernel/)

```bash
 "4.14.277",

 "3.4"
 "3.5"
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


-- all versions
select distinct jsonb_object_keys(versions) as versions
from kconfig
order by  versions;



select f.id, f.version, f.max
from(
        select t.id, t.version, max(semver(t.all_versions)) from (
                                                                     select id, version, jsonb_object_keys(versions) as all_versions
                                                                     from kconfig
                                                                 ) as t
        where t.all_versions != '1.0' and t.all_versions != '2.0'
        group by t.id, t.version
    ) as f
where semver(f.version) != f.max
order by f.id;

```


CONFIG_FTAPE










```
ts/linux-kernels/patches/2.6.39.3.patch" to "/Users/56291D/Documents/linux-kernels/kernels/tmp/2.6.39.3" with patch command
[2023-10-17T21:03:26Z INFO  pouet::infrastructure::service::prepare_service] execute command "patch -s -d /Users/56291D/Documents/linux-kernels/kernels/tmp/2.6.39.3 -p1 --no-backup-if-mismatch < /Users/56291D/Documents/linux-kernels/patches/2.6.39.3.patch"
[2023-10-17T21:03:26Z INFO  pouet::core::extractor] parse kconfig files in "/Users/56291D/Documents/linux-kernels/kernels/tmp/2.6.39.3"
[2023-10-17T21:03:37Z WARN  pouet::core::transform::denormalizer] Current architecture is um but according to the file arch/x86/Kconfig.cpu, this architecture should be x86. Maybe these 2 architectures share the same configuration entries.
[2023-10-17T21:03:37Z WARN  pouet::core::transform::denormalizer] Current architecture is um but according to the file arch/x86/Kconfig.cpu, this architecture should be x86. Maybe these 2 architectures share the same configuration entries.
[2023-10-17T21:03:37Z WARN  pouet::core::transform::denormalizer] Current architecture is um but according to the file arch/x86/Kconfig.cpu, this architecture should be x86. Maybe these 2 architectures share the same configuration entries.
[2023-10-17T21:03:38Z INFO  pouet::core::transform] 165853 config entries have been found
[2023-10-17T21:03:38Z INFO  pouet::infrastructure::service::csv_exporter] Write CSV file
[2023-10-17T21:03:40Z INFO  pouet::infrastructure::service::load_service] Load CSV file "/Users/56291D/Documents/linux-kernels/output/configs-2.6.39.3.csv"
[2023-10-17T21:03:47Z WARN  sqlx::query] summary="copy kconfigs (id, group_id, …" db.statement="\n\ncopy kconfigs (\n  id,\n  group_id,\n  name,\n  version,\n  architecture,\n  permalink,\n  file,\n  data,\n  declaration_number,\n  created_at\n)\nfrom\n  '/Users/56291D/Documents/linux-kernels/output/configs-2.6.39.3.csv' csv header delimiter ',';\n" rows_affected=165853 rows_returned=0 elapsed=7.269835208s
[2023-10-17T21:03:47Z INFO  pouet::infrastructure::service::load_service] Load CSV file "/Users/56291D/Documents/linux-kernels/output/versions-2.6.39.3.csv"
[2023-10-17T21:03:47Z INFO  pouet::infrastructure::service::load_service] Purge unnecessary rows
[2023-10-17T21:03:59Z WARN  sqlx::query] summary="with to_delete as ( …" db.statement="\n\nwith to_delete as (\n  select\n    id,\n    group_id,\n    row_number() over (\n      partition by group_id\n      order by\n        created_at desc\n    ) as rr\n  from\n    kconfigs\n  order by\n    group_id,\n    created_at desc\n),\nids_to_delete as (\n  select\n    id\n  from\n    to_delete\n  where\n    rr > 1\n)\ndelete from\n  kconfigs\nwhere\n  id in (\n    select\n      id\n    from\n      ids_to_delete\n  );\n" rows_affected=165853 rows_returned=0 elapsed=12.377781458s
[2023-10-17T21:03:59Z INFO  pouet::infrastructure::service::swiss_army_man_service] Purged 165853 rows
[2023-10-17T21:04:01Z INFO  pouet::infrastructure::service::swiss_army_man_service] [772/4354] Processing version 3.0
[2023-10-17T21:04:01Z WARN  pouet::infrastructure::service::prepare_service] It looks like you haven't cloned the Linux kernel repository, download the archive then.
[2023-10-17T21:04:01Z INFO  pouet::infrastructure::service::prepare_service] download https://cdn.kernel.org/pub/linux/kernel/v3.x/linux-3.0.tar.xz
[2023-10-17T21:04:21Z INFO  pouet::infrastructure::service::prepare_service] extract "./kernels/tmp/linux-3.0.tar.xz" into "./kernels/tmp/3.0"
[2023-10-17T21:04:21Z INFO  pouet::infrastructure::service::prepare_service] execute command "tar -xJf ./kernels/tmp/linux-3.0.tar.xz --strip-components 1 -C ./kernels/tmp/3.0"
[2023-10-17T21:04:28Z INFO  pouet::infrastructure::service::prepare_service] apply patch "/Users/56291D/Documents/linux-kernels/patches/3.0.patch" to "/Users/56291D/Documents/linux-kernels/kernels/tmp/3.0" with patch command
[2023-10-17T21:04:28Z INFO  pouet::infrastructure::service::prepare_service] execute command "patch -s -d /Users/56291D/Documents/linux-kernels/kernels/tmp/3.0 -p1 --no-backup-if-mismatch < /Users/56291D/Documents/linux-kernels/patches/3.0.patch"
[2023-10-17T21:04:28Z INFO  pouet::core::extractor] parse kconfig files in "/Users/56291D/Documents/linux-kernels/kernels/tmp/3.0"
[2023-10-17T21:04:40Z WARN  pouet::core::transform::denormalizer] Current architecture is um but according to the file arch/x86/Kconfig.cpu, this architecture should be x86. Maybe these 2 architectures share the same configuration entries.
[2023-10-17T21:04:40Z WARN  pouet::core::transform::denormalizer] Current architecture is um but according to the file arch/x86/Kconfig.cpu, this architecture should be x86. Maybe these 2 architectures share the same configuration entries.
[2023-10-17T21:04:41Z INFO  pouet::core::transform] 168647 config entries have been found
[2023-10-17T21:04:41Z INFO  pouet::infrastructure::service::csv_exporter] Write CSV file
[2023-10-17T21:04:42Z INFO  pouet::infrastructure::service::load_service] Load CSV file "/Users/56291D/Documents/linux-kernels/output/configs-3.0.csv"
[2023-10-17T21:04:50Z WARN  sqlx::query] summary="copy kconfigs (id, group_id, …" db.statement="\n\ncopy kconfigs (\n  id,\n  group_id,\n  name,\n  version,\n  architecture,\n  permalink,\n  file,\n  data,\n  declaration_number,\n  created_at\n)\nfrom\n  '/Users/56291D/Documents/linux-kernels/output/configs-3.0.csv' csv header delimiter ',';\n" rows_affected=168647 rows_returned=0 elapsed=7.29591675s
[2023-10-17T21:04:50Z INFO  pouet::infrastructure::service::load_service] Load CSV file "/Users/56291D/Documents/linux-kernels/output/versions-3.0.csv"
[2023-10-17T21:04:50Z INFO  pouet::infrastructure::service::load_service] Purge unnecessary rows
[2023-10-17T21:05:06Z WARN  sqlx::query] summary="with to_delete as ( …" db.statement="\n\nwith to_delete as (\n  select\n    id,\n    group_id,\n    row_number() over (\n      partition by group_id\n      order by\n        created_at desc\n    ) as rr\n  from\n    kconfigs\n  order by\n    group_id,\n    created_at desc\n),\nids_to_delete as (\n  select\n    id\n  from\n    to_delete\n  where\n    rr > 1\n)\ndelete from\n  kconfigs\nwhere\n  id in (\n    select\n      id\n    from\n      ids_to_delete\n  );\n" rows_affected=164644 rows_returned=0 elapsed=16.504161458s
[2023-10-17T21:05:06Z INFO  pouet::infrastructure::service::swiss_army_man_service] Purged 164644 rows
[2023-10-17T21:05:08Z INFO  pouet::infrastructure::service::swiss_army_man_service] Compact kconfig entries of generation 2 in table 'kconfigs_and_versions'
[2023-10-17T21:05:42Z WARN  sqlx::query] summary="with d as( select …" db.statement="\n\nwith d as(\n  select\n    distinct id\n  from\n    versions\n  where\n    replace(id, 'pre', '') ~* $1\n    and processed = false\n  except\n  select\n    distinct version\n  from\n    temp_kconfigs_and_versions\n  where\n    replace(version, 'pre', '') ~* $2\n)\nselect\n  coalesce(jsonb_agg(id), '[]' :: jsonb) as output\nfrom\n  d;\n" rows_affected=0 rows_returned=1 elapsed=33.840588708s
[2023-10-17T21:05:42Z ERROR pouet] You must process the missing 45 releases before compacting releases of generation 2: [2.4.32, 2.4.33, 2.4.33.1, 2.4.33.2, 2.4.33.3, 2.4.33.4, 2.4.33.5, 2.4.33.6, 2.4.33.7, 2.4.34, 2.4.34.1, 2.4.34.2, 2.4.34.3, 2.4.34.4, 2.4.34.5, 2.4.34.6, 2.4.35, 2.4.35.1, 2.4.35.2, 2.4.35.3, 2.4.35.4, 2.4.35.5, 2.4.36, 2.4.36.1, 2.4.36.2, 2.4.36.3, 2.4.36.4, 2.4.36.5, 2.4.36.6, 2.4.36.7, 2.4.36.8, 2.4.36.9, 2.4.37, 2.4.37.1, 2.4.37.10, 2.4.37.11, 2.4.37.2, 2.4.37.3, 2.4.37.4, 2.4.37.5, 2.4.37.6, 2.4.37.7, 2.4.37.8, 2.4.37.9, 2.6.39.4]
make: *** [all] Error 1
```

