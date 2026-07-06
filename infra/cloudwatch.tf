#############################################
# Scale Up Policy
#############################################

resource "aws_autoscaling_policy" "scale_up" {

  name                   = "scale-up-policy"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 300

  autoscaling_group_name = aws_autoscaling_group.web.name

}

#############################################
# Scale Down Policy
#############################################

resource "aws_autoscaling_policy" "scale_down" {

  name                   = "scale-down-policy"
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 300

  autoscaling_group_name = aws_autoscaling_group.web.name

}

#############################################
# High CPU Alarm
#############################################

resource "aws_cloudwatch_metric_alarm" "high_cpu" {

  alarm_name          = "HighCPU"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods  = 2

  metric_name         = "CPUUtilization"

  namespace           = "AWS/EC2"

  period              = 120

  statistic           = "Average"

  threshold           = 70

  alarm_description   = "Scale Up"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up.arn
  ]

}

#############################################
# Low CPU Alarm
#############################################

resource "aws_cloudwatch_metric_alarm" "low_cpu" {

  alarm_name          = "LowCPU"

  comparison_operator = "LessThanThreshold"

  evaluation_periods  = 2

  metric_name         = "CPUUtilization"

  namespace           = "AWS/EC2"

  period              = 120

  statistic           = "Average"

  threshold           = 20

  alarm_description   = "Scale Down"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_down.arn
  ]

}