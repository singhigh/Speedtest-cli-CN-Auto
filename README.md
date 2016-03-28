# Speedtest-cli-CN-Auto
FOR ENGLISH INSTRUCTION, PLEASE ROLL DOWN

一个适用于Debian和Ubuntu的、以中国境内测速点为测速目标的测速脚本。

本脚本基于[speedtest.net](http://www.speedtest.net) 和 [speedtest-cli](https://github.com/sivel/speedtest-cli) 写成。
#### 使用方法
第一次运行，请安装[speedtest-cli](https://github.com/sivel/speedtest-cli) ，具体可依次输入：
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

或者

``
wget https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/install.sh --no-check-certificate && bash install.sh
``

然后，获取测速脚本。
``
wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest.sh
``

之后每次测速，只需运行测速脚本。

``
bash speedtest.sh
``


A Debian & Ubuntu shell for test speed for connection to China
Base on [speedtest.net](http://www.speedtest.net) & [speedtest-cli](https://github.com/sivel/speedtest-cli)

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
