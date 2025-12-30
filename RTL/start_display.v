`timescale 1ns / 1ns

module start_display(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    output reg [15:0] pix_data
);

    // 颜色定义
    localparam [15:0] BLACK   = 16'h0000;
    localparam [15:0] WHITE   = 16'hFFFF;
    localparam [15:0] GREEN   = 16'h07E0;
    localparam [15:0] BLUE    = 16'h001F;
     // 绘制开始按钮边框 - 白色 (居中)
    localparam BUTTON_WIDTH = 140;
    localparam BUTTON_START_X = (640 - BUTTON_WIDTH) / 2;
    
    // 居中计算参数
    localparam BREAKOUT_WIDTH = 185;  // BREAKOUT总宽度
    localparam START_WIDTH = 85;      // START总宽度
    localparam BREAKOUT_START_X = (640 - BREAKOUT_WIDTH) / 2;  // BREAKOUT起始X坐标
    localparam START_START_X = (640 - START_WIDTH) / 2;        // START起始X坐标
    
    // 绘制开始界面
    always @(*) begin
        // 默认背景 - 蓝色
        pix_data = BLUE;
        
        // 绘制BREAKOUT标题 - 白色 (居中)
        // 字母B
        if ((pix_x >= BREAKOUT_START_X + 0 && pix_x < BREAKOUT_START_X + 5 && pix_y >= 100 && pix_y < 130) || // 左竖
            (pix_x >= BREAKOUT_START_X + 5 && pix_x < BREAKOUT_START_X + 15 && pix_y >= 100 && pix_y < 105) || // 上横
            (pix_x >= BREAKOUT_START_X + 5 && pix_x < BREAKOUT_START_X + 15 && pix_y >= 115 && pix_y < 120) || // 中横
            (pix_x >= BREAKOUT_START_X + 5 && pix_x < BREAKOUT_START_X + 15 && pix_y >= 125 && pix_y < 130) || // 下横
            (pix_x >= BREAKOUT_START_X + 15 && pix_x < BREAKOUT_START_X + 20 && pix_y >= 105 && pix_y < 115) || // 右上
            (pix_x >= BREAKOUT_START_X + 15 && pix_x < BREAKOUT_START_X + 20 && pix_y >= 120 && pix_y < 125)) begin // 右下
            pix_data = WHITE;
        end
        
        // 字母R
        if ((pix_x >= BREAKOUT_START_X + 25 && pix_x < BREAKOUT_START_X + 30 && pix_y >= 100 && pix_y < 130) || // 左竖
            (pix_x >= BREAKOUT_START_X + 30 && pix_x < BREAKOUT_START_X + 40 && pix_y >= 100 && pix_y < 105) || // 上横
            (pix_x >= BREAKOUT_START_X + 30 && pix_x < BREAKOUT_START_X + 40 && pix_y >= 115 && pix_y < 120) || // 中横
            (pix_x >= BREAKOUT_START_X + 40 && pix_x < BREAKOUT_START_X + 45 && pix_y >= 105 && pix_y < 115) || // 右上
            (pix_x >= BREAKOUT_START_X + 40 && pix_x < BREAKOUT_START_X + 45 && pix_y >= 120 && pix_y < 130)) begin // 右下
            pix_data = WHITE;
        end
        
        // 字母E
        if ((pix_x >= BREAKOUT_START_X + 50 && pix_x < BREAKOUT_START_X + 55 && pix_y >= 100 && pix_y < 130) || // 左竖
            (pix_x >= BREAKOUT_START_X + 55 && pix_x < BREAKOUT_START_X + 70 && pix_y >= 100 && pix_y < 105) || // 上横
            (pix_x >= BREAKOUT_START_X + 55 && pix_x < BREAKOUT_START_X + 70 && pix_y >= 115 && pix_y < 120) || // 中横
            (pix_x >= BREAKOUT_START_X + 55 && pix_x < BREAKOUT_START_X + 70 && pix_y >= 125 && pix_y < 130)) begin // 下横
            pix_data = WHITE;
        end
        
        // 字母A
        if ((pix_x >= BREAKOUT_START_X + 75 && pix_x < BREAKOUT_START_X + 80 && pix_y >= 100 && pix_y < 130) || // 左斜
            (pix_x >= BREAKOUT_START_X + 80 && pix_x < BREAKOUT_START_X + 90 && pix_y >= 100 && pix_y < 105) || // 上横
            (pix_x >= BREAKOUT_START_X + 80 && pix_x < BREAKOUT_START_X + 90 && pix_y >= 115 && pix_y < 120) || // 中横
            (pix_x >= BREAKOUT_START_X + 90 && pix_x < BREAKOUT_START_X + 95 && pix_y >= 100 && pix_y < 130)) begin // 右斜
            pix_data = WHITE;
        end
        
        // 字母K
        if ((pix_x >= BREAKOUT_START_X + 100 && pix_x < BREAKOUT_START_X + 105 && pix_y >= 100 && pix_y < 130) || // 左竖
            (pix_x >= BREAKOUT_START_X + 105 && pix_x < BREAKOUT_START_X + 115 && pix_y >= 100 && pix_y < 110) || // 上斜
            (pix_x >= BREAKOUT_START_X + 105 && pix_x < BREAKOUT_START_X + 115 && pix_y >= 120 && pix_y < 130)) begin // 下斜
            pix_data = WHITE;
        end
        
        // 字母O
        if ((pix_x >= BREAKOUT_START_X + 120 && pix_x < BREAKOUT_START_X + 125 && pix_y >= 100 && pix_y < 130) || // 左竖
            (pix_x >= BREAKOUT_START_X + 125 && pix_x < BREAKOUT_START_X + 135 && pix_y >= 100 && pix_y < 105) || // 上横
            (pix_x >= BREAKOUT_START_X + 125 && pix_x < BREAKOUT_START_X + 135 && pix_y >= 125 && pix_y < 130) || // 下横
            (pix_x >= BREAKOUT_START_X + 135 && pix_x < BREAKOUT_START_X + 140 && pix_y >= 100 && pix_y < 130)) begin // 右竖
            pix_data = WHITE;
        end
        
        // 字母U
        if ((pix_x >= BREAKOUT_START_X + 145 && pix_x < BREAKOUT_START_X + 150 && pix_y >= 100 && pix_y < 130) || // 左竖
            (pix_x >= BREAKOUT_START_X + 150 && pix_x < BREAKOUT_START_X + 160 && pix_y >= 125 && pix_y < 130) || // 下横
            (pix_x >= BREAKOUT_START_X + 160 && pix_x < BREAKOUT_START_X + 165 && pix_y >= 100 && pix_y < 130)) begin // 右竖
            pix_data = WHITE;
        end
        
        // 字母T
        if ((pix_x >= BREAKOUT_START_X + 170 && pix_x < BREAKOUT_START_X + 185 && pix_y >= 100 && pix_y < 105) || // 上横
            (pix_x >= BREAKOUT_START_X + 175 && pix_x < BREAKOUT_START_X + 180 && pix_y >= 105 && pix_y < 130)) begin // 竖
            pix_data = WHITE;
        end
        
        // 绘制START文字 - 绿色 (第二行居中)
        // 字母S
        if ((pix_x >= START_START_X + 0 && pix_x < START_START_X + 10 && pix_y >= 180 && pix_y < 185) || // 上横
            (pix_x >= START_START_X + 0 && pix_x < START_START_X + 5 && pix_y >= 185 && pix_y < 195) || // 左竖上
            (pix_x >= START_START_X + 0 && pix_x < START_START_X + 10 && pix_y >= 195 && pix_y < 200) || // 中横
            (pix_x >= START_START_X + 5 && pix_x < START_START_X + 10 && pix_y >= 200 && pix_y < 210) || // 右竖下
            (pix_x >= START_START_X + 0 && pix_x < START_START_X + 10 && pix_y >= 210 && pix_y < 215)) begin // 下横
            pix_data = GREEN;
        end
        
        // 字母T
        if ((pix_x >= START_START_X + 15 && pix_x < START_START_X + 30 && pix_y >= 180 && pix_y < 185) || // 上横
            (pix_x >= START_START_X + 20 && pix_x < START_START_X + 25 && pix_y >= 185 && pix_y < 215)) begin // 竖
            pix_data = GREEN;
        end
        
        // 字母A
        if ((pix_x >= START_START_X + 35 && pix_x < START_START_X + 40 && pix_y >= 185 && pix_y < 215) || // 左斜
            (pix_x >= START_START_X + 35 && pix_x < START_START_X + 45 && pix_y >= 180 && pix_y < 185) || // 上横
            (pix_x >= START_START_X + 35 && pix_x < START_START_X + 45 && pix_y >= 195 && pix_y < 200) || // 中横
            (pix_x >= START_START_X + 40 && pix_x < START_START_X + 45 && pix_y >= 185 && pix_y < 215)) begin // 右斜
            pix_data = GREEN;
        end
        
        // 字母R
        if ((pix_x >= START_START_X + 50 && pix_x < START_START_X + 55 && pix_y >= 180 && pix_y < 215) || // 左竖
            (pix_x >= START_START_X + 55 && pix_x < START_START_X + 60 && pix_y >= 180 && pix_y < 185) || // 上横
            (pix_x >= START_START_X + 55 && pix_x < START_START_X + 60 && pix_y >= 195 && pix_y < 200) || // 中横
            (pix_x >= START_START_X + 60 && pix_x < START_START_X + 65 && pix_y >= 185 && pix_y < 195) || // 右上斜
            (pix_x >= START_START_X + 60 && pix_x < START_START_X + 65 && pix_y >= 200 && pix_y < 215)) begin // 右下竖
            pix_data = GREEN;
        end
        
        // 字母T
        if ((pix_x >= START_START_X + 70 && pix_x < START_START_X + 85 && pix_y >= 180 && pix_y < 185) || // 上横
            (pix_x >= START_START_X + 75 && pix_x < START_START_X + 80 && pix_y >= 185 && pix_y < 215)) begin // 竖
            pix_data = GREEN;
        end
        
       
        if ((pix_x >= BUTTON_START_X && pix_x < BUTTON_START_X + BUTTON_WIDTH && pix_y >= 240 && pix_y < 242) || // 上边框
            (pix_x >= BUTTON_START_X && pix_x < BUTTON_START_X + BUTTON_WIDTH && pix_y >= 278 && pix_y < 280) || // 下边框
            (pix_x >= BUTTON_START_X && pix_x < BUTTON_START_X + 2 && pix_y >= 240 && pix_y < 280) || // 左边框
            (pix_x >= BUTTON_START_X + BUTTON_WIDTH - 2 && pix_x < BUTTON_START_X + BUTTON_WIDTH && pix_y >= 240 && pix_y < 280)) begin // 右边框
            pix_data = WHITE;
        end
    end

endmodule
