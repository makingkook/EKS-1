# EKS_ALB

## 1. OIDC
```powershell
eksctl utils associate-iam-oidc-provider \
  --cluster=wsi-eks-cluster \
  --region=ap-northeast-1 \
  --approve
```

## 2. IAM Policy
```powershell
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
```
```powershell
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json \
  --region ap-northeast-1
```

## 3. IAM Role + ServiceAccount
#### 3-1: ServiceAccount batch
```powershell
eksctl create iamserviceaccount \
  --cluster=wsi-eks-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn={IAM_ARN} \
  --override-existing-serviceaccounts \
  --approve
```
#### 3-2: add to helm repository
```powershell
helm repo add eks https://aws.github.io/eks-charts
```
#### 3-3 repo update
```powershell
helm repo update
```
#### 3-4 install controller
```powershell
helm install aws-load-balancer-controller \
eks/aws-load-balancer-controller \
-n kube-system \
--set clusterName=wsi-eks-cluster \
--set serviceAccount.create=false \
--set serviceAccount.name=aws-load-balancer-controller \
--set region=ap-northeast-1 \
--set vpcId={vpcID}
```

# Grafana

## 1.Add helm repository
```powershell
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```
## 2. repo updata
```powershell
repo updata
```
## 3. Apply values.yaml
## 4. install helm
```powershell
 helm install monitoring prometheus-community/kube-prometheus-stack \
  -n monitoring \
  -f values.yaml
```
# Prometheus
## 1. execute prometheus
```powershell
kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090
```
## 2. local port forwarding
```powershell
ssh -i "bastion.pem" -L 9090:localhost:9090 ec2-user@43.207.138.198
```


