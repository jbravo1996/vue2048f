variable "ami_aws" {
  description = ""
  default     = "ami-0d71ea30463e0ff8d"
}

variable "instanceType_aws" {
  description = ""
  default     = "t2.micro"
}

variable "sgID_aws" {
  description = ""
  default     = ["sg-00f458cfe09c69d5c"]
}

variable "key_aws" {
  description = ""
  default     = "sinensia-key"
}

variable "subnetID_aws" {
  description = ""
  default     = "subnet-08b5507d0a110f5ea"
}

variable "tagNAME_aws" {
  description = ""
  default     = "terraformInstance"
}

variable "tagAPP_aws" {
  description = ""
  default     = "vue2048"
}

variable "region_aws" {
  description = ""
  default     = "eu-west-1"
}