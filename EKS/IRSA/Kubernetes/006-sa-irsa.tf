#----------IRSA Kubernetes Service Account----------
resource "kubernetes_service_account_v1" "sa_s3_test" {
  depends_on = [aws_iam_role_policy_attachment.attach_s3_policy]
  metadata {
    name      = local.irsa_sa_name
    namespace = local.irsa_namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.irsa_s3_test.arn # Attach IRSA Role to Kubernetes Service Account using annotation (eks.amazonaws.com/role-arn)
    }
  }
}
/*
#service account mainfest file (YAML) for IRSA
apiVersion: v1
kind: ServiceAccount
metadata:
  name: sa-s3-test
  namespace: default
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::277707094115:role/irsa-s3-test-role #----> Attach IRSA Role 
*/
