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

datetime    _last_open_time;
int limit;
int iMA_array[5];
//-----------------inputs
input bool type_fuzzy = True;
input int iMA_len_0 =10;
input int iMA_len_1 =20;
input int iMA_len_2 =30;
input int iMA_len_3 =40;
input int iMA_len_4 =50;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrGreen);
   SetIndexBuffer(0,Buf_ima_max);
   SetIndexLabel(0 ,"best ima len");   
   
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
         eval[j]=iCustom(Symbol(), Period(), "my_eval", type_fuzzy, iMA_array[j], 0, i);
      Buf_ima_max[i]=iMA_array[max_index(eval[0],eval[1],eval[2],eval[3],eval[4])];
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
int max_index(double v1, double v2=-1, double v3=-1, double v4=-1, double v5=-1, double v6=-1)
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
