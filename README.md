### KUBECTL
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl

kubectl version --client

### RKE
curl -s https://api.github.com/repos/rancher/rke/releases/latest | grep download_url | grep amd64 | cut -d '"' -f 4 | wget -qi -

chmod +x rke_linux-amd64

sudo mv rke_linux-amd64 /usr/local/bin/rke

rke --version

### INSTALL HELM
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh

### CRIARA ARQUIVO 
rke config --name cluster_padrao.yml

rke up --config cluster_padrao.yml

### EXPORTAR CONFIGURAÇÃO PARA KUBECTL TER ACESSO AO CLUSTER
export KUBECONFIG=./kube_config_cluster.yml

### INSTALAR CERTBOT (tccmurilo.sj.ifsc.edu.br)
apt install certbot

ls -lah /etc/letsencrypt/live/tccmurilo.sj.ifsc.edu.br/

/etc/letsencrypt/live/tccmurilo.sj.ifsc.edu.br/cert.pem

/etc/letsencrypt/live/tccmurilo.sj.ifsc.edu.br/privkey.pem

### CRIAR SECRET COM CERTIFICADO E CHAVE
kubectl -n ingress-nginx create secret tls ingress-default-cert \\
--cert=/etc/letsencrypt/live/tccmurilo.sj.ifsc.edu.br/fullchain.pem \\
--key=/etc/letsencrypt/live/tccmurilo.sj.ifsc.edu.br/privkey.pem -o yaml > ingress-default-cert.yaml

kubect create -f ingress-default-cert.yaml

### INSTALAR O MIRANTIS LENS (MÁQUINA LOCAL)
sudo snap install kontena-lens --classic

curl 127.0.0.1:6443/api

nmap -p 6443 tccmurilo.sj.ifsc.edu.br

### INSTALAR NFS-SERVER PARA GERAR UM STORAGECLASS COM O NOME nfs
helm repo add kvaps https://kvaps.github.io/charts

helm update repo

helm install nfs-default kvaps/nfs-server-provisioner

### INSTALAR INGRESS CONTROLLER NGINX
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

helm install app-ingress ingress-nginx/ingress-nginx
### INSTALAR GITLAB
kubectl create -f pvc_gitlab_geral.yml

helm upgrade --install gitlab gitlab/gitlab --timeout 600s  -f gitlab/values_gitlab.yml

### Senha root
kubectl get secret gitlab-gitlab-initial-root-password -o go-template='{{.data.password}}' | base64 -d && echo

### INSTALAR GITLAB-RUNNER (VERIFICANDO TOKEN)
helm install --namespace default gitlab-runner gitlab/gitlab-runner -f gitlab/values_runner.yml

### INSTALAR GERRIT
kubectl create -f gerrit/gerrit_nfs.yml

helm install gerrit-master k8s-gerrit/helm-charts/gerrit -n default -f k8s-gerrit/helm-charts/gerrit/values.yaml
