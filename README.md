# Speedtest-cli-CN-Auto

一个适用于Debian和Ubuntu的、以中国境内测速点为测速目标的测速脚本。

本脚本基于[speedtest.net](http://www.speedtest.net) 和 [speedtest-cli](https://github.com/sivel/speedtest-cli) 写成。

### 使用方法
* 一条命令，快速测速：

``
wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh {shanghai|telecom|unicom|mobile|all}
``

### 参数说明(可直接执行附在说明后的代码)：
* shanghai：只测试到上海的电信、移动、联通的测速点``wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh shanghai``
* telecom：只测试到全国各地的电信测速点``wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh telecom``
* unicom：只测试到全国各地的联通测速点``wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh unicom``
* mobile：只测试到全国各地的移动测速点``wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh mobile``
* all：测目前speedtest.net大部分的中国国内测速点``wget --no-check-certificate https://raw.githubusercontent.com/singhigh/Speedtest-cli-CN-Auto/master/one-click-speedtest.sh && bash one-click-speedtest.sh all``


