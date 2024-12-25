###############################################################################################################################################
########################################################## Compute ############################################################################
###############################################################################################################################################

# launch template and auto scaling group for bastion

resource "aws_launch_template" "three_tier_bastion" {
  name                   = "three-tier-bastion"
  image_id               = var.ami_value
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.three_tier_bastion_sg]
  key_name               = var.key_name

  tags = {
    Name = "three_tier_bastion"
  }
}

resource "aws_autoscaling_group" "three_tier_bastion_asg" {
  name = "three-tier-bastion-ASG"
  vpc_zone_identifier = var.three_tier_web_pubsub
  max_size            = 1
  min_size            = 1
  desired_capacity    = 1

  launch_template {
    id = aws_launch_template.three_tier_bastion.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "three_tier_bastion"
    propagate_at_launch = true
  }

}


# launch template and auto scaling group for frontend web-app on web tier

resource "aws_launch_template" "three_tier_frontend_web_lt" {
  name                   = "three-tier-frontend-web-lt"
  image_id               = var.ami_value
  instance_type          = var.instance_type
  vpc_security_group_ids = [var.three_tier_frontend_web_tier_sg]
  key_name               = var.key_name
  iam_instance_profile {
    name                 = "s3_artifact_instance_profile"
  }
  user_data              = filebase64("install_apache.sh")

  tags = {
    Name = "three_tier_frontend_web"
  }
}

resource "aws_autoscaling_group" "three_tier_frontend_web_asg" {
  
  name = "three-tier-frontend-web-asg"
  vpc_zone_identifier = var.three_tier_web_pubsub
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2


  launch_template {
    id      = aws_launch_template.three_tier_frontend_web_lt.id
    version = "$Latest"
  }

  target_group_arns = [var.aws_alb_target_group_arn]

  tag {
    key                 = "Name"
    value               = "three_tier_frontend_web"
    propagate_at_launch = true
  }
  
  health_check_type = "EC2"
}

resource "aws_autoscaling_attachment" "asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.three_tier_frontend_web_asg.id
  lb_target_group_arn    = var.aws_alb_target_group_arn
}

# launch template and auto scaling group for backend app on app tier

resource "aws_launch_template" "three_tier_backend_app_lt" {
  name_prefix               = "three-tier-backend-app-lt"
  image_id                  = var.ami_value
  instance_type             = var.instance_type
  vpc_security_group_ids    = [var.three_tier_backend_app_tier_sg]
  key_name                  = var.key_name
  iam_instance_profile {
    name = "s3_artifact_instance_profile"
  }
  user_data = filebase64("install_node.sh")
  
  tags = {
    Name = "three_tier_backend_app"
  }
}

resource "aws_autoscaling_group" "three_tier_backend_app_asg" {
  name = "three-tier-backend-app-asg"
  vpc_zone_identifier = var.three_tier_app_pvtsub
  max_size            = 3
  min_size            = 2
  desired_capacity    = 2

  launch_template {
    id = aws_launch_template.three_tier_backend_app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "three_tier_backend_app"
    propagate_at_launch = true
  }

}

