`timescale 1ns/1ps

module vga_state_machine(
    input wire vga_clk,        // 25MHz时钟
    input wire sys_rst_n,
    input wire button_press,      // 状态切换按钮
    input wire left_btn,          // 左移按钮
    input wire right_btn,         // 右移按钮
    input wire start_btn,         // 开始游戏按钮
    output wire hsync,
    output wire vsync,
    output wire [15:0] rgb,
    output reg [2:0] state_leds   // 状态指示LED
);

    // 状态定义
    parameter STATE_START = 2'b00;    // 开始界面
    parameter STATE_PLAY = 2'b01;     // 游戏状态
    parameter STATE_WIN = 2'b10;      // 胜利界面
    parameter STATE_LOSE = 2'b11;     // 失败界面
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    // 内部信号
    wire [9:0] pix_x;
    wire [9:0] pix_y;
    wire [15:0] start_data;
    wire [15:0] play_data;
    wire [15:0] win_data;
    wire [15:0] lose_data;
    wire [15:0] selected_data;
    wire game_win;      // 游戏胜利信号
    wire game_lose;     // 游戏失败信号
    
    // 按钮检测
    reg [19:0] debounce_counter;
    reg start_btn_debounced;
    reg start_btn_prev;
    wire start_btn_rising;
    
    // VGA控制器
    vga_ctrl vga_ctrl_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_data(selected_data),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .hsync(hsync),
        .vsync(vsync),
        .rgb(rgb)
    );
    
    // 开始按钮消抖
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            debounce_counter <= 0;
            start_btn_debounced <= 1'b1;
            start_btn_prev <= 1'b1;
        end else begin
            start_btn_prev <= start_btn_debounced;
            
            if (start_btn != start_btn_debounced) begin
                if (debounce_counter < 20'd100000) begin  // 约4ms消抖
                    debounce_counter <= debounce_counter + 1;
                end else begin
                    start_btn_debounced <= start_btn;
                    debounce_counter <= 0;
                end
            end else begin
                debounce_counter <= 0;
            end
        end
    end
    
    assign start_btn_rising = (start_btn_debounced == 1'b0) && (start_btn_prev == 1'b1);
    
    // 状态寄存器
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            current_state <= STATE_START;
        end else begin
            current_state <= next_state;
        end
    end
    
    // 下一状态逻辑
    always @(*) begin
        next_state = current_state; // 默认保持当前状态
        
        case (current_state)
            STATE_START: begin
                // 开始界面，按开始按钮进入游戏
                if (start_btn_rising) begin
                    next_state = STATE_PLAY;
                end
            end
            
            STATE_PLAY: begin
                // 游戏进行中
                if (game_win) begin
                    next_state = STATE_WIN;
                end else if (game_lose) begin
                    next_state = STATE_LOSE;
                end
            end
            
            STATE_WIN: begin
                // 胜利界面，按开始按钮回到开始
                if (start_btn_rising) begin
                    next_state = STATE_START;
                end
            end
            
            STATE_LOSE: begin
                // 失败界面，按开始按钮回到开始
                if (start_btn_rising) begin
                    next_state = STATE_START;
                end
            end
            
            default: next_state = STATE_START;
        endcase
    end
    
    // 开始界面模块
    start_display start_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(start_data)
    );
    
    // 小球打砖块游戏模块
    breakout_game breakout_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .left_btn(left_btn),
        .right_btn(right_btn),
        .game_active(current_state == STATE_PLAY),
        .pix_data(play_data),
        .game_win(game_win),
        .game_lose(game_lose)
    );
    
    // 胜利界面模块  
    win_display win_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(win_data)
    );
    
    // 失败界面模块
    lose_display lose_inst (
        .vga_clk(vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x(pix_x),
        .pix_y(pix_y),
        .pix_data(lose_data)
    );
    
    // 输出选择
    assign selected_data = (current_state == STATE_START) ? start_data :
                          (current_state == STATE_PLAY) ? play_data :
                          (current_state == STATE_WIN) ? win_data :
                          (current_state == STATE_LOSE) ? lose_data :
                          16'h0000;
    
    // 状态LED指示
    always @(*) begin
        case (current_state)
            STATE_START: state_leds = 3'b001;  // LED1亮
            STATE_PLAY:  state_leds = 3'b010;  // LED2亮
            STATE_WIN:   state_leds = 3'b100;  // LED3亮
            STATE_LOSE:  state_leds = 3'b101;  // LED1和LED3亮
            default:     state_leds = 3'b001;
        endcase
    end

endmodule