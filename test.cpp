#include <iostream>

using namespace std;
int main(int argc, char const *argv[])
{
	//游戏初始化
	GameInit();
	while (1)
	{
		//玩家控制
		InputSystem.Update();
		//游戏逻辑更新
		GameLogic.Update();
		//游戏画面更新
		GraphicsRender.Update();
	}
}

this.timer1.Interval = 1000;//设置定时执行的时间大小
this.timer1.Enabled = true;
this.timer1.Tick += new EventHandler(timer1_Tick);//添加事件
this.timer1.Start();
int i=0;
void timer1_Tick(object sender, EventArgs e)//就是个事件delegate的格式
{            
    if (i == 5000)
        timer1.Enabled = false;
    MessageBox.Show("test5");
    i++;
}