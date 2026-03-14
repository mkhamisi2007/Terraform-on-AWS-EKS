resource "helm_release" "fluentbit" {
  depends_on = [time_sleep.wait_for_eks_access]
  name       = "fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  namespace  = "amazon-cloudwatch"

  create_namespace = true

  set = [
    {
      name  = "cloudWatch.region"
      value = var.aws_region
    },
    {
      name  = "cloudWatch.logGroupName"
      value = "/eks/fluentbit-logs"
    },
    {
      name  = "cloudWatch.logStreamPrefix"
      value = "from-fluentbit-"
    }
  ]
}
resource "helm_release" "cloudwatch_observability" {
  depends_on       = [time_sleep.wait_for_eks_access]
  name             = "amazon-cloudwatch-observability"
  repository       = "https://aws-observability.github.io/helm-charts"
  chart            = "amazon-cloudwatch-observability"
  namespace        = "amazon-cloudwatch"
  create_namespace = true

  set = [
    {
      name  = "clusterName"
      value = aws_eks_cluster.eks_cluster.name
    },
    {
      name  = "region"
      value = var.aws_region
    }
  ]
}
