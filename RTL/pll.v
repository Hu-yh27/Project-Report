`timescale 1ns/1ps

module pll(
    input  wire sys_clk,      // 系统时钟，50MHz
    input  wire sys_rst_n,    // 复位信号，低电平有效
    output wire vga_clk       // VGA时钟，25MHz（用于驱动显示逻辑，包括END）
);

// 50MHz分频得到25MHz
reg clk_25;
always @(posedge sys_clk or negedge sys_rst_n) begin
    if (!sys_rst_n) begin
        clk_25 <= 1'b0;      // 复位时输出低电平
    end else begin
        clk_25 <= ~clk_25;   // 二分频产生25MHz时钟
    end
end

assign vga_clk = clk_25;     // 输出VGA时钟

endmodule
