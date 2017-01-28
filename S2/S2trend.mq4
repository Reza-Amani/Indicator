//+------------------------------------------------------------------+
//|                               sig gen for 4-stage plan Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_plots   1
//--- indicator buffers
double         Buffer[];
datetime    _last_open_time;
int limit;
//-----------------macros
//-----------------inputs
input int MACD_fast_len = 13;
input bool use_ADX_confirm = False;
input int ADX_period = 20;
input int ADX_level = 22;
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
   _last_open_time = time[0];
   limit = rates_total - prev_calculated;
//      if(prev_calculated>0)
//         limit++;
   for(int i=limit-1; i >= 0; i--)
      Buffer[i]= calculate(i);

//--- return value of prev_calculated for next call
      return(rates_total);
}

double calculate(int bar)
{  
   double MACD = iMACD(Symbol(), Period(), MACD_fast_len, 2 * MACD_fast_len, 9, PRICE_OPEN, 0, bar);
   double MACD_sig_ima = iMACD(Symbol(), Period(), MACD_fast_len, 2 * MACD_fast_len, 9, PRICE_OPEN, 1, bar);
//   double RSI0 = iRSI(Symbol(), Period(), RSI_len,PRICE_CLOSE,bar+1);
//   double RSI1 = iRSI(Symbol(), Period(), RSI_len,PRICE_CLOSE,bar+2);

   double ADX = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_MAIN, 0);
   double pDI = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_PLUSDI, 0);
   double nDI = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_MINUSDI, 0);
//   Comment("ADX: ", ADX,"    +: ", pDI,"    -: ", nDI);

   int trend,temp_course,temp_fine;
   temp_course = (MACD>0) ? +3 : -3;
   temp_fine = (MACD>MACD_sig_ima) ? +1 : -1;
   trend = temp_course+temp_fine;
   return trend;

                                                         
}//+------------------------------------------------------------------+
bool confirm_bull(int bar)
{
   if( ! use_ADX_confirm)
      return true;
   double ADX = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_MAIN, bar);
   double pDI = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_PLUSDI, bar);
   double nDI = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_MINUSDI, bar);

   if( (pDI>nDI) && (ADX>ADX_level) )
      return true;
   else
      return false;
}
bool confirm_bear(int bar)
{
   if( ! use_ADX_confirm)
      return true;
   double ADX = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_MAIN, bar);
   double pDI = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_PLUSDI, bar);
   double nDI = iADX(Symbol(), Period(), ADX_period, PRICE_OPEN, MODE_MINUSDI, bar);

   if( (pDI<nDI) && (ADX>ADX_level) )
      return true;
   else
      return false;
}