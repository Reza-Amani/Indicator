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
double         Buf_branch_1[];
double         Buf_branch_2[];

datetime    _last_open_time;
int limit;
//-----------------inputs
input bool type_fuzzy = True;
input int iMA_len_1 =20;
input int iMA_len_2 =20;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrBrown);
   SetIndexBuffer(0,Buf_branch_1);
   SetIndexLabel(0 ,"branch 1");   
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrRed);
   SetIndexBuffer(1,Buf_branch_2);
   SetIndexLabel(1 ,"branch 2");   
   
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
      limit-=20;
   }
   for(int i=limit-1; i >= 0; i--)
   {
      Buf_branch_1[i]=iCustom(Symbol(), Period(), "my_eval", type_fuzzy, iMA_len_1, 0, i);
      Buf_branch_2[i]=iCustom(Symbol(), Period(), "my_eval", type_fuzzy, iMA_len_2, 0, i);
      //Buf_accomulated[i]=//;iMAOnArray(Buf_raw, 0,10,0,MODE_SMA,0);
//      Buf_accomulated[i]=Buf_accomulated[i+1]+Buf_raw[i];
   }
//--- return value of prev_calculated for next call
      return(rates_total);
}

//+------------------------------------------------------------------+
