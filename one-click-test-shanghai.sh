# GET speedtest-cli
wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py 
chmod a+rx speedtest_cli.py 
sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli 
sudo chown root:root /usr/local/bin/speedtest-cli 
# GET speedtest-script
wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest-choice.sh 
# RUN script
bash speedtest-choice.sh shanghai
# DELETE speedtest-cli and script
rm -rf speedtest-choice.sh
rm -rf /usr/local/bin/speedtest-cli
