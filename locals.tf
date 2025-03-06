locals {
  json_data = jsondecode(data.aws_ssm_parameter.cartographer.insecure_value)
  subnet_ids = [
    data.aws_subnet.compute-private-subnet-1.id,
    data.aws_subnet.compute-private-subnet-2.id,
    data.aws_subnet.compute-private-subnet-3.id
  ]
  lambda_subnet_ids = [
    data.aws_subnet.lambda-private-subnet-1.id,
    data.aws_subnet.lambda-private-subnet-2.id,
    data.aws_subnet.lambda-private-subnet-3.id
  ]
  cartographer_config = nonsensitive(aws_ssm_parameter.cartographer-config.value)
}

