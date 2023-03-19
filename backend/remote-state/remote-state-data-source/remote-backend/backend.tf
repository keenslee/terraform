# Define provider
provider "aws" {
  region = "us-west-2"
}

# Create KMS key
resource "aws_kms_key" "s3_bucket_key" {
  description = "Key for S3 bucket encryption"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::989301192042:root"},
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow administration of the key",
      "Effect": "Allow",
      "Principal": {"AWS": "arn:aws:iam::989301192042:user/Kingsley"},
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "Allow use of the key",
      "Effect": "Allow",
      "Principal": {"AWS": "*"},
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Create S3 bucket and enable server-side encryption with KMS key
resource "aws_s3_bucket" "bootcamp30-12345-kingsley" {
  bucket = "bootcamp30-12345-kingsley"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3_bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
