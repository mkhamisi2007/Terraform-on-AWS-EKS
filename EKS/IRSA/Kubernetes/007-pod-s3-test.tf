resource "kubernetes_pod_v1" "s3_test" {
  metadata {
    name      = "pod-s3-test"
    namespace = local.irsa_namespace
  }

  spec {
    service_account_name = kubernetes_service_account_v1.sa_s3_test.metadata[0].name
    restart_policy       = "Never"

    container {
      name  = "awscli"
      image = "amazon/aws-cli:2.15.57"

      command = ["/bin/sh", "-c"]
      args = [
        "echo 'Testing IRSA to S3...' && aws sts get-caller-identity && aws s3 ls s3://${local.s3_bucket_name} && sleep 3600"
      ]
    }
  }
}

/*
# pod mainifest file (YAML) for testing IRSA to S3
apiVersion: v1
kind: Pod
metadata:
  name: pod-s3-test
  namespace: default
spec:
  serviceAccountName: sa-s3-test #-----> reference to Kubernetes Service Account created for IRSA
  restartPolicy: Never
  containers:
    - name: awscli
      image: amazon/aws-cli:2.15.57
      command: ["/bin/sh", "-c"]
      args:
        - >
          echo "Testing IRSA to S3..." &&
          aws sts get-caller-identity &&
          aws s3 ls s3://mohammad-khamisi-us-bucket &&
          sleep 3600
*/