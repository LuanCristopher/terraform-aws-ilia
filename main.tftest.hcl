variables {
  aws_region = "us-east-1"
}

run "setup" {
  command = apply
}

run "validation" {
  command = plan

  assert {
    condition     = run.setup.output.vpc_id != ""
    error_message = "O ID da VPC não deve estar vazio após o apply."
  }
}