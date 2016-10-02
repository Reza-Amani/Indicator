//+------------------------------------------------------------------+
//|                                                        judge.mq4 |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- indicator buffers
double         Buffer[];
datetime    _last_open_time;
int limit;
//-----------------inputs
input int iMA_weight = 10;
input bool iMA_use = True;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrBlueViolet);
   SetIndexBuffer(0,Buffer);
   SetIndexLabel(0 ,"level");   
   
   _last_open_time=0;
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---

   if( time[0]==_last_open_time)
      return(0);  //Important: executes only on first tick of each bar.
   _last_open_time = time[0];
   limit = rates_total - prev_calculated;
   if(prev_calculated>0)
      limit++;
   if(iMA_use)
      ima(close);
//      Label1Buffer[i] = iRSI(NULL, 0, 14, PRICE_CLOSE,i  );

//--- return value of prev_calculated for next call
   return(rates_total);
}

void ima(const double &close[])
{
   for(int i=1; i < limit-50; i++)
   {
      double ima10 = iMA(Symbol(), Period(), 10, 0, MODE_SMA, PRICE_TYPICAL, i);
      double ima20 = iMA(Symbol(), Period(), 20, 0, MODE_SMA, PRICE_TYPICAL, i);
      double ima50 = iMA(Symbol(), Period(), 50, 0, MODE_SMA, PRICE_TYPICAL, i);
      int ima_sum=0;
      if(ima20>ima50)
         ima_sum++;
      else
         ima_sum--;
      if(ima10>ima20)
         ima_sum++;
      else
         ima_sum--;
      if(close[i]>ima20)
         ima_sum++;
      else
         ima_sum--;
      Buffer[i] = ima_sum * iMA_weight + (double)ima_sum/10+0.5;
   }
}
//+------------------------------------------------------------------+
