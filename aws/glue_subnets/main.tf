data "aws_subnet" "example" {
  count = length(var.subnet_ids)
  id = element(var.subnet_ids, count.index)
}
resource "aws_glue_connection" "subnet_availability" {
  count = length(var.subnet_ids)

  name = "${var.glue_connection_prefix}${count.index+1}"

  connection_type = "NETWORK"

  physical_connection_requirements {
    availability_zone = element(data.aws_subnet.example, count.index).availability_zone
    subnet_id = element(var.subnet_ids, count.index)
    security_group_id_list = ["${var.eks_worker_sg}"]
  }

  connection_properties = {
    KAFKA_SSL_ENABLED = "false"
  }

}