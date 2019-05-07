# verilogRisc



* Feature(已经清理的内容)
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