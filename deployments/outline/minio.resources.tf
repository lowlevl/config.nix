resource "minio_iam_user" "self" {
  name = "outline-serviceaccount"
}

data "minio_iam_policy_document" "user" {
  statement {
    sid    = "ManageObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = ["arn:aws:s3:::${var.s3.bucket}/*"]
  }
}

resource "minio_iam_policy" "self" {
  name   = "readwrite-${var.s3.bucket}"
  policy = data.minio_iam_policy_document.user.json
}

resource "minio_iam_user_policy_attachment" "self" {
  user_name   = minio_iam_user.self.id
  policy_name = minio_iam_policy.self.id
}

resource "minio_s3_bucket" "self" {
  bucket = var.s3.bucket
}

data "minio_iam_policy_document" "bucket" {
  statement {
    sid    = "PublicObjects"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principal = "*"
    resources = ["arn:aws:s3:::${var.s3.bucket}/public/*"]
  }
}

resource "minio_s3_bucket_policy" "self" {
  bucket = minio_s3_bucket.self.bucket
  policy = data.minio_iam_policy_document.bucket.json
}
