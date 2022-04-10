# INSTALL ARGO CD WITH k3s CLUSTER - AWS

# MASTER
aws ec2 run-instances --image-id ami-0b0ea68c435eb488d --count 1 --instance-type t3a.medium --key-name key-pem-aws --security-group-ids sg-id-aws --subnet-id subnet-id-aws --user-data file://k3s.sh --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=rancher-master}]' 'ResourceType=volume,Tags=[{Key=Name,Value=rancher-master}]'

Type :wq!

## Enter master instancce
ssh -i key-pem-aws.pem ubuntu@INSTANCE_MASTER_PUBLIC_IP

### Remove error if connect with MAC (WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED)
ssh-keygen -R INSTANCE_MASTER_PUBLIC_IP

## Get token:
sudo su
cat /var/lib/rancher/k3s/server/node-token

Type:  K105e94c233ac7f06c5664ec232393bf2adc84fe4f117429796386d640b2cdd8414::server:bcb2323d5cf31b513ea7dfedba3e33da

Get the token and ip from the master and make the string to run in the k3s-node.sh file
Get private IP from master instance and paste in k3s-node.sh

k3s-node.sh
curl -sfL https://get.k3s.io | K3S_URL=https://PRIVATE_MASTER_IP:6443 K3S_TOKEN=TOKEN_FROM_MASTER sh -


# NODE X (count = 1 number of nodes/instances to create)
aws ec2 run-instances --image-id ami-0b0ea68c435eb488d --count 1 --instance-type t3a.medium --key-name key-pem-aws --security-group-ids sg-id-aws --subnet-id subnet-id-aws --user-data file://k3s-node.sh --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=rancher-node1}]' 'ResourceType=volume,Tags=[{Key=Name,Value=rancher-node1}]'

### Entrar no node=1
ssh -i key-pem-aws.pem ubuntu@INSTANCE_NODE1_PUBLIC_IP


#### Install argoccd
sudo su
kubectl create namespace argocd
kubectl get namespaces
kubectl apply -n argocd -f https://raw.githubusercontent.com/investeusa/argocdtest/main/install.yaml
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
kubectl port-forward svc/argocd-server -n argocd 8080:444
connect ssh another tab
sudo su
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
copy password

Browser:
http://PUBLIC_MASTER_IP:82
Login: admin, password copyed