# Phoenix cluster in docker

This project provides a mini cluster in docker with a minimal tools to test Apache HBase, Phoenix and Spark. 

## Quickstart

1. Start the cluster (`docker-start.sh`), this will launch both containers (Hbase/Phoenix and Spark) and copy some jars between them;
2. To run a query in Phoenix directly: 
    * Enter in Spark container: `docker-compose exec it spark bash`
    * Start pyspark: `$ /usr/local/spark/bin/pyspark`

3. At end, one can stop by `docker-compose stop`
    
    
    
## Example:
    
A quick example of how write data in phoenix trough spark is provided in `/tmp/sample/test_phoenix.py`. 

1. First create a table inside Phoenix container: Start the Sqlline `/opt/phoenix-server/bin/sqlline.py`;
2. Run SQL Query: 
```
create table patient(pid integer not null primary key, p.pname varchar, p.drug varchar, p.gender varchar, p.tot_amt integer);
upsert into patient values(1,'Veda Hopkins','avil', 'male', 634);
select * from patient where GENDER = 'male';
```

3. Inside Spark container, run `bash /tmp/sample/run.sh` or `/usr/local/spark/bin$ ./spark-submit /tmp/sample/test_phoenix.py` 


## Observation:

* Other Phoenix/HBase parameters can be set in server side by changing the file `/phoenix/start-hbase-phoenix.sh`;
* Client side parameters can be set in `/spark/hbase-site.xml`. When started this container, one can change it in `/usr/local/spark/conf/hbase-site.xml`


