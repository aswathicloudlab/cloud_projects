########################################################################################
# Define variables in this file                                                        #
########################################################################################

# Define variable for Azure location
variable "location" {
  description = "Default Azure location for resources"
  type        = string
  default     = "australiaeast"
}
# Define variable for each
variable "use_for_each" {
  description = "Use for_each instead of count"
  type        = bool
  default     = false
}

# Define variable project name
variable "project" {
  description = "Project name"
  type        = string
  default     = "cloudlab"
}

# Define environment name
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}
