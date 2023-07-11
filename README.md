BASIC STEPS WITHOUT DEALING WITH ENV


get k3s and kubectl
 curl -sfL https://get.k3s.io | sh -  

  kubectl version    
 k3s --version  
 ls -lsa /etc/rancer/k3s/k3s.yaml    
 whoami
 sudo chown mlmogford:mlmogford /etc/rancher/k3s/k3s.yaml 
 kubectl get nodes/pods
 kustomize --v        
curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash 
sudo mv kustomize /usr/local/bin 

save files as kustomization.yaml ** in the project directory

add config to kustomization.yaml
i.e.
```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - github.com/ansible/awx-operator/config/default?ref=0.28.0

images:
  - name: quay.io/ansible/awx-operator
    newTag: 0.28.0

namespace: awx
```

kustomize build . | kubectl apply -f -
kick off build of awx operator

kubectl get pods --namespace awx

make awx.yaml \
i.e.
```yaml
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx
spec:
  service_type: nodeport
  nodeport_port: 30080 
  ```

kubectl get pods --namespace awx

while building check logs
https://github.com/ansible/awx-operator
from here but the command requires tailoring?
$ kubectl logs -f deployments/awx-operator-controller-manager -c awx-manager


need to get password
from same location, needs 
$ kubectl -n awx get secret awx-admin-password -o  go-template='{{range $k,$v := .data}}{{printf "%s: " $k}}{{if not $v}}{{$v}}{{else}}{{$v | base64decode}}{{end}}{{"\n"}}{{end}}'


then go to ip address:port from awx config
check resources form awx control

start at credentials for ssh passwords, github etc, then preovision resources via awx

Run kubectl kustomize ./ to view the Deployment


---------------------

to run a git repo from a playbook, follow these instructions, current awx and example tower layouts are different but functionally the same

for local file
There are no available playbook directories in /var/lib/awx/projects. Either that directory is empty, or all of the contents are already assigned to other projects. Create a new directory there and make sure the playbook files can be read by the "awx" system user, or have AWX directly retrieve your playbooks from source control using the Source Control Type option above.


sudo mkdir /var/lib/awx/projects

sudo nano  hello_local.yaml

```yaml
- name: Hello World Sample
  hosts: all
  tasks:
    - name: Hello Message
      debug:
        msg: "Hello World!"
```
https://github.com/ansible/awx/issues/857




<!-- 
First you need to create your own docker network (mynet123)

docker network create --subnet=172.18.0.0/16 ansiblenet


then, simply run the image (I'll take ubuntu as example)

docker run --net ansiblenet --ip 172.18.0.22 -it ansible

DONOT DO ABOVE -->

docker build -t ansible:latest . 


docker run -p 6443 -it ansible     

run via vscode so code is executed within the container, or just run the container in a toerminal

wehen running - run this

mkdir /etc/kubernetes/  

touch /etc/kubernetes/admin.conf

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config



<!-- curl -sfL https://get.k3s.io | sh - -->


