# image保存 ####################################################
resource "aws_s3_bucket" "nurse_image" {
  bucket = "nurse-images-s3-bucket"
  force_destroy = true

  tags = {
    Name = "image bucket"
  }
}
################################################################

# albのログバケット関連 ########################################
# resource "aws_s3_bucket" "alb_log" {
#   bucket = "nurse-alb-log"
#   force_destroy = true

#   lifecycle_rule {
#     enabled = true

#     expiration {
#       days = "180"
#     }
#   }

#   tags = {
#     Name = "log bucket"
#   }
# }

# resource "aws_s3_bucket_policy" "alb_log" {
#   bucket = aws_s3_bucket.alb_log.id
#   policy = data.aws_iam_policy_document.alb_log.json
# }

# data "aws_iam_policy_document" "alb_log" {
#   statement {
#     effect = "Allow"
#     actions = ["s3:PutObject"]
#     resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log.id}/*"]

#     principals {
#       type = "AWS"
#       identifiers = ["582318560864"]
#     }

#   }

# }
################################################################
