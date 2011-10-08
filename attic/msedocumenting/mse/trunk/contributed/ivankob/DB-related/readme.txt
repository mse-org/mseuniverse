The "build.sh" builds all trigger functions & triggers needed for enforcing referential integrity 
of data (PotgreSQL) for the case when foreign keys have to refer non-unique fields 
of other tables (when CONSTARAINTs are disallowed since assume referencing unique keys).

PS: 
Linux-only since based on symlinking.

