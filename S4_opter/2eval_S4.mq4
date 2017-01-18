//+------------------------------------------------------------------+
//|                                                    ind Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+

#define _show_accumulated
#property copyright "Reza"
#property strict
#property indicator_separate_window
#ifdef _show_accumulated
#property indicator_buffers 3
#property indicator_plots   3
#else
#property indicator_buffers 2
#property indicator_plots   2
#endif 
//--- indicator buffers
double         Buf_raw[];
double Buf_local_ave_profit[];
double Buf_accumulated_profit[];

datetime    _last_open_time;
int limit;
//-----------------inputs
input int opt_len = 800;
input bool type_fuzzy = False;
input int iMA_short_len = 20;
input bool use_ADX_confirm = False;
input int ADX_period = 20;
input int ADX_level = 20;
input bool use_RSI_enter = False;
input int RSI_len = 10;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrBlue);
   SetIndexBuffer(0,Buf_raw);
   SetIndexLabel(0 ,"value");   
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, clrRed);
   SetIndexBuffer(1,Buf_local_ave_profit);
   SetIndexLabel(1 ,"filtered");   
#ifdef _show_accumulated
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1, clrWheat);
   SetIndexBuffer(2,Buf_accumulated_profit);
   SetIndexLabel(2 ,"accumulated");   
#endif    
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
   else
   {
      for(int i=limit-1; i >= limit-1-iMA_short_len; i--)
         Buf_raw[i]=0;
      limit-=iMA_short_len;
   }
#ifdef _show_accumulated
   Buf_accumulated_profit[limit]=0;
#endif 
   for(int i=limit-1; i >= 0; i--)
   {
      Buf_raw[i]=ind_value_in_bar(i);
      Buf_local_ave_profit[i]=iMAOnArray(Buf_raw, 0,opt_len,i,MODE_LWMA,0)*10;
#ifdef _show_accumulated
      Buf_accumulated_profit[i] = Buf_accumulated_profit[i+1]+Buf_raw[i];
#endif 
   }
//--- return value of prev_calculated for next call
      return(rates_total);
}

double ind_value_in_bar(int bar)
{
   double ind_sig = iCustom(Symbol(), Period(), "1siggen_S4", type_fuzzy, iMA_short_len,use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 0, bar);

   return 100 * ind_sig/1 *(Close[bar]-Close[bar+1])/Close[bar];
}
//+------------------------------------------------------------------+
