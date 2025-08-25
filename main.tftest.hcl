run "validate_plan" {
  command = plan

  assert {
    condition     = output.vpc_id != ""
    error_message = "O output vpc_id não foi gerado no plano, indicando uma falha."
  }
}