//+------------------------------------------------------------------+
//|                               sig gen for 4-stage plan Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_chart_window
#property indicator_buffers 2
#property indicator_plots   2
//--- indicator buffers
double         Buffer_ceiling[];
double         Buffer_floor[];
datetime    _last_open_time;
int limit;
//-----------------macros
//-----------------inputs
//input int MACD_fast_len = 35;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrRosyBrown);
   SetIndexBuffer(0,Buffer_ceiling);
   SetIndexLabel(0 ,"ceiling");   
   SetIndexStyle(1, DRAW_LINE, STYLE_SOLID, 1, clrBrown);
   SetIndexBuffer(1,Buffer_floor);
   SetIndexLabel(1 ,"floor");   
   
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
   if(rates_total<=0)
      return(0);
   _last_open_time = time[0];
   limit = rates_total - prev_calculated;
   if(prev_calculated>0)
      limit++;
//   for(int i=0; i<limit; i++)
   for(int i=limit-4; i >= 0; i--)
   {
      double volatility = max(High[i+1],High[i+2],High[i+3]) - min(Low[i+1],Low[i+2],Low[i+3]); 
      Buffer_ceiling[i]= (High[i+1]+Low[i+1])/2+volatility/2;
      Buffer_floor[i]= (High[i+1]+Low[i+1])/2-volatility/2;
   }

//--- return value of prev_calculated for next call
      return(rates_total);
}

//+------------------------------------------------------------------+
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
double min(double v1, double v2=1000, double v3=1000, double v4=1000, double v5=1000, double v6=1000)
{
   double result = v1;
   if(v2<result)  result=v2;
   if(v3<result)  result=v3;
   if(v4<result)  result=v4;
   if(v5<result)  result=v5;
   if(v6<result)  result=v6;
   return result;
}
