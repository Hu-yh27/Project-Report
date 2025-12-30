`timescale 1ns / 1ns

module lose_display(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    output reg [15:0] pix_data
);

    // 颜色定义
    localparam [15:0] RED     = 16'hF800;
    localparam [15:0] WHITE   = 16'hFFFF;
    localparam [15:0] BLACK   = 16'h0000;
    
    always @(*) begin
        // 默认背景 - 红色
        pix_data = RED;
        
        // 绘制"TRY AGAIN"文字 - 白色
        // 字母T
        if ((pix_x >= 240 && pix_x < 255 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 245 && pix_x < 250 && pix_y >= 205 && pix_y < 230)) begin // 竖
            pix_data = WHITE;
        end
        
        // 字母R
        if ((pix_x >= 260 && pix_x < 265 && pix_y >= 200 && pix_y < 230) || // 左竖
            (pix_x >= 265 && pix_x < 270 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 265 && pix_x < 270 && pix_y >= 210 && pix_y < 215) || // 中横
            (pix_x >= 270 && pix_x < 275 && pix_y >= 205 && pix_y < 210) || // 右上斜
            (pix_x >= 270 && pix_x < 275 && pix_y >= 215 && pix_y < 230)) begin // 右下竖
            pix_data = WHITE;
        end
        
        // 字母Y
        if ((pix_x >= 280 && pix_x < 285 && pix_y >= 200 && pix_y < 215) || // 左上
            (pix_x >= 285 && pix_x < 290 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 290 && pix_x < 295 && pix_y >= 200 && pix_y < 215) || // 右上
            (pix_x >= 285 && pix_x < 290 && pix_y >= 215 && pix_y < 230)) begin // 下竖
            pix_data = WHITE;
        end
        
        // 字母A
        if ((pix_x >= 310 && pix_x < 315 && pix_y >= 205 && pix_y < 230) || // 左斜
            (pix_x >= 310 && pix_x < 320 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 310 && pix_x < 320 && pix_y >= 215 && pix_y < 220) || // 中横
            (pix_x >= 315 && pix_x < 320 && pix_y >= 205 && pix_y < 230)) begin // 右斜
            pix_data = WHITE;
        end
        
        // 字母G
        if ((pix_x >= 325 && pix_x < 330 && pix_y >= 200 && pix_y < 230) || // 左竖
            (pix_x >= 330 && pix_x < 340 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 330 && pix_x < 340 && pix_y >= 225 && pix_y < 230) || // 下横
            (pix_x >= 335 && pix_x < 340 && pix_y >= 215 && pix_y < 225) || // 右竖下
            (pix_x >= 330 && pix_x < 335 && pix_y >= 215 && pix_y < 220)) begin // 中横右
            pix_data = WHITE;
        end
        
        // 字母A
        if ((pix_x >= 345 && pix_x < 350 && pix_y >= 205 && pix_y < 230) || // 左斜
            (pix_x >= 345 && pix_x < 355 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 345 && pix_x < 355 && pix_y >= 215 && pix_y < 220) || // 中横
            (pix_x >= 350 && pix_x < 355 && pix_y >= 205 && pix_y < 230)) begin // 右斜
            pix_data = WHITE;
        end
        
        // 字母I
        if ((pix_x >= 360 && pix_x < 370 && pix_y >= 200 && pix_y < 205) || // 上横
            (pix_x >= 364 && pix_x < 366 && pix_y >= 205 && pix_y < 225) || // 竖
            (pix_x >= 360 && pix_x < 370 && pix_y >= 225 && pix_y < 230)) begin // 下横
            pix_data = WHITE;
        end
        
        // 字母N
        if ((pix_x >= 375 && pix_x < 380 && pix_y >= 200 && pix_y < 230) || // 左竖
            (pix_x >= 380 && pix_x < 390 && pix_y >= 205 && pix_y < 210) || // 斜线
            (pix_x >= 390 && pix_x < 395 && pix_y >= 200 && pix_y < 230)) begin // 右竖
            pix_data = WHITE;
        end
        
        // 绘制边框 - 黑色
        if ((pix_x >= 230 && pix_x < 410 && pix_y >= 180 && pix_y < 182) || // 上边框
            (pix_x >= 230 && pix_x < 410 && pix_y >= 248 && pix_y < 250) || // 下边框
            (pix_x >= 230 && pix_x < 232 && pix_y >= 180 && pix_y < 250) || // 左边框
            (pix_x >= 408 && pix_x < 410 && pix_y >= 180 && pix_y < 250)) begin // 右边框
            pix_data = BLACK;
        end
    end

endmodule
