# mpsocbench_installer
Instalador para o MPSoCBench e dependências.

Testado em Ubuntu 14.04 e 16.04 ambos em x64

Para customizar o diretório de instalação, basta utilizar o parâmetro -dinstall=/exemploDir
Por padrão, será instalado na pasta /opt 

Executar o instalador sem nenhum parâmetro, irá mostrar um help com algumas informações uteis.



chmod +x mpsocbench_installer.sh
sudo ./mpsocbench_installer.sh -install -dinstall=/opt
bash -l (para iniciar uma nova sessão, ou então reiniciar a sessão fazendo logout)


cd /opt/mpsocbench (Acessar a pasta do MPSoCBench)
./MPSoCBench -p=mips -s=basicmath -n=1 -i=noc.lt -b
./MPSoCBench -p=mips -s=basicmath -n=1 -i=noc.lt -r


