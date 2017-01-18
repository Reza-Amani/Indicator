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
double         Buf_eval_0[];
double         Buf_eval_1[];
double         Buf_eval_2[];
double         Buf_eval_3[];
double         Buf_eval_4[];

datetime    _last_open_time;
int limit;
//-----------------inputs
input int opt_len = 800;
input bool type_fuzzy = False;
input int iMA_short_len_0 = 5;
input int iMA_short_len_1 = 8;
input int iMA_short_len_2 = 12;
input int iMA_short_len_3 = 20;
input int iMA_short_len_4 = 50;
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
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrWhite);
   SetIndexBuffer(0,Buf_eval_0);
   SetIndexLabel(0 ,"eval 0");   
   
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, clrOldLace);
   SetIndexBuffer(1,Buf_eval_1);
   SetIndexLabel(1 ,"eval 1");   
   
   SetIndexStyle(2, DRAW_LINE, STYLE_SOLID, 1, clrPeachPuff);
   SetIndexBuffer(2,Buf_eval_2);
   SetIndexLabel(2 ,"eval 2");   
   
   SetIndexStyle(3, DRAW_LINE, STYLE_SOLID, 1, clrBurlyWood);
   SetIndexBuffer(3,Buf_eval_3);
   SetIndexLabel(3 ,"eval 3");   
   
   SetIndexStyle(4, DRAW_LINE, STYLE_SOLID, 1, clrDarkSalmon);
   SetIndexBuffer(4,Buf_eval_4);
   SetIndexLabel(4 ,"eval 4");   
   
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
      Buf_eval_0[i]=iCustom(Symbol(), Period(), "2eval_S4", opt_len, type_fuzzy, iMA_short_len_0,
         use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 1, i);
      Buf_eval_1[i]=iCustom(Symbol(), Period(), "2eval_S4", opt_len, type_fuzzy, iMA_short_len_1,
         use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 1, i);
      Buf_eval_2[i]=iCustom(Symbol(), Period(), "2eval_S4", opt_len, type_fuzzy, iMA_short_len_2,
         use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 1, i);
      Buf_eval_3[i]=iCustom(Symbol(), Period(), "2eval_S4", opt_len, type_fuzzy, iMA_short_len_3,
         use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 1, i);
      Buf_eval_4[i]=iCustom(Symbol(), Period(), "2eval_S4", opt_len, type_fuzzy, iMA_short_len_4,
         use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 1, i);
   }
//--- return value of prev_calculated for next call
      return(rates_total);
}

