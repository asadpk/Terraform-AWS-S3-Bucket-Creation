# Terraform-AWS-S3-Bucket-Creation
Steps to craete s3 bucket module for hosting a static website.First step create s3 bucket
First step create s3 bucket
resource "aws_s3_bucket" "s3_bucket_static_website" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.bucket_name}/*"
            ]
        }
    ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
  tags = var.tags
}
 This one is the second  step for creating s3 object for uploading a file.                
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object#content_type
# Sigle file uplaod on above s3 bucket to root location
resource "aws_s3_bucket_object" "example_object_1" {
  bucket       = aws_s3_bucket.s3_bucket_static_website.id
  key          = "index.html"
  source       = "E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket/index.html"
  etag         = filemd5("E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket/index.html")
  content_type = "text/html"

}
 This one is the third step. Multiple files uploading.
                 
                 # Multipal files form same dir upload to s3 buckt to root location.
resource "aws_s3_bucket_object" "example_folder" {
  bucket       = aws_s3_bucket.s3_bucket_static_website.id
  for_each     = fileset("E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket", "*.html")
  key          = each.value
  source       = "E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket/${each.value}"
  etag         = filemd5("E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket/${each.value}")
  content_type = "text/html"
}
                 
This one is the fourth step. Create folder and then upload  files in that folder from desktop to s3 bucket.
  # Create folder for uplaoding custom files.
resource "aws_s3_object" "custom_pages" {
  bucket       = aws_s3_bucket.s3_bucket_static_website.id
  key          = "${var.custom_file}/"
  acl          = "public-read"
  content_type = "application/x-directory"

}

# Multiple pages uplaoded to above folder name pages
resource "aws_s3_bucket_object" "example_multipale_pages" {
  bucket       = aws_s3_bucket.s3_bucket_static_website.id
  for_each     = fileset("E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket/www/pages", "*")
  key          = "${var.custom_file}/${each.value}"
  source       = "E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket/www/pages/${each.value}"
  etag         = filemd5("E:/terraform/cloudnloud/week13-Terraform-Class6/01-static-website/modules/aws-s3-static-website-bucket//www/pages/${each.value}")
  content_type = "text/html"
}               

All the variables decleard are present in variavles.tf file.
For learning please create s3 bucket resource first then commnet all the s3 objects and uncomment one by one 
                 
