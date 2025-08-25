run "plan" {
  command = plan
}

run "output_check" {
  variables = {
    aws_region = "us-east-1"
  }
  command = "apply"

  assert {
    condition = run.plan.exit_code == 0
    error_message = "O plano não deve ter erros de sintaxe."
  }
}