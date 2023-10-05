

#!/bin/bash



# Set the path to the Spark configuration file

SPARK_CONF=${PATH_TO_SPARK_DEFAULTS_CONF}



# Set the new value for the Spark driver memory

NEW_DRIVER_MEMORY=${NEW_DRIVER_MEMORY}



# Update the spark.driver.memory configuration in spark-defaults.conf

sed -i "s/^spark.driver.memory\s*=.*$/spark.driver.memory $NEW_DRIVER_MEMORY/g" $SPARK_CONF