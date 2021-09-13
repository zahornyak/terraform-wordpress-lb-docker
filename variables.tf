# instance
variable "region" {
    default = "eu-central-1"
}
variable "ami" {
    default = "ami-0bad4a5e987bdebde"
}

variable "availability_zone" {
    default = "eu-central-1c"
}


variable "instance_type" {
    default = "t2.micro"
}

variable "key_name" {
    default = "pair-for-tasks"
}


variable "vpc_id" {
    default = "vpc-4010982a"
}

variable "subnets" {
    default = {
        suba = "subnet-7f691a15"
        subb = "subnet-ad943ad1"
        subc = "subnet-ee52efa2"
    }
}

variable "target_type" {
    default = "instance"
}

variable "target_name" {
    default = "target-terraform111"
}

variable "certificate_arn" {
    default = " "
}

variable "sgname" {
    default = "testing-task"
}

variable "data_instance" {
    default = "i-0e8615ce123e9749c"
}