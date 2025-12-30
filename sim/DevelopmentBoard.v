`timescale 1ns / 1ns

module DevelopmentBoard(
    input wire clk, //50MHz
    input wire reset, B2, B3, B4, B5,
    output wire h_sync, v_sync,
    output wire [15:0] rgb,
    output wire led1, led2, led3, led4, led5
);

    // 生成25MHz时钟
    reg clk_25m;
    always @(posedge clk) begin
        clk_25m <= ~clk_25m;
    end

    // 消抖后的按钮信号
    wire left_btn_db, right_btn_db, start_btn_db, pause_btn_db;
    
    // 实例化消抖模块，使用clk_25m
    debounce debounce_left(
        .clk(clk_25m),
        .btn_in(B2),
        .btn_out(left_btn_db)
    );
    
    debounce debounce_right(
        .clk(clk_25m),
        .btn_in(B3),
        .btn_out(right_btn_db)
    );
    
    debounce debounce_start(
        .clk(clk_25m),
        .btn_in(B4),
        .btn_out(start_btn_db)
    );
    
    debounce debounce_pause(
        .clk(clk_25m),
        .btn_in(B5),
        .btn_out(pause_btn_db)
    );

    // 状态机和游戏实例，使用clk_25m作为vga_clk
    vga_state_machine state_machine_inst(
        .vga_clk(clk_25m),
        .sys_rst_n(reset),
        .button_press(pause_btn_db),
        .left_btn(left_btn_db),
        .right_btn(right_btn_db),
        .start_btn(start_btn_db),
        .hsync(h_sync),
        .vsync(v_sync),
        .rgb(rgb),
        .state_leds({led1, led2, led3})
    );

    // 简单的LED指示
    assign led4 = 1'b0;   // LED4暂时不用
    assign led5 = 1'b0;   // LED5暂时不用

endmodule