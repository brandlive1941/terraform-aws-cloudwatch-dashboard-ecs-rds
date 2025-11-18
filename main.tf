data "aws_region" "current" {}

resource "aws_cloudwatch_dashboard" "main" {

  count = var.dashboard_name != "" ? 1 : 0

  dashboard_name = var.dashboard_name
  dashboard_body = jsonencode({
    widgets = local.widgets
  })

}


locals {
  aws_region = data.aws_region.current.name

  rds_db_connections_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }]
      ]
      region = local.aws_region
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
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
      title  = "RDS Database Connections - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_acu_util_widget = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "ACUUtilization", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }]
      ]
      region = local.aws_region
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
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
      title  = "Aurora ACU Utilization - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_cpu_util = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", db_instance_identifier, { color = "#1f77b4", stat = "Maximum" }]
      ]
      region = local.aws_region
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "Aurora CPUUtilization Metrics - ${db_instance_identifier}"
      period = var.period
    }
  }]

  ecs_cpu_util = [ {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        for service_name in var.service_names : ["AWS/ECS", "CPUUtilization", "ServiceName", service_name, "ClusterName", var.cluster_name, { color = "#d62728", stat = "Maximum" }]
      ]
      region = local.aws_region,
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
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
      title  = "ECS CPU and Memory Metrics - ${var.cluster_name} / ${service_name}"
      period = var.period
    }
  }]

  ecs_memory_util = [ {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        for service_name in var.service_names : ["AWS/ECS", "MemoryUtilization", "ServiceName", service_name, "ClusterName", var.cluster_name, { color = "#1f77b4", stat = "Maximum" }]
      ]
      region = local.aws_region,
      annotations = {
        horizontal = [
          {
            color = "#ff0000",
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
      title  = "ECS CPU and Memory Metrics - ${var.cluster_name} / ${service_name}"
      period = var.period
    }
  }]

  rds_latency = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "ReadLatency", "DBInstanceIdentifier", db_instance_identifier, { color = "#ff7f0e", stat = "Average" }],
        ["AWS/RDS", "WriteLatency", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Average" }],
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Read/Write Latency - ${db_instance_identifier}"
      period = var.period
    }
  }]

  rds_cpu_credit = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 4
    height = 4
    properties = {
      view    = "pie"
      stacked = true
      metrics = [
        ["AWS/RDS", "CPUCreditBalance", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Sum" }],
        ["AWS/RDS", "CPUCreditUsage", "DBInstanceIdentifier", db_instance_identifier, { color = "#9467bd", stat = "Sum" }],
      ]
      region = local.aws_region

      legend = {
        position = "right"
      }

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS CPU Credit Metrics - ${db_instance_identifier}"
      period = 60
    }
  }]

  rds_disk_queue = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "DiskQueueDepth", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }],
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Disk Queue Depth - ${db_instance_identifier}"
      period = var.period
    }
  }]


  rds_deadlocks = [for db_instance_identifier in var.rds_names : {
    type   = "metric"
    width  = 12
    height = 8
    properties = {
      view    = "timeSeries"
      stacked = false
      metrics = [
        ["AWS/RDS", "Deadlocks", "DBInstanceIdentifier", db_instance_identifier, { color = "#1f77b4", stat = "Maximum" }],
        ["AWS/RDS", "BlockedTransactions", "DBInstanceIdentifier", db_instance_identifier, { color = "#2ca02c", stat = "Maximum" }],
      ]
      region = local.aws_region

      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "RDS Deadlocks and Blocked Transactions - ${db_instance_identifier}"
      period = var.period
    }
  }]

  asg_metrics_widget = [for asg_name in var.asg_names : {
    type   = "metric"
    width  = 12
    height = 4
    properties = {
      view    = "singleValue"
      stacked = false
      metrics = [
        ["AWS/AutoScaling", "GroupMaxSize", "AutoScalingGroupName", asg_name, { color = "#1f77b4" }],
        ["AWS/AutoScaling", "GroupMinSize", "AutoScalingGroupName", asg_name, { color = "#ff7f0e" }],
        ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", asg_name, { color = "#2ca02c" }],
      ]
      region = local.aws_region
      yAxis = {
        left = {
          min = 0
        }
        right = {
          min = 0
        }
      }
      title  = "ASG Metrics - Max/Min/Desired - ${asg_name}"
      period = var.period
    }
  }]

  widgets = concat(local.rds_db_connections_widget, local.rds_acu_util_widget,  local.ecs_cpu_util, local.ecs_memory_util, local.rds_latency, local.rds_disk_queue, local.rds_cpu_credit, local.rds_deadlocks, local.asg_metrics_widget)

}
