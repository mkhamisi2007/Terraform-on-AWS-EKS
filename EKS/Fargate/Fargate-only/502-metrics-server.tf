resource "helm_release" "metrics_server" {

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_eks_addon.coredns ,
    time_sleep.wait_for_eks_access
  ]

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"

  namespace = "kube-system"

  set = [{
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
    },
    {
      name  = "args[1]"
      value = "--kubelet-preferred-address-types=InternalIP"
    }
  ]

}
