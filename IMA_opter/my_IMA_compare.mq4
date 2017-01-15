//+------------------------------------------------------------------+
//|                                                    ind Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_buffers 5
#property indicator_plots   5
//--- indicator buffers
double         Buf_ima_0[];
double         Buf_ima_1[];
double         Buf_ima_2[];
double         Buf_ima_3[];
double         Buf_ima_4[];

datetime    _last_open_time;
int limit;
//-----------------inputs
input int opt_len = 200;
input bool type_fuzzy = False;
input int iMA_len_0 =3;
input int iMA_len_1 =5;
input int iMA_len_2 =8;
input int iMA_len_3 =12;
input int iMA_len_4 =15;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrWhite);
   SetIndexBuffer(0,Buf_ima_0);
   SetIndexLabel(0 ,"ima 0");   
   
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, clrOldLace);
   SetIndexBuffer(1,Buf_ima_1);
   SetIndexLabel(1 ,"ima 1");   
   
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1, clrPeachPuff);
   SetIndexBuffer(2,Buf_ima_2);
   SetIndexLabel(2 ,"ima 2");   
   
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1, clrBurlyWood);
   SetIndexBuffer(3,Buf_ima_3);
   SetIndexLabel(3 ,"ima 3");   
   
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1, clrDarkSalmon);
   SetIndexBuffer(4,Buf_ima_4);
   SetIndexLabel(4 ,"ima 4");   
   
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
      limit-=100;//max(iMA_len_1,iMA_len_2,iMA_len_3,iMA_len_4,iMA_len_5);
   }
   double eval[5];
   for(int i=limit-1; i >= 0; i--)
   {
      Buf_ima_0[i]=iCustom(Symbol(), Period(), "my_IMA_eval", opt_len, type_fuzzy, iMA_len_0, 1, i);
      Buf_ima_1[i]=iCustom(Symbol(), Period(), "my_IMA_eval", opt_len, type_fuzzy, iMA_len_1, 1, i);
      Buf_ima_2[i]=iCustom(Symbol(), Period(), "my_IMA_eval", opt_len, type_fuzzy, iMA_len_2, 1, i);
      Buf_ima_3[i]=iCustom(Symbol(), Period(), "my_IMA_eval", opt_len, type_fuzzy, iMA_len_3, 1, i);
      Buf_ima_4[i]=iCustom(Symbol(), Period(), "my_IMA_eval", opt_len, type_fuzzy, iMA_len_4, 1, i);
   }
//--- return value of prev_calculated for next call
      return(rates_total);
}

