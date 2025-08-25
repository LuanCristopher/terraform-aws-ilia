run "validate_plan_succeeds" {
  command = plan

  assert {
    condition     = success()
    error_message = "O comando terraform plan falhou."
  }
}