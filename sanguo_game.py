import pygame
import random
import json
import os
from typing import List, Tuple, Optional

# 初始化pygame
pygame.init()

# 游戏配置
SCREEN_WIDTH = 1200
SCREEN_HEIGHT = 800
FPS = 60
TIME_LIMIT = 10  # 每题10秒
INITIAL_LIVES = 3

# 颜色定义
WHITE = (255, 255, 255)
BLACK = (0, 0, 0)
GREEN = (0, 255, 0)
RED = (255, 0, 0)
BLUE = (0, 100, 255)
YELLOW = (255, 255, 0)
ORANGE = (255, 165, 0)
PURPLE = (128, 0, 128)
GOLD = (255, 215, 0)

# 三国人物数据
CHARACTERS_DATA = {
    "刘备": {"lord": "刘备", "faction": "蜀汉", "relation": "君主"},
    "关羽": {"lord": "刘备", "faction": "蜀汉", "relation": "义兄弟"},
    "张飞": {"lord": "刘备", "faction": "蜀汉", "relation": "义兄弟"},
    "诸葛亮": {"lord": "刘备", "faction": "蜀汉", "relation": "军师"},
    "赵云": {"lord": "刘备", "faction": "蜀汉", "relation": "武将"},
    "马超": {"lord": "刘备", "faction": "蜀汉", "relation": "武将"},
    "黄忠": {"lord": "刘备", "faction": "蜀汉", "relation": "武将"},
    "魏延": {"lord": "刘备", "faction": "蜀汉", "relation": "武将"},
    "姜维": {"lord": "刘禅", "faction": "蜀汉", "relation": "武将"},
    "刘禅": {"lord": "刘禅", "faction": "蜀汉", "relation": "君主"},
    
    "曹操": {"lord": "曹操", "faction": "曹魏", "relation": "君主"},
    "曹丕": {"lord": "曹丕", "faction": "曹魏", "relation": "君主"},
    "曹植": {"lord": "曹操", "faction": "曹魏", "relation": "公子"},
    "夏侯惇": {"lord": "曹操", "faction": "曹魏", "relation": "族弟"},
    "夏侯渊": {"lord": "曹操", "faction": "曹魏", "relation": "族弟"},
    "张辽": {"lord": "曹操", "faction": "曹魏", "relation": "武将"},
    "徐晃": {"lord": "曹操", "faction": "曹魏", "relation": "武将"},
    "张郃": {"lord": "曹操", "faction": "曹魏", "relation": "武将"},
    "许褚": {"lord": "曹操", "faction": "曹魏", "relation": "护卫"},
    "典韦": {"lord": "曹操", "faction": "曹魏", "relation": "护卫"},
    "荀彧": {"lord": "曹操", "faction": "曹魏", "relation": "谋士"},
    "郭嘉": {"lord": "曹操", "faction": "曹魏", "relation": "谋士"},
    "司马懿": {"lord": "曹操", "faction": "曹魏", "relation": "谋士"},
    
    "孙权": {"lord": "孙权", "faction": "东吴", "relation": "君主"},
    "孙策": {"lord": "孙策", "faction": "东吴", "relation": "君主"},
    "周瑜": {"lord": "孙权", "faction": "东吴", "relation": "都督"},
    "鲁肃": {"lord": "孙权", "faction": "东吴", "relation": "都督"},
    "吕蒙": {"lord": "孙权", "faction": "东吴", "relation": "都督"},
    "陆逊": {"lord": "孙权", "faction": "东吴", "relation": "都督"},
    "甘宁": {"lord": "孙权", "faction": "东吴", "relation": "武将"},
    "太史慈": {"lord": "孙策", "faction": "东吴", "relation": "武将"},
    "黄盖": {"lord": "孙权", "faction": "东吴", "relation": "老将"},
    "程普": {"lord": "孙权", "faction": "东吴", "relation": "老将"},
    "韩当": {"lord": "孙权", "faction": "东吴", "relation": "老将"},
}

# 问题类型
QUESTION_TYPES = ["lord", "faction", "relation"]

class Particle:
    """连击特效粒子"""
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.vx = random.uniform(-3, 3)
        self.vy = random.uniform(-5, -1)
        self.life = 30
        self.size = random.randint(3, 8)
        self.color = random.choice([GOLD, YELLOW, ORANGE])
    
    def update(self):
        self.x += self.vx
        self.y += self.vy
        self.life -= 1
        self.vy += 0.2  # 重力
    
    def draw(self, screen):
        if self.life > 0:
            alpha = int(255 * (self.life / 30))
            color = tuple(min(255, c + 50) for c in self.color[:3])
            pygame.draw.circle(screen, color, (int(self.x), int(self.y)), self.size)

class Game:
    def __init__(self):
        self.screen = pygame.display.set_mode((SCREEN_WIDTH, SCREEN_HEIGHT))
        pygame.display.set_caption("三国演义人物关系小游戏")
        self.clock = pygame.time.Clock()
        self.font_large = pygame.font.Font(None, 72)
        self.font_medium = pygame.font.Font(None, 48)
        self.font_small = pygame.font.Font(None, 36)
        
        self.score = 0
        self.lives = INITIAL_LIVES
        self.combo = 0
        self.particles = []
        
        self.current_character = None
        self.current_question_type = None
        self.options = []
        self.correct_answer = None
        self.time_left = TIME_LIMIT
        self.game_over = False
        self.last_time = pygame.time.get_ticks()
        
        self.generate_question()
    
    def generate_question(self):
        """生成新题目"""
        self.current_character = random.choice(list(CHARACTERS_DATA.keys()))
        self.current_question_type = random.choice(QUESTION_TYPES)
        
        correct_data = CHARACTERS_DATA[self.current_character]
        self.correct_answer = correct_data[self.current_question_type]
        
        # 生成4个选项（1个正确答案 + 3个错误答案）
        all_answers = set()
        for char_data in CHARACTERS_DATA.values():
            all_answers.add(char_data[self.current_question_type])
        
        wrong_answers = list(all_answers - {self.correct_answer})
        random.shuffle(wrong_answers)
        
        self.options = [self.correct_answer] + wrong_answers[:3]
        random.shuffle(self.options)
        
        self.time_left = TIME_LIMIT
        self.last_time = pygame.time.get_ticks()
    
    def check_answer(self, selected_option):
        """检查答案"""
        if selected_option == self.correct_answer:
            self.score += 1
            self.combo += 1
            
            # 连击加成
            combo_bonus = max(0, (self.combo - 1) // 3)
            self.score += combo_bonus
            
            # 生成特效粒子
            center_x = SCREEN_WIDTH // 2
            center_y = SCREEN_HEIGHT // 2 - 50
            for _ in range(20):
                self.particles.append(Particle(center_x, center_y))
            
            self.generate_question()
            return True
        else:
            self.lives -= 1
            self.combo = 0
            if self.lives <= 0:
                self.game_over = True
            else:
                self.generate_question()
            return False
    
    def update(self):
        """更新游戏状态"""
        if self.game_over:
            return
        
        # 更新计时
        current_time = pygame.time.get_ticks()
        elapsed = (current_time - self.last_time) / 1000.0
        self.time_left -= elapsed
        self.last_time = current_time
        
        if self.time_left <= 0:
            self.lives -= 1
            self.combo = 0
            if self.lives <= 0:
                self.game_over = True
            else:
                self.generate_question()
        
        # 更新粒子
        for particle in self.particles[:]:
            particle.update()
            if particle.life <= 0:
                self.particles.remove(particle)
    
    def draw(self):
        """绘制游戏画面"""
        self.screen.fill((20, 20, 40))
        
        if self.game_over:
            self.draw_game_over()
            return
        
        # 绘制题目
        question_text = self.get_question_text()
        question_surface = self.font_large.render(question_text, True, WHITE)
        question_rect = question_surface.get_rect(center=(SCREEN_WIDTH // 2, 150))
        self.screen.blit(question_surface, question_rect)
        
        # 绘制人物名字
        char_surface = self.font_large.render(self.current_character, True, GOLD)
        char_rect = char_surface.get_rect(center=(SCREEN_WIDTH // 2, 250))
        self.screen.blit(char_surface, char_rect)
        
        # 绘制选项
        option_y = 400
        option_height = 80
        option_spacing = 20
        
        for i, option in enumerate(self.options):
            y = option_y + i * (option_height + option_spacing)
            rect = pygame.Rect(SCREEN_WIDTH // 2 - 200, y, 400, option_height)
            
            # 选项背景
            color = BLUE if i % 2 == 0 else PURPLE
            pygame.draw.rect(self.screen, color, rect)
            pygame.draw.rect(self.screen, WHITE, rect, 3)
            
            # 选项文字
            option_surface = self.font_medium.render(f"{chr(65+i)}. {option}", True, WHITE)
            option_text_rect = option_surface.get_rect(center=rect.center)
            self.screen.blit(option_surface, option_text_rect)
        
        # 绘制信息栏
        self.draw_info()
        
        # 绘制粒子特效
        for particle in self.particles:
            particle.draw(self.screen)
    
    def get_question_text(self):
        """获取问题文本"""
        type_map = {
            "lord": "主公是？",
            "faction": "所属势力是？",
            "relation": "与主公的关系是？"
        }
        return type_map[self.current_question_type]
    
    def draw_info(self):
        """绘制游戏信息"""
        # 分数
        score_text = f"分数: {self.score}"
        score_surface = self.font_medium.render(score_text, True, WHITE)
        self.screen.blit(score_surface, (20, 20))
        
        # 连击
        if self.combo > 1:
            combo_text = f"连击 x{self.combo}!"
            combo_color = GOLD if self.combo >= 5 else YELLOW
            combo_surface = self.font_medium.render(combo_text, True, combo_color)
            self.screen.blit(combo_surface, (20, 70))
        
        # 生命值
        lives_text = f"生命: {'❤️' * self.lives}"
        lives_surface = self.font_medium.render(lives_text, True, RED)
        self.screen.blit(lives_surface, (SCREEN_WIDTH - 200, 20))
        
        # 倒计时
        time_color = RED if self.time_left < 3 else YELLOW if self.time_left < 5 else GREEN
        time_text = f"时间: {max(0, int(self.time_left))}秒"
        time_surface = self.font_medium.render(time_text, True, time_color)
        time_rect = time_surface.get_rect(center=(SCREEN_WIDTH // 2, 50))
        self.screen.blit(time_surface, time_rect)
        
        # 进度条
        bar_width = 400
        bar_height = 20
        bar_x = SCREEN_WIDTH // 2 - bar_width // 2
        bar_y = 100
        progress = max(0, self.time_left / TIME_LIMIT)
        
        # 背景
        pygame.draw.rect(self.screen, (50, 50, 50), (bar_x, bar_y, bar_width, bar_height))
        # 进度
        pygame.draw.rect(self.screen, time_color, (bar_x, bar_y, int(bar_width * progress), bar_height))
        pygame.draw.rect(self.screen, WHITE, (bar_x, bar_y, bar_width, bar_height), 2)
    
    def draw_game_over(self):
        """绘制游戏结束画面"""
        # 游戏结束文字
        game_over_text = self.font_large.render("游戏结束！", True, RED)
        game_over_rect = game_over_text.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2 - 100))
        self.screen.blit(game_over_text, game_over_rect)
        
        # 最终分数
        final_score_text = f"最终分数: {self.score}"
        final_score_surface = self.font_medium.render(final_score_text, True, GOLD)
        final_score_rect = final_score_surface.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2))
        self.screen.blit(final_score_surface, final_score_rect)
        
        # 重新开始提示
        restart_text = "按 R 键重新开始"
        restart_surface = self.font_small.render(restart_text, True, WHITE)
        restart_rect = restart_surface.get_rect(center=(SCREEN_WIDTH // 2, SCREEN_HEIGHT // 2 + 100))
        self.screen.blit(restart_surface, restart_rect)
    
    def handle_click(self, pos):
        """处理鼠标点击"""
        if self.game_over:
            return
        
        option_y = 400
        option_height = 80
        option_spacing = 20
        
        for i, option in enumerate(self.options):
            y = option_y + i * (option_height + option_spacing)
            rect = pygame.Rect(SCREEN_WIDTH // 2 - 200, y, 400, option_height)
            
            if rect.collidepoint(pos):
                self.check_answer(option)
                break
    
    def handle_key(self, key):
        """处理键盘按键"""
        if self.game_over:
            if key == pygame.K_r:
                self.__init__()  # 重新开始
            return
        
        # A, B, C, D 对应选项 0, 1, 2, 3
        if key == pygame.K_a:
            self.check_answer(self.options[0])
        elif key == pygame.K_b:
            self.check_answer(self.options[1])
        elif key == pygame.K_c:
            self.check_answer(self.options[2])
        elif key == pygame.K_d:
            self.check_answer(self.options[3])
    
    def run(self):
        """运行游戏主循环"""
        running = True
        
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    if event.button == 1:  # 左键
                        self.handle_click(event.pos)
                elif event.type == pygame.KEYDOWN:
                    self.handle_key(event.key)
            
            self.update()
            self.draw()
            pygame.display.flip()
            self.clock.tick(FPS)
        
        pygame.quit()

if __name__ == "__main__":
    game = Game()
    game.run()

