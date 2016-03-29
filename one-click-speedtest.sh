# ONE CLICK ALL
# USAGE :wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh {shanghai|telecom|unicom|mobile|all}

dir=`basename $0`
if [ $1 == "shanghai" ];then
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
  rm -rf one-click-speedtest.sh
elif [ $1 == "telecom" ];then
  # GET speedtest-cli
  wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py 
  chmod a+rx speedtest_cli.py 
  sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli 
  sudo chown root:root /usr/local/bin/speedtest-cli 
  # GET speedtest-script
  wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest-choice.sh 
  # RUN script
  bash speedtest-choice.sh telecom
  # DELETE speedtest-cli and script
  rm -rf speedtest-choice.sh
  rm -rf /usr/local/bin/speedtest-cli
  rm -rf one-click-speedtest.sh
elif [ $1 == "unicom" ];then
  # GET speedtest-cli
  wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py 
  chmod a+rx speedtest_cli.py 
  sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli 
  sudo chown root:root /usr/local/bin/speedtest-cli 
  # GET speedtest-script
  wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest-choice.sh 
  # RUN script
  bash speedtest-choice.sh unicom
  # DELETE speedtest-cli and script
  rm -rf speedtest-choice.sh
  rm -rf /usr/local/bin/speedtest-cli
  rm -rf one-click-speedtest.sh
elif [ $1 == "mobile" ];then
  # GET speedtest-cli
  wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py 
  chmod a+rx speedtest_cli.py 
  sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli 
  sudo chown root:root /usr/local/bin/speedtest-cli 
  # GET speedtest-script
  wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest-choice.sh 
  # RUN script
  bash speedtest-choice.sh mobile
  # DELETE speedtest-cli and script
  rm -rf speedtest-choice.sh
  rm -rf /usr/local/bin/speedtest-cli
  rm -rf one-click-speedtest.sh
elif [ $1 == "all" ];then
  # GET speedtest-cli
  wget https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py 
  chmod a+rx speedtest_cli.py 
  sudo mv speedtest_cli.py /usr/local/bin/speedtest-cli 
  sudo chown root:root /usr/local/bin/speedtest-cli 
  # GET speedtest-script
  wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/speedtest-choice.sh 
  # RUN script
  bash speedtest-choice.sh all
  # DELETE speedtest-cli and script
  rm -rf speedtest-choice.sh
  rm -rf /usr/local/bin/speedtest-cli
  rm -rf one-click-speedtest.sh
else
   echo "$dir.sh {shanghai|telecom|unicom|mobile|all}"
fi
