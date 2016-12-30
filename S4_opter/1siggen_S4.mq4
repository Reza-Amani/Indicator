//+------------------------------------------------------------------+
//|                               sig gen for 4-stage plan Evaluation|
//|                                                             Reza |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property strict
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2
//--- indicator buffers
double         Buffer_sig[];
double         Buffer_state[];
datetime    _last_open_time;
int limit;
int state=0;
//-----------------macros
#define iMA_fast_len_factor 3
//-----------------inputs
input bool type_fuzzy = False;
input int iMA_short_len = 20;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   SetIndexStyle(0, DRAW_LINE, STYLE_SOLID, 2, clrRed);
   SetIndexBuffer(0,Buffer_sig);
   SetIndexLabel(0 ,"favorability signal");   
   
   SetIndexStyle(1, DRAW_HISTOGRAM, STYLE_SOLID, 1, clrBlueViolet);
   SetIndexBuffer(1,Buffer_state);
   SetIndexLabel(1 ,"state");   
   
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
   for(int i=limit-1; i >= 0; i--)
   {
      Buffer_sig[i]=(type_fuzzy) ? sig_fuzzy(i) : sig_digitised(i);
      Buffer_state[i]=state;
    }

//--- return value of prev_calculated for next call
      return(rates_total);
}

double sig_fuzzy(int bar)
{
/*   if(bar > limit-80)
      return 0;
   double imaFast = iMA(Symbol(), Period(), iMA_fast_len, 0, MODE_SMA, PRICE_OPEN, bar);
   double imaSlow = iMA(Symbol(), Period(), iMA_len, 0, MODE_SMA, PRICE_OPEN, bar);

   return 1000*(imaFast-imaSlow);
*/
   return 0;
}

double sig_digitised(int bar)
{  //returns the signal, =1,-1 or 0
   //and update the state
   double imaFast = iMA(Symbol(), Period(), iMA_short_len, 0, MODE_LWMA, PRICE_OPEN, bar);
   double imaSlow = iMA(Symbol(), Period(), iMA_short_len * iMA_fast_len_factor, 0, MODE_SMA, PRICE_OPEN, bar);

   switch(state)
   {
      case 0:  //no trend
         if( (Open[bar]>imaFast) && (imaFast>imaSlow) )
            state = 1;
         else if( (Open[bar]<imaFast) && (imaFast<imaSlow) )
            state = -1;
         break;

      case 1:  //ima in order, wait for confirm
         if( ! ((Open[bar]>imaFast) && (imaFast>imaSlow)) )
            state = 0;  //return t null state
         else
            state = 2;  //confirmed
         break;
      case 2:  //confirmed, wait for trade oppurtunity
               if( ! ((Open[bar]>imaFast) && (imaFast>imaSlow)) )
                  state = 0;  //return t null state
               else
                  state = 2;  //confirmed
         break;


      case -1:  //ima in order, wait for confirm
         if( ! ((Open[bar]<imaFast) && (imaFast<imaSlow)) )
            state = 0;  //return t null state
         else
            state = -2;  //confirmed
         break;
      case -2:  //confirmed, wait for trade oppurtunity
               if( ! ((Open[bar]<imaFast) && (imaFast<imaSlow)) )
                  state = 0;  //return t null state
               else
                  state = -2;  //confirmed
         break;
   }
   if(state>=2)
      return +1;
   else if(state<=-1)
      return -1;
   else
      return 0;
}//+------------------------------------------------------------------+
