# verilogRisc

* Feature(已经清理的内容)
    - ifu
        + 仅能从itcm取指
        + itcm仅能存指令
        + itcm仅能由ifu访问
            * 指令需要在编译比特流时写入sram
    - lsu
        + 能从dtcm或biu访存
        + dtcm静止外部访问
        + 禁用协处理器访存