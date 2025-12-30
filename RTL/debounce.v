`timescale 1ns / 1ns

module debounce(
    input wire clk,        // 25MHz时钟
    input wire btn_in,     // 原始按钮输入
    output reg btn_out     // 消抖后的按钮输出
);
    
    parameter DEBOUNCE_COUNT = 25000; // 约1ms消抖时间 (25MHz时钟)
    
    reg [14:0] count;
    reg btn_prev;
    
    always @(posedge clk) begin
        btn_prev <= btn_in;
        
        if (btn_prev != btn_in) begin
            count <= 0;
        end else if (count < DEBOUNCE_COUNT) begin
            count <= count + 1;
        end else begin
            btn_out <= btn_prev;
        end
    end

endmodule
