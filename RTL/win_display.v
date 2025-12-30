`timescale 1ns / 1ns

module win_display(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    output reg [15:0] pix_data
);

    // 颜色定义
    localparam [15:0] GREEN   = 16'h07E0;
    localparam [15:0] WHITE   = 16'hFFFF;
    localparam [15:0] YELLOW  = 16'hFFE0;
    
    always @(*) begin
        // 默认背景 - 绿色
        pix_data = GREEN;
        
        // 绘制"WIN!"文字 - 白色
        // 字母W
        if ((pix_x >= 260 && pix_x < 265 && pix_y >= 200 && pix_y < 230) || // 左竖
            (pix_x >= 265 && pix_x < 275 && pix_y >= 225 && pix_y < 230) || // 下V左
            (pix_x >= 275 && pix_x < 285 && pix_y >= 215 && pix_y < 225) || // 中V
            (pix_x >= 285 && pix_x < 295 && pix_y >= 225 && pix_y < 230) || // 下V右
            (pix_x >= 295 && pix_x < 300 && pix_y >= 200 && pix_y < 230)) begin // 右竖
            pix_data = WHITE;
        end
        
        // 字母I
        if ((pix_x >= 310 && pix_x < 320 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 314 && pix_x < 316 && pix_y >= 205 && pix_y < 225) || // 竖
            (pix_x >= 310 && pix_x < 320 && pix_y >= 225 && pix_y < 230)) begin // 下横
            pix_data = WHITE;
        end
        
        // 字母N
        if ((pix_x >= 330 && pix_x < 335 && pix_y >= 200 && pix_y < 230) || // 左竖
            (pix_x >= 335 && pix_x < 345 && pix_y >= 205 && pix_y < 210) || // 斜线
            (pix_x >= 345 && pix_x < 350 && pix_y >= 200 && pix_y < 230)) begin // 右竖
            pix_data = WHITE;
        end
        
        // 感叹号!
        if ((pix_x >= 360 && pix_x < 365 && pix_y >= 200 && pix_y < 220) || // 竖线
            (pix_x >= 360 && pix_x < 365 && pix_y >= 225 && pix_y < 230)) begin // 点
            pix_data = WHITE;
        end
        
        // 绘制庆祝边框 - 黄色
        if ((pix_x >= 240 && pix_x < 400 && pix_y >= 180 && pix_y < 182) || // 上边框
            (pix_x >= 240 && pix_x < 400 && pix_y >= 248 && pix_y < 250) || // 下边框
            (pix_x >= 240 && pix_x < 242 && pix_y >= 180 && pix_y < 250) || // 左边框
            (pix_x >= 398 && pix_x < 400 && pix_y >= 180 && pix_y < 250)) begin // 右边框
            pix_data = YELLOW;
        end
    end

endmodule
