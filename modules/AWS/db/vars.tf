variable "cluster_name" {
  type = string
  description = "Name of the Aurora Cluster"
  default = "Aurora-mcloud-showcase-cluster"
}

variable "cluster_instance_name" {
  type = string
  description = "Name of the Aurora Cluster Instance"
  default = "Aurora-mcloud-showcase-cluster-instance"
}
