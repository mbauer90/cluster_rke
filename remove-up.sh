config=cluster-minimo.yml


rke remove --config ${config}

docker stop $(docker ps -a -q)
docker rm -f $(docker ps -a -q)
docker volume prune -f
docker rmi -f $(docker image ls -a -q)

iptables -t filter -F
iptables -t nat -F

echo "Contêineres:"
docker ps -a
echo "Continuar..."
read enter

echo -e "\nImagens:"
docker image ls -a
echo "Continuar..."
read enter

echo -e "\nFirewall:"
iptables -t filter -L -n -v
iptables -t nat -L -n -v
echo "Continuar..."
read enter

echo -e "\nExecutar RKE?"
read enter

rke up --config ${config}
