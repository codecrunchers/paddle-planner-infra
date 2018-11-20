resource "aws_ecr_repository" "ecr" {
  count = "${length(var.registries)}"
  name  = "${lower(var.registries[count.index])}"
}
