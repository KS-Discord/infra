variable "username" {
  description = "Linux 유저명"
  type        = string
  default     = "k3s"
}

variable "uid" {
  description = "User ID"
  type        = number
  default     = 2000
}

variable "gid" {
  description = "Group ID"
  type        = number
  default     = 2000
}

variable "connection" {
  description = "SSH connection 설정"
  type = object({
    host        = string
    user        = string
    private_key = optional(string)
  })
}
