##################################################
# build docker image


resource "aws_ecr_repository" "this" {
  name                 = "${random_pet.this.id}-t360-tickets-api-image"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "build_api_image" {
  provisioner "local-exec" {
    command = <<EOT
      docker build -t ${aws_ecr_repository.this.repository_url}:latest .
    EOT
    working_dir = "./Svc.T360.Ticket/Svc.T360.Ticket/"
    interpreter = ["PowerShell", "-Command"]
  }
  
}


# loging to ecr

resource "null_resource" "login-ecr" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.region} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com
    EOT
  }
  
}


resource "null_resource" "push_image" {
  provisioner "local-exec" {
    command = <<EOT
      docker push ${aws_ecr_repository.this.repository_url}:latest
    EOT
    interpreter = ["PowerShell", "-Command"]
  
  }
  depends_on = [ null_resource.build_api_image ]
  
}

resource "aws_ecr_repository" "this_sec" {
  name                 = "${random_pet.this.id}-t360-tickets-api-image"
  image_tag_mutability = "MUTABLE"
  force_delete = true

  provider = aws.region2

  image_scanning_configuration {
    scan_on_push = true
  }
}



# loging to ecr

resource "null_resource" "login-ecr_sec" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.region2} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region2}.amazonaws.com
    EOT
  }
  
}

resource "null_resource" "tag_image_sec" {
  provisioner "local-exec" {
    command = <<EOT
      docker tag ${aws_ecr_repository.this.repository_url}:latest ${aws_ecr_repository.this_sec.repository_url}:latest
    EOT
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [ null_resource.build_api_image ]
}

resource "null_resource" "push_image_sec" {
  provisioner "local-exec" {
    command = <<EOT
      docker push ${aws_ecr_repository.this_sec.repository_url}:latest
    EOT
    interpreter = ["PowerShell", "-Command"]
  
  }
  depends_on = [ null_resource.tag_image_sec ]
  
}