wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz


echo """
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
""" > .profile

export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GO111MODULE=on
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

git clone https://github.com/CosmosContracts/juno
cd juno
git fetch
git clone v11.0.3

make install

junod init "chimera-juno" --chain-id juno-1
junod config chain-id juno-1


echo """

[Unit]
Description=\"juno node\"
After=network-online.target

[Service]
User=moz
Group=moz
WorkingDirectory=/home/moz/
ExecStart=/home/moz/go/bin/junod start

Environment=\"DAEMON_NAME=junod\"
Environment=\"DAEMON_HOME=/home/moz/.juno\"
Environment=\"DAEMON_ALLOW_DOWNLOAD_BINARIES=false\"
Environment=\"DAEMON_RESTART_AFTER_UPGRADE=true\"
Environment=\"UNSAFE_SKIP_BACKUP=true\"
Environment=\"GOPATH=$HOME/go\"
Environment=\"GOROOT=/usr/local/go\"
Environment=\"GO111MODULE=on\"
Environment=\"PATH=$PATH:/usr/local/go/bin:$HOME/go/bin\"

Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
""" > juno.service

sudo cp juno.service /etc/systemd/system/juno.service


sudo systemctl daemon-reload
sudo systemctl restart juno


wget -O juno_6689277.tar.lz4 https://api-minio-sud.imperator.co/snapshots/juno/juno_6689277.tar.lz4 --inet4-only

sudo systemctl stop juno

junod tendermint unsafe-reset-all --home $HOME/.juno --keep-addr-book

lz4 -c -d juno_6689277.tar.lz4 | tar -x -C $HOME/.juno

sudo systemctl restart juno && sudo journalctl -u juno -f

wget -O $HOME/.juno/config/addrbook.json https://api-minio-nord.imperator.co/addrbook/juno/addrbook.json --inet4-only

SEEDS="22ee6e65e5e79cd0b970dd11e52761de8d1d6dfd@seeds.pupmos.network:2001,90b09362d9ce3845096c4938eea0dba682b0ad2c@juno-seed-new.blockpane.com:26656,2484353dab0b2c1275765b8ffa2c50b
3b36158ca@seed-node.junochain.com:26656"
# Comma separated list of nodes to keep persistent connections to
PEERS="b1f46f1a1955fc773d3b73180179b0e0a07adce1@162.55.244.250:39656,7f593757c0cde8972ce929381d8ac8e446837811@178.18.255.244:26656,7b22dfc605989d66b89d2dfe118d799ea5abc2f0@167.99.210.65:26656,4bd9cac019775047d27f9b9cea66b25270ab497d@137.184.7.164:26656,bd822a8057902fbc80fd9135e335f0dfefa32342@65.21.202.159:38656,15827c6c13f919e4d9c11bcca23dff4e3e79b1b8@51.38.52.210:38656,e665df28999b2b7b40cff2fe4030682c380bf294@188.40.106.109:38656,92804ce50c85ff4c7cf149d347dd880fc3735bf4@34.94.231.154:26656,795ed214b8354e8468f46d1bbbf6e128a88fe3bd@34.127.19.222:26656,ea9c1ac0e91639b2c7957d9604655e2263abe4e1@185.181.103.136:26656"


sed -i.bak -e "s/^seeds *=.*/seeds = \"$SEEDS\"/" ~/.juno/config/config.toml
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" ~/.juno/config/config.toml
