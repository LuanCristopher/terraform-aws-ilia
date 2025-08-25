run "apply_with_variables" {
  command = apply

  assert {
    condition     = run.apply_with_variables.output.vpc_id != ""
    error_message = "O ID da VPC não deve estar vazio após o apply."
  }
}