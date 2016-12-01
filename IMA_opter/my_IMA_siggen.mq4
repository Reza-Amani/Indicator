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
//-----------------macros
#define iMA_fast_len_factor 3
//-----------------inputs
input bool type_fuzzy = False;
input int iMA_short_len = 5;
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
      Buffer[i]=(type_fuzzy) ? sig_fuzzy(i) : sig_digitised(i);

//--- return value of prev_calculated for next call
      return(rates_total);
}

double sig_digitised(int bar)
{
   if(bar > limit-80)
      return 0;
   double imaFast = iMA(Symbol(), Period(), iMA_short_len, 0, MODE_LWMA, PRICE_OPEN, bar);
   double imaSlow = iMA(Symbol(), Period(), iMA_short_len * iMA_fast_len_factor, 0, MODE_SMA, PRICE_OPEN, bar);

   if( (imaFast>imaSlow) && (Open[bar]>imaFast) )
      return +1;
   else if( (imaFast<imaSlow) && (Open[bar]<imaFast) )
      return -1;
   else
      return 0;
}
double sig_fuzzy(int bar)
{
/*   if(bar > limit-80)
      return 0;
   double imaFast = iMA(Symbol(), Period(), iMA_fast_len, 0, MODE_SMA, PRICE_OPEN, bar);
   double imaSlow = iMA(Symbol(), Period(), iMA_len, 0, MODE_SMA, PRICE_OPEN, bar);

   return 1000*(imaFast-imaSlow);
*/
   return 0;
}
//+------------------------------------------------------------------+
