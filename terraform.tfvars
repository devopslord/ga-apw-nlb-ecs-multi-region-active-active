region = "us-east-1"
region2 = "us-east-2"

module = "./"

database_username = "t360"

memory = 1024

cpu = 512

platform_name = "t360-project"

environment = "dev"

domain_name = "api.demo.waaron.org"

zone_id = "Z09010963BYUURYH5YI0A"

app_port = 8080

app_image = "public.ecr.aws/nginx/nginx:stable-perl"

availability_zones = [ "us-east-1a", "us-east-1b", "us-east-1c" ]

availability_zones_secondary = ["us-east-2a", "us-east-2b", "us-east-2c"]

app_count = "2"

app_count_max = "5"

load_test_domain = "load.demo.waaron.org"