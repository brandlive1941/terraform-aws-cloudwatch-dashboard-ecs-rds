locals {
  rds_db_connections_widget = [for database in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }]
      ]
      region = database.region
      annotations = {
        horizontal = [
          {
            color = "#d625ff",
            value = 50
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${database.db_instance_identifier} connections"
      period = var.period
    }
  }]

  rds_acu_util_widget = [for database in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "ACUUtilization", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }]
      ]
      region = database.region
      annotations = {
        horizontal = [
          {
            color = "#d625ff",
            value = 50
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${database.db_instance_identifier} acu utilization"
      period = var.period
    }
  }]

  rds_cpu_util = [for database in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#1f77b4", stat = "Maximum" }]
      ]
      region = database.region
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${database.db_instance_identifier} cpu utilization"
      period = var.period
    }
  }]

  cpu_widgets = [for name, widget in var.widgets : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        for service_name, color in widget.services : ["AWS/ECS", "CPUUtilization", "ServiceName", service_name, "ClusterName", widget.cluster_name, { color = color, stat = "Maximum" }]
      ]
      region = widget.region,
      annotations = {
        horizontal = [
          {
            color = "#d625ff",
            value = 100
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${name} cpu metrics"
      period = var.period
    }
  }]

  memory_widgets = [for name, widget in var.widgets : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        for service_name, color in widget.services : ["AWS/ECS", "MemoryUtilization", "ServiceName", service_name, "ClusterName", widget.cluster_name, { color = color, stat = "Maximum" }]
      ]
      region = widget.region,
      annotations = {
        horizontal = [
          {
            color = "#d625ff",
            value = 100
          }
        ]
      }
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${name} memory metrics"
      period = var.period
    }
  }]

  rds_latency = [for database in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#ff7f0e", stat = "Average" }],
        ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#2ca02c", stat = "Average" }],
      ]
      region = database.region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${database.db_instance_identifier} read/write latency"
      period = var.period
    }
  }]

  rds_disk_queue = [for database in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }],
      ]
      region = database.region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${database.db_instance_identifier} disk queue depth"
      period = var.period
    }
  }]


  rds_deadlocks = [for database in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "Deadlocks", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#1f77b4", stat = "Maximum" }],
        ["AWS/RDS", "BlockedTransactions", "DBInstanceIdentifier", database.db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }],
      ]
      region = database.region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "${database.db_instance_identifier} deadlocks and blocked transactions"
      period = var.period
    }
  }]

  # asg_metrics_widget = [for asg_name in var.asg_names : {
  #   type   = "metric"
  #   width  = 12
  #   height = 4
  #   properties = {
  #     view    = "singleValue"
  #     stacked = false
  #     metrics = [
  #       ["AWS/AutoScaling", "GroupMaxSize", "AutoScalingGroupName", asg_name, { color = "#1f77b4" }],
  #       ["AWS/AutoScaling", "GroupMinSize", "AutoScalingGroupName", asg_name, { color = "#ff7f0e" }],
  #       ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", asg_name, { color = "#2ca02c" }],
  #     ]
  #     region = widget.region
  #     yAxis = {
  #       left = {
  #         min = 0
  #       }
  #       right = {
  #         min = 0
  #       }
  #     }
  #     title  = "ASG Metrics - Max/Min/Desired - ${asg_name}"
  #     period = var.period
  #   }
  # }]

  rds         = concat(local.rds_db_connections_widget, local.rds_acu_util_widget, local.rds_latency, local.rds_disk_queue, local.rds_deadlocks)
  widget_list = flatten(concat(local.rds, local.cpu_widgets, local.memory_widgets))
}

resource "aws_cloudwatch_dashboard" "main" {

  count = var.dashboard_name != "" ? 1 : 0

  dashboard_name = var.dashboard_name
  dashboard_body = jsonencode({
    widgets = local.widget_list
  })

}