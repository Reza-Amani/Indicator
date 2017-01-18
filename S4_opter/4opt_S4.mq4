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
double         Buf_ima_max[];
double         Buf_eval_max[];

datetime    _last_open_time;
int limit;
int iMA_array[5];
//-----------------inputs
input int opt_len = 200;
input bool type_fuzzy = False;
input int iMA_len_0 =3;
input int iMA_len_1 =5;
input int iMA_len_2 =8;
input int iMA_len_3 =12;
input int iMA_len_4 =15;
input bool use_ADX_confirm = True;
input int ADX_period = 20;
input int ADX_level = 20;
input bool use_RSI_enter = True;
input int RSI_len = 10;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrGreen);
   SetIndexBuffer(0,Buf_ima_max);
   SetIndexLabel(0 ,"best ima len");  
    
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, clrYellow);
   SetIndexBuffer(1,Buf_eval_max);
   SetIndexLabel(1 ,"max eval");   
   
   iMA_array[0]=iMA_len_0;
   iMA_array[1]=iMA_len_1;
   iMA_array[2]=iMA_len_2;
   iMA_array[3]=iMA_len_3;
   iMA_array[4]=iMA_len_4;
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
//      limit-=max(iMA_len_1,iMA_len_2,iMA_len_3,iMA_len_4,iMA_len_5);
   }
   double eval[5];
   for(int i=limit-1; i >= 0; i--)
   {
      for(int j=0; j<5; j++)
         eval[j]=iCustom(Symbol(), Period(), "2eval_S4", opt_len, type_fuzzy, iMA_array[j],
            use_ADX_confirm,ADX_period,ADX_level,use_RSI_enter,RSI_len, 1, i);

      Buf_ima_max[i]=max_index(0,eval[0],eval[1],eval[2],eval[3],eval[4]);
      Buf_eval_max[i]=max(0,100*eval[max_index(eval[0],eval[1],eval[2],eval[3],eval[4])]);
   }
//--- return value of prev_calculated for next call
      return(rates_total);
}

///////////////////////////////////////////////////////////
double max(double v1, double v2=-1, double v3=-1, double v4=-1, double v5=-1, double v6=-1)
{
   double result = v1;
   if(v2>result)  result=v2;
   if(v3>result)  result=v3;
   if(v4>result)  result=v4;
   if(v5>result)  result=v5;
   if(v6>result)  result=v6;
   return result;
}
int max_index(double v1, double v2=-1000, double v3=-1000, double v4=-1000, double v5=-1000, double v6=-1000)
{
   int index = 0;
   double Max = v1;
   if(v2>Max)  { Max=v2; index=1;}
   if(v3>Max)  { Max=v3; index=2;}
   if(v4>Max)  { Max=v4; index=3;}
   if(v5>Max)  { Max=v5; index=4;}
   if(v6>Max)  { Max=v6; index=5;}
   return index;
}
