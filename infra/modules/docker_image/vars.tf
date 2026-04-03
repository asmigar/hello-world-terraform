variable "release_version" {
  type        = string
  description = "Image version which needs to be deployed"
  default     = ""
}

variable "repository" {
  type        = string
  description = "url of ecr repository"
  default     = ""
}

variable "auth" {
  type        = object({
    user_name = string
    password = string
  })
  description = "auth for ecr"
}