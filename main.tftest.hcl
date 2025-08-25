run "validate_plan_generates_outputs" {
  command = plan

  assert {
    condition     = run.validate_plan_generates_outputs.output.vpc_id != ""
    error_message = "O output 'vpc_id' não foi encontrado no plano, indicando uma falha."
  }
}