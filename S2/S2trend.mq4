//+------------------------------------------------------------------+
//|                               sig gen for 4-stage plan Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_minimum    -6
#property indicator_maximum    6
#property indicator_buffers 1
#property indicator_plots   1
//--- indicator buffers
double         Buffer[];
datetime    _last_open_time;
int limit;
//-----------------macros
//-----------------inputs
input int MACD_fast_len = 35;
input bool use_ADX_confirm = True;
input int ADX_period = 40;
input int ADX_level = 25;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_HISTOGRAM, STYLE_SOLID, 2, clrBlue);
   SetIndexBuffer(0,Buffer);
   SetIndexLabel(0 ,"trend quality");   
   
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
   if(rates_total<=10)
      return(0);
   _last_open_time = time[0];
   limit = rates_total - prev_calculated;
   if(prev_calculated>0)
      limit++;
//   for(int i=0; i<limit; i++)
   for(int i=limit-1; i >= 0; i--)
      Buffer[i]= calculate(i);

//--- return value of prev_calculated for next call
      return(rates_total);
}

int calculate(int bar)
{  
   double MACD = iMACD(Symbol(), Period(), MACD_fast_len, 2 * MACD_fast_len, 9, PRICE_CLOSE, MODE_MAIN, bar+1);
   double MACD_sig_ima = iMACD(Symbol(), Period(), MACD_fast_len, 2 * MACD_fast_len, 9, PRICE_CLOSE, MODE_SIGNAL, bar+1);
//   double RSI0 = iRSI(Symbol(), Period(), RSI_len,PRICE_CLOSE,bar+1);
//   double RSI1 = iRSI(Symbol(), Period(), RSI_len,PRICE_CLOSE,bar+2);

   double ADX = iADX(Symbol(), Period(), ADX_period, PRICE_CLOSE, MODE_MAIN, bar+1);
   double pDI = iADX(Symbol(), Period(), ADX_period, PRICE_CLOSE, MODE_PLUSDI, bar+1);
   double nDI = iADX(Symbol(), Period(), ADX_period, PRICE_CLOSE, MODE_MINUSDI, bar+1);
//   Comment("ADX: ", ADX,"    +: ", pDI,"    -: ", nDI);

   int trend,temp_course,temp_fine;
   temp_course = (MACD>0) ? +3 : -3;
   temp_fine = (MACD>MACD_sig_ima) ? +1 : -1;
   trend = temp_course+temp_fine;
      //so far +-4 for trend, +-2 for uncertain trend
   if( use_ADX_confirm)
   {
      temp_fine = (pDI>nDI) ? +1 : -1;
      temp_course = (ADX>ADX_level) ? 2 : 1;
      trend += temp_course * temp_fine;
   }
   else
      trend *= 2;
   return trend;

                                                         
}//+------------------------------------------------------------------+
