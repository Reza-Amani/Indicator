//Note: this is not for realtime processing nor simulation
//only works on history, not new bars
#property copyright "Reza"
#property strict
#property indicator_chart_window
#property indicator_buffers 1
#property indicator_plots   1
#property indicator_minimum    -1
#property indicator_maximum    1

//--- indicator buffers
double         Buffer_correlation[];
//-----------------macros
#define compare_point 20
#define compare_len 100
//-----------------inputs
//input int MACD_fast_len = 35;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 1, clrBlue);
   SetIndexBuffer(0,Buffer_correlation);
   SetIndexLabel(0 ,"correlation");   
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
   if (Bars<10+compare_len) // if less bars are available on a chart (for example on MN timeframe)    
     return(-1); // stop calculation and exit

   //--- the number of bars that have not changed since the last indicator call
   int counted_bars=IndicatorCounted();
   //--- exit if an error has occurred
   if(counted_bars<0) return(-1);
      
   //--- position of the bar from which calculation in the loop starts
   int limit=Bars-counted_bars;

   //--- if counted_bars=0, reduce the starting position in the loop by 1,   
   if(counted_bars==0) 
     {
      limit--;  // to avoid the array out of range problem when counted_bars==0
      limit-=10+compare_len;
     }
   else //--- the indicator has been already calculated, counted_bars>0
     {     
      //--- for repeated calls increase limit by 1 to update the indicator values for the last bar
      //Note: this recalculation may cause bug in state-machine-based algorithms
      limit++;
     } 
   //--- the main calculation loop
   for (int i=limit; i>=0; i--)
   {
      Buff
      double volatility = max(High[i+1],High[i+2],High[i+3]) - min(Low[i+1],Low[i+2],Low[i+3]); 
      double prev_mid = (High[i+1]+Low[i+1])/2;
      Buffer_ceiling_high[i]= High[i+1]+volatility/2;
      Buffer_ceiling_med[i]= prev_mid+volatility/2;
      Buffer_floor_med[i]= prev_mid-volatility/2;
      Buffer_floor_low[i]= Low[i+1]-volatility/2;
   }

//--- return value of prev_calculated for next call
   return(rates_total);
}
double correlation(int pattern1, int pattern2, int len)
{  //pattern1&2 are the end index of 2 arrays
   double avg1=0,avg2=0;
   int i;
   for(i=0; i<len; i++)
   {
      avg1 += Close[i+pattern1];
      avg2 += Close[i+pattern2];
   }
   avg1 /= len;
   avg2 /= len;
   
}
//general funcs
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
