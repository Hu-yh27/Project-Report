`timescale 1ns / 1ns

module breakout_game(
    input wire vga_clk,
    input wire sys_rst_n,
    input wire [9:0] pix_x,
    input wire [9:0] pix_y,
    input wire left_btn,     // S键：左移
    input wire right_btn,    // D键：右移
    input wire game_active,  // 游戏激活
    output reg [15:0] pix_data,
    output reg game_win,
    output reg game_lose
);

    // 游戏参数
    parameter PADDLE_WIDTH = 100;
    parameter PADDLE_HEIGHT = 15;
    parameter BALL_SIZE = 12;
    parameter BRICK_ROWS = 3;
    parameter BRICK_COLS = 8;
    parameter BRICK_WIDTH = 70;
    parameter BRICK_HEIGHT = 20;
    parameter BRICK_GAP = 5;

    localparam SCREEN_WIDTH = 10'd640;
    localparam SCREEN_HEIGHT = 10'd480;

    // 游戏元素位置
    reg [9:0] paddle_x;
    reg [9:0] paddle_y;
    reg [9:0] ball_x;
    reg [9:0] ball_y;
    reg signed [9:0] ball_dx;
    reg signed [9:0] ball_ddy;
    reg [BRICK_ROWS*BRICK_COLS-1:0] bricks;
    reg [2:0] lives;

    // 计数器
    reg [19:0] frame_counter;
    reg [19:0] move_counter;

    // 循环变量
    integer i, j;

    // 颜色定义
    localparam [15:0] BLACK   = 16'h0000;
    localparam [15:0] WHITE   = 16'hFFFF;
    localparam [15:0] RED     = 16'hF800;
    localparam [15:0] GREEN   = 16'h07E0;
    localparam [15:0] BLUE    = 16'h001F;
    localparam [15:0] YELLOW  = 16'hFFE0;
    localparam [15:0] ORANGE  = 16'hFC00;

    // 临时变量
    reg [9:0] hit_pos;
    reg [9:0] brick_left, brick_right, brick_top, brick_bottom;
    reg [9:0] ball_center_x, ball_center_y;
    reg [9:0] brick_center_x, brick_center_y;

    // 内部预测
    reg [9:0] next_ball_x, next_ball_y;
    reg boundary_collision, paddle_collision, brick_collision;

    // 标志：是否正在处理死亡（防连扣）
    reg death_processing;

    // ========================
    // 初始化逻辑
    // ========================
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            lives <= 3;
            bricks <= {BRICK_ROWS*BRICK_COLS{1'b1}};
            paddle_x <= 270;           // (640-100)/2
            paddle_y <= 420;           // 480 - 60
            ball_x <= 314;             // 初始中心
            ball_y <= 294;
            ball_dx <= 2;
            ball_ddy <= -2;
            game_win <= 0;
            game_lose <= 0;
            frame_counter <= 0;
            move_counter <= 0;
            death_processing <= 0;
        end else if (!game_active && !(game_win || game_lose)) begin
            // 外部重置游戏
            lives <= 3;
            bricks <= {BRICK_ROWS*BRICK_COLS{1'b1}};
            paddle_x <= 270;
            paddle_y <= 420;
            ball_x <= 314;
            ball_y <= 294;
            ball_dx <= 2;
            ball_ddy <= -2;
            game_win <= 0;
            game_lose <= 0;
            death_processing <= 0;
        end
    end

    // ========================
    // 挡板控制：S 左，D 右
    // ========================
    always @(posedge vga_clk) begin
        move_counter <= move_counter + 1;

        if (game_active && move_counter[12:0] == 0 && !game_win && !game_lose) begin
            if (!left_btn && right_btn) begin
                if (paddle_x > 0)
                    paddle_x <= paddle_x - 1;
            end else if (left_btn && !right_btn) begin
                if (paddle_x < SCREEN_WIDTH - PADDLE_WIDTH)
                    paddle_x <= paddle_x + 1;
            end
        end
    end

    // ========================
    // 球运动逻辑
    // ========================
    always @(posedge vga_clk) begin
        frame_counter <= frame_counter + 1;

        if (game_active && frame_counter[14:0] == 0 && !game_win && !game_lose) begin
            boundary_collision <= 0;
            paddle_collision <= 0;
            brick_collision <= 0;

            next_ball_x = ball_x + ball_dx;
            next_ball_y = ball_y + ball_ddy;

            // ========================
            // 1. 四边碰撞检测
            // ========================

            // --- 上边界 ---
            if (next_ball_y < 0) begin
                ball_ddy <= -ball_ddy;
                ball_y <= 0;
                boundary_collision <= 1;
            end
            // --- 下边界：唯一扣命条件 ---
            else if (next_ball_y + BALL_SIZE >= SCREEN_HEIGHT) begin
                if (!death_processing) begin  // 防止重复触发
                    if (lives > 1) begin
                        lives <= lives - 1;
                        // 重置球和挡板
                        ball_x <= 314;
                        ball_y <= 294;
                        ball_dx <= 2;
                        ball_ddy <= -2;
                        paddle_x <= 270;
                        death_processing <= 1;  // 锁定，防止多帧重复触发
                    end else begin
                        lives <= 0;
                        game_lose <= 1;
                    end
                    boundary_collision <= 1;
                end
            end
            // --- 左边界 ---
            else if (next_ball_x < 0) begin
                ball_dx <= -ball_dx;
                ball_x <= 0;
                boundary_collision <= 1;
            end
            // --- 右边界 ---
            else if (next_ball_x + BALL_SIZE >= SCREEN_WIDTH) begin
                ball_dx <= -ball_dx;
                ball_x <= SCREEN_WIDTH - BALL_SIZE;
                boundary_collision <= 1;
            end

            // ========================
            // 2. 挡板碰撞
            // ========================
            if (!boundary_collision) begin
                if (next_ball_y + BALL_SIZE >= paddle_y &&
                    next_ball_y <= paddle_y + PADDLE_HEIGHT &&
                    next_ball_x + BALL_SIZE >= paddle_x &&
                    next_ball_x <= paddle_x + PADDLE_WIDTH &&
                    ball_ddy > 0) begin

                    hit_pos = (next_ball_x + BALL_SIZE/2) - paddle_x;

                    if (hit_pos < PADDLE_WIDTH/4)
                        ball_dx <= -2;
                    else if (hit_pos < PADDLE_WIDTH/2)
                        ball_dx <= -1;
                    else if (hit_pos < 3*PADDLE_WIDTH/4)
                        ball_dx <= 1;
                    else
                        ball_dx <= 2;

                    ball_ddy <= -2;
                    ball_y <= paddle_y - BALL_SIZE;
                    paddle_collision <= 1;
                end
            end

            // ========================
            // 3. 砖块碰撞
            // ========================
            if (!boundary_collision && !paddle_collision) begin
                for (i = 0; i < BRICK_ROWS; i = i + 1) begin
                    for (j = 0; j < BRICK_COLS; j = j + 1) begin
                        if (bricks[i*BRICK_COLS + j]) begin
                            brick_left   = j*(BRICK_WIDTH + BRICK_GAP) + 40;
                            brick_right  = brick_left + BRICK_WIDTH;
                            brick_top    = i*(BRICK_HEIGHT + BRICK_GAP) + 60;
                            brick_bottom = brick_top + BRICK_HEIGHT;

                            if (next_ball_x + BALL_SIZE > brick_left &&
                                next_ball_x < brick_right &&
                                next_ball_y + BALL_SIZE > brick_top &&
                                next_ball_y < brick_bottom) begin

                                bricks[i*BRICK_COLS + j] <= 0;  // 销毁砖块

                                // 简单反弹判断
                                ball_center_y = ball_y + BALL_SIZE/2;
                                if (ball_center_y < brick_top + BRICK_HEIGHT/3 ||
                                    ball_center_y > brick_bottom - BRICK_HEIGHT/3) begin
                                    ball_ddy <= -ball_ddy;
                                end else begin
                                    ball_dx <= -ball_dx;
                                end

                                // 限速
                                if (ball_dx > 3) ball_dx <= 3;
                                if (ball_dx < -3) ball_dx <= -3;
                                if (ball_ddy > 3) ball_ddy <= 3;
                                if (ball_ddy < -3) ball_ddy <= -3;

                                brick_collision <= 1;
                            end
                        end
                    end
                end
            end

            // ========================
            // 4. 更新球位置
            // ========================
            if (!boundary_collision && !paddle_collision && !brick_collision) begin
                ball_x <= next_ball_x;
                ball_y <= next_ball_y;
            end

            // ========================
            // 5. 胜利检查
            // ========================
            if (bricks == 0) begin
                game_win <= 1;
            end
        end

        // ========================
        // 退出死亡处理状态（安全后解锁）
        // ========================
        if (frame_counter[14:0] == 1) begin
            // 在下一主周期开始时释放 death_processing
            death_processing <= 0;
        end
    end

    // ========================
    // 图形渲染逻辑
    // ========================
    always @(*) begin
        pix_data = BLACK;

        if (game_active) begin
            // 绘制砖块
            for (i = 0; i < BRICK_ROWS; i = i + 1) begin
                for (j = 0; j < BRICK_COLS; j = j + 1) begin
                    if (bricks[i*BRICK_COLS + j]) begin
                        if (pix_x >= j*(BRICK_WIDTH + BRICK_GAP) + 40 &&
                            pix_x < j*(BRICK_WIDTH + BRICK_GAP) + BRICK_WIDTH + 40 &&
                            pix_y >= i*(BRICK_HEIGHT + BRICK_GAP) + 60 &&
                            pix_y < i*(BRICK_HEIGHT + BRICK_GAP) + BRICK_HEIGHT + 60) begin

                            case (i)
                                0: pix_data = RED;
                                1: pix_data = ORANGE;
                                2: pix_data = YELLOW;
                                default: pix_data = WHITE;
                            endcase
                        end
                    end
                end
            end

            // 绘制球
            if (pix_x >= ball_x && pix_x < ball_x + BALL_SIZE &&
                pix_y >= ball_y && pix_y < ball_y + BALL_SIZE) begin
                pix_data = WHITE;
            end

            // 绘制挡板
            if (pix_x >= paddle_x && pix_x < paddle_x + PADDLE_WIDTH &&
                pix_y >= paddle_y && pix_y < paddle_y + PADDLE_HEIGHT) begin
                pix_data = GREEN;
            end

            // 绘制生命值（红色小方块）
            for (i = 0; i < 3; i = i + 1) begin
                if (i < lives) begin
                    if (pix_x >= 20 + i*35 && pix_x < 30 + i*35 &&
                        pix_y >= 20 && pix_y < 30) begin
                        pix_data = RED;
                    end
                end
            end
        end
    end

endmodule
