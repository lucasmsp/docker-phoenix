import pandas as pd
import datetime

from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()

df = spark.createDataFrame([(2,'John Wick','avil', 'male', 635), (3,'Hannah','avil', 'female', 636)], ['pid', 'pname', 'drug', 'gender', 'tot_amt'])
spark.createDataFrame(df).write.format("org.apache.phoenix.spark").mode("overwrite").option("table", "patient").option("zkUrl", "phoenix:2181").save()






