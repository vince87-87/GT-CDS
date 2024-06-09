resource "aws_ecr_repository" "this" {
  count = var.create_ecr ? 0 : 1

  name                 = var.ecr_name[count.index]
  image_tag_mutability = "MUTABLE"
}