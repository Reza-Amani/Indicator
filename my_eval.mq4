//+------------------------------------------------------------------+
//|                                                    ind Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2
//--- indicator buffers
double         Buf_raw[];
double Buf_local_ave_profit[];

datetime    _last_open_time;
int limit;
//-----------------inputs
input bool type_fuzzy = True;
input int iMA_len = 10;
input int opt_len = 200;
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
      for(int i=limit-1; i >= limit-1-iMA_len; i--)
         Buf_raw[i]=0;
      limit-=iMA_len;
   }
   for(int i=limit-1; i >= 0; i--)
   {
      Buf_raw[i]=ind_value_in_bar(i);
      Buf_local_ave_profit[i]=iMAOnArray(Buf_raw, 0,opt_len,i,MODE_SMA,0);
   }
//--- return value of prev_calculated for next call
      return(rates_total);
}

double ind_value_in_bar(int bar)
{
   double ind_sig = iCustom(Symbol(), Period(), "my_sig_gen", type_fuzzy, iMA_len, 0, bar);

   return 1 * ind_sig/1 *(Close[bar]-Close[bar+1])/Close[bar];
}
//+------------------------------------------------------------------+
