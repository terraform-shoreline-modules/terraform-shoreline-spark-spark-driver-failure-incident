resource "shoreline_notebook" "spark_driver_failure_incident" {
  name       = "spark_driver_failure_incident"
  data       = file("${path.module}/data/spark_driver_failure_incident.json")
  depends_on = [shoreline_action.invoke_spark_error_log,shoreline_action.invoke_check_resource_availability,shoreline_action.invoke_update_spark_driver_memory]
}

resource "shoreline_file" "spark_error_log" {
  name             = "spark_error_log"
  input_file       = "${path.module}/data/spark_error_log.sh"
  md5              = filemd5("${path.module}/data/spark_error_log.sh")
  description      = "Step 7: Check the configuration files for any errors"
  destination_path = "/agent/scripts/spark_error_log.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "check_resource_availability" {
  name             = "check_resource_availability"
  input_file       = "${path.module}/data/check_resource_availability.sh"
  md5              = filemd5("${path.module}/data/check_resource_availability.sh")
  description      = "Insufficient resources (RAM, disk space, CPU) available for Apache Spark driver."
  destination_path = "/agent/scripts/check_resource_availability.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_spark_driver_memory" {
  name             = "update_spark_driver_memory"
  input_file       = "${path.module}/data/update_spark_driver_memory.sh"
  md5              = filemd5("${path.module}/data/update_spark_driver_memory.sh")
  description      = "Increase the resources allocated to the Apache Spark driver to prevent future failures."
  destination_path = "/agent/scripts/update_spark_driver_memory.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_spark_error_log" {
  name        = "invoke_spark_error_log"
  description = "Step 7: Check the configuration files for any errors"
  command     = "`chmod +x /agent/scripts/spark_error_log.sh && /agent/scripts/spark_error_log.sh`"
  params      = []
  file_deps   = ["spark_error_log"]
  enabled     = true
  depends_on  = [shoreline_file.spark_error_log]
}

resource "shoreline_action" "invoke_check_resource_availability" {
  name        = "invoke_check_resource_availability"
  description = "Insufficient resources (RAM, disk space, CPU) available for Apache Spark driver."
  command     = "`chmod +x /agent/scripts/check_resource_availability.sh && /agent/scripts/check_resource_availability.sh`"
  params      = ["MAX_CPU_USAGE_ALLOWED","MIN_FREE_MEM_REQUIRED","MIN_FREE_DISK_SPACE_REQUIRED","DRIVER_NODE_MOUNT_POINT"]
  file_deps   = ["check_resource_availability"]
  enabled     = true
  depends_on  = [shoreline_file.check_resource_availability]
}

resource "shoreline_action" "invoke_update_spark_driver_memory" {
  name        = "invoke_update_spark_driver_memory"
  description = "Increase the resources allocated to the Apache Spark driver to prevent future failures."
  command     = "`chmod +x /agent/scripts/update_spark_driver_memory.sh && /agent/scripts/update_spark_driver_memory.sh`"
  params      = ["PATH_TO_SPARK_DEFAULTS_CONF","NEW_DRIVER_MEMORY"]
  file_deps   = ["update_spark_driver_memory"]
  enabled     = true
  depends_on  = [shoreline_file.update_spark_driver_memory]
}

