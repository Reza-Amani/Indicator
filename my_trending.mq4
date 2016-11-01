//+------------------------------------------------------------------+
//|                                                        judge.mq4 |
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      ""
#property version   "1.00"
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
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrBlueViolet);
   SetIndexBuffer(0,Buffer);
   SetIndexLabel(0 ,"level");   
   
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
   for(int i=0; i < limit; i++)
      Buffer[i]=0;
   if(iMA_use)
      use_ima(close);
   if(CMO_use)
      use_CMO();

//--- return value of prev_calculated for next call
      return(rates_total);
}

void use_CMO()
{
   double cmo0,cmo1,cmo2,cmo3;
   for(int i=0; i < limit; i++)
   {
      double cmo_sum=0;
      cmo0 = iCustom(NULL, 0, "downloaded/CMO_v1", CMO_len, 0, 0, i);
      cmo1 = iCustom(NULL, 0, "downloaded/CMO_v1", CMO_len, 0, 0, i+1);
      cmo2 = iCustom(NULL, 0, "downloaded/CMO_v1", CMO_len, 0, 0, i+2);
      cmo3 = iCustom(NULL, 0, "downloaded/CMO_v1", CMO_len, 0, 0, i+3);
      if(cmo0>0)
         cmo_sum +=1;
      if(cmo0>=cmo1)
         if(cmo1>=cmo2)
//            if(cmo2>=cmo3)
               cmo_sum += 1;
      if(cmo0<0)
         cmo_sum -=1;
      if(cmo0<=cmo1)
         if(cmo1<=cmo2)
//            if(cmo2<=cmo3)
               cmo_sum -= 1;
      Buffer[i] += cmo_sum/2 * CMO_weight;
   }
}

void use_ima(const double &close[])
{
   for(int i=0; i < limit; i++)
   {
      double ima10 = iMA(Symbol(), Period(), 1*ima_base, 0, MODE_SMA, PRICE_TYPICAL, i);
      double ima20 = iMA(Symbol(), Period(), 2*ima_base, 0, MODE_SMA, PRICE_TYPICAL, i);
      double ima50 = iMA(Symbol(), Period(), 5*ima_base, 0, MODE_SMA, PRICE_TYPICAL, i);
      double ima_sum=0;
      if(ima20>ima50)
         ima_sum++;
      else
         ima_sum--;
      if(ima10>ima20)
         ima_sum++;
      else
         ima_sum--;
      if(close[i]>ima50)
         ima_sum++;
      else
         ima_sum--;
      if(close[i]>ima20)
         ima_sum++;
      else
         ima_sum--;
      Buffer[i] += ima_sum/4 * iMA_weight;
   }
}
//+------------------------------------------------------------------+
