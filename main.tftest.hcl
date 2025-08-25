variables {
  aws_region = "us-east-1"
}

run "plan_phase" {
  command = plan
}

run "assert_phase" {
  command = plan

  assert {
    condition     = run.plan_phase.plan.exit_code == 0
    error_message = "O plano do Terraform deve ser gerado sem erros."
  }
}