There are 2 way for install and use it - befor install we should make sure that IRSA is configured
* ADD-ONS
* Helm install
---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3-test
    annotations:
      storageclass.kubernetes.io/is-default-class: "true"
    
provisioner: ebs.csi.aws.com

allowVolumeExpansion: true # optional, allows resizing of PVCs using this StorageClass

volumeBindingMode: WaitForFirstConsumer 

reclaimPolicy: Delete # or Retain, depending on your needs

parameters: # optional 

  type: gp3
  
  encrypted: "true"
  
  # kmsKeyId: "arn:aws:kms:eu-west-3:123456789012:key/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  
  fsType: ext4
---
  
<img width="834" height="443" alt="image" src="https://github.com/user-attachments/assets/fea5a3f1-b8c9-47d4-83e1-c85d41957867" />
<img width="1031" height="430" alt="image" src="https://github.com/user-attachments/assets/ebfe9833-3ddd-428c-a043-c176dc1ed0c6" />
<img width="420" height="326" alt="image" src="https://github.com/user-attachments/assets/c25e32f8-8abe-43b1-b050-a73154362d45" />

