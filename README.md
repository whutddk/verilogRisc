# verilogRisc

* Fork 蜂鸟E203，做一些个人的修改
* 以此学习熟悉处理器结构

------------------------


* Evaluate
    - 用于YJ432上验证xilinx AXI-EMC ip
    - 优化取指令，ITCM改为32bit，强制取指32bit对齐，从ITCM和DM取指
    - DM从memory改换到BIU
    - memory只剩下AXI-EMC
    - MAC指令集已删除
    - 主频提升至50MHZ
    - 裁剪外设
    - 通过测试

------------

* Analysis
    - Feature(已经清理的内容，部分从验证来看，是有问题的)
    - 删除16位指令，ITCM使用32位，以此可以排除大量取指的case
    - 删除C指令集，因为编译系统限制，必须一同删除A指令集，当前为IM指令集
    - ifu
        + 仅能从itcm取指
        + itcm仅能存指令
        + itcm仅能由ifu访问
            * 指令需要在编译比特流时写入sram
    - lsu
        + 能从dtcm或biu访存
        + dtcm静止外部访问
        + 禁用协处理器访存

