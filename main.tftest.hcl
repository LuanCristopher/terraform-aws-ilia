variables {
  aws_region = "us-east-1"
}

run "validate_plan" {
  command = plan

  assert {
    condition     = self.plan.exit_code == 0
    error_message = "O plano do Terraform deve ser gerado sem erros."
  }
}