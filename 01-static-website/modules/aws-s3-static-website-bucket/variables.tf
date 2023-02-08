variable "bucket_name" {
  type        = string
  description = "Name of the s3 bucket. Must be unique."


}
variable "tags" {
  description = "Tags to set on the bucket."
  type        = map(string)
  default     = {}

}

variable "custom_file" {
  type    = string
  default = "pages"

}