//+------------------------------------------------------------------+
//|                                        sig gen for ind Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- indicator buffers
double         Buffer[];
datetime    _last_open_time;
int limit;
//-----------------inputs
input bool iMA_use = False;
input int iMA_weight = 10;
input int ima_base = 10;
input bool CMO_use = True;
input int CMO_weight = 10;
input int CMO_len = 14;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrBlueViolet);
   SetIndexBuffer(0,Buffer);
   SetIndexLabel(0 ,"desirability signal");   
   
   _last_open_time=0;
   limit = 0;
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
   _last_open_time = time[0];
   limit = rates_total - prev_calculated;
   if(prev_calculated>0)
      limit++;
   for(int i=limit-1; i >= 0; i--)
      Buffer[i]=use_ima(i);

//--- return value of prev_calculated for next call
      return(rates_total);
}

double use_ima(int bar)
{
   double ima10 = iMA(Symbol(), Period(), 10, 0, MODE_SMA, PRICE_TYPICAL, bar);
   double ima20 = iMA(Symbol(), Period(), 20, 0, MODE_SMA, PRICE_TYPICAL, bar);

   if(ima10>ima20)
      return 1;
   else
      return 0;
}
//+------------------------------------------------------------------+
