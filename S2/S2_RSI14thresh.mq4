//+------------------------------------------------------------------+
//|                               sig gen for 4-stage plan Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- indicator buffers
double         Buffer_RSI14Thresh[];
datetime    _last_open_time;
int limit;
//-----------------macros
//-----------------inputs
input int MACD_fast_len = 35;
input bool use_ADX_confirm = True;
input int ADX_period = 40;
input int ADX_level = 25;

input int Thr_trend6 = 40;
input int Thr_trend5 = 50;
input int Thr_trend4 = 60;
input int Thr_trend3 = 65;
input int Thr_trend2 = 70;
input int Thr_trend1 = 75;
input int Thr_trend0 = 105;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_DASH, 1, clrYellow);
   SetIndexBuffer(0,Buffer_RSI14Thresh);
   SetIndexLabel(0 ,"RSI14 threshold");   
   
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
   if(rates_total<=10)
      return(0);
   _last_open_time = time[0];
   limit = rates_total - prev_calculated;
   if(prev_calculated>0)
      limit++;
//   for(int i=0; i<limit; i++)
   for(int i=limit-1; i >= 0; i--)
      Buffer_RSI14Thresh[i] = thresh(i);

//--- return value of prev_calculated for next call
      return(rates_total);
}

int thresh(int i)
{
   int trend = iCustom(Symbol(), Period(),"my_ind/S2/S2trend", MACD_fast_len,use_ADX_confirm, ADX_period,ADX_level, 0, i);

   if(trend<=-6)                  //deep down trend
      return Thr_trend6;
   if(trend<=-5)
      return Thr_trend5;
   if(trend<=-4)
      return Thr_trend4;
   if(trend<=-3)
      return Thr_trend3;
   if(trend<=-2)
      return Thr_trend2;
   if(trend<=-1)
      return Thr_trend1;
   if(trend==0)             //no trend at all
      return Thr_trend0;
   if(trend<=1)             //weak up trend             
      return 100 - Thr_trend1;
   if(trend<=2)                          
      return 100 - Thr_trend2;
   if(trend<=3)                          
      return 100 - Thr_trend3;
   if(trend<=4)                          
      return 100 - Thr_trend4;
   if(trend<=5)                          
      return 100 - Thr_trend5;
   if(trend<=6)                          
      return 100 - Thr_trend6;
   return 100;
}
