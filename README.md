# Speedtest-cli-CN-Auto
A shell for test speed for connection to China
base on [speedtest.net](http://www.speedtest.net) & [speedtest-cli](https://github.com/sivel/speedtest-cli)

Usage:

* 1) For the first time, install speedtest-cli on your server by following commands

``
wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py
``

``
chmod a+rx speedtest_cli.py
``

``
sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli
``

``
sudo chown root:root /usr/local/bin/speedtest-cli
``

OR

``
wget https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/install.sh --no-check-certificate && bash install.sh
``

* 2)Download the shell for speedtest

``
wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest.sh
``

* 3)Run!

``
bash speedtest.sh
``
