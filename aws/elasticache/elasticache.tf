###
# AWS Elasticache Redis for Notification application
###

resource "aws_elasticache_subnet_group" "notification-canada-ca-cache-subnet" {
    name       = "notification-canada-ca-${var.env}-cache-subnet"
    subnet_ids = var.vpc_private_subnets
}

resource "aws_elasticache_cluster" "notification-cluster-cache" {
    # Default is false with this param, it looks counter-intuitive because
    # applied changes would only happen during maintenance window if false.
    apply_immediately    = true
    cluster_id           = "notification-cluster-cache"
    engine               = "redis"
    # The nearest versions of Redis supported by AWS next to the one we
    # use (i.e. v3.5.3) would be 3.2.10 or 4.0.10. The former does not
    # support in-transit and at rest encryption whereas the latter does.
    # Hence I picked the higher major version for now. [1][2]
    #
    # One also have to be useful when defining the version to check if it
    # is deprecated by AWS. Version 6 also has lot more advantages, if we're
    # willing to do the upgrade in this dev iteration. [3]
    #
    # [1] https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html#redis-version-3-2-10
    # [2] https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html#redis-version-4-0-10
    # [3] https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/supported-engine-versions.html
    engine_version       = "4.0.10"
    # REVIEW: RDS maintenance is on Wed, this one Thursday,
    # or we prefer the same time window for both?
    maintenance_window   = "thu:04:00-thu:05:00"
    node_type            = var.elasticache_node_type
    num_cache_nodes      = 1
    parameter_group_name = "default.redis4.0"
    port                 = 6379
    security_group_ids   = [
        var.eks_cluster_securitygroup
    ]
    subnet_group_name    = aws_elasticache_subnet_group.notification-canada-ca-cache-subnet.name

    tags = {
        CostCenter = "notification-canada-ca-${var.env}"
    }
}
