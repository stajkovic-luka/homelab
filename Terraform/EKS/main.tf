provider "" {
    backend "s3" {
        bucket = "demo-terraform-state-bucket-eucentral1"
        key    = "terraform-eks-state-lock"
        region = "us-east-1"
    }

}
