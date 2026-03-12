# Resource: Helm Release 
resource "helm_release" "external_dns" {
  depends_on = [aws_iam_role.externaldns_iam_role, aws_eks_addon.coredns, time_sleep.wait_for_eks_access]
  name       = "external-dns"

  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"

  #namespace = "default" #---> 301 line 48 => we can install it in kube-system namespace and its a best practice one
  namespace = "kube-system"
  set = [
    {
      name  = "image.repository"
      value = "k8s.gcr.io/external-dns/external-dns"
    },
    {
      name  = "serviceAccount.create"
      value = "true"
    },
    {
      name  = "serviceAccount.name"
      value = "external-dns" #---> 301 line 48
    },
    {
      name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
      value = aws_iam_role.externaldns_iam_role.arn
    },
    {
      name  = "provider" # Default is aws (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
      value = "aws"
    },
    {
      name  = "policy" # Default is "upsert-only" which means DNS records will not get deleted even equivalent Ingress resources are deleted (https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
      value = "sync"   # "sync" will ensure that when ingress resource is deleted, equivalent DNS record in Route53 will get deleted
    }
  ]

}
