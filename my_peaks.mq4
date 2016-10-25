//+------------------------------------------------------------------+
//|                                                     my_peaks.mq4 |
//|                                                             Reza |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Reza"
#property link      ""
#property version   "1.00"
#property strict
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2
//--- plot Label1
#property indicator_label1  "Label1"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrRed
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1
//--- plot Label2
#property indicator_label2  "Label2"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrLightSeaGreen
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1
//--- indicator buffers
double         Label1Buffer[];
double         Label2Buffer[];
//--------macros
#define _peaks_array_size 200
//---globals
int limit;
double tops_price_array[_peaks_array_size]={1000};
int tops_bar_array[_peaks_array_size]={-1};
double bottoms_price_array[_peaks_array_size]={0};
int bottoms_bar_array[_peaks_array_size]={-1};
int arrow_cnt=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping
   SetIndexBuffer(0,Label1Buffer);
   SetIndexBuffer(1,Label2Buffer);
   
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
   limit = rates_total - prev_calculated;
   if(prev_calculated>0)
      limit++;
   else
      limit-=100;
   for(int i=limit-1; i >= 0; i--)
      peak_detector(i);
   peak_detector(0);
   
//--- return value of prev_calculated for next call
      return(rates_total);
}
//+------------------------------------------------------------------+
#define _look_for_top_state 1
#define _look_for_bottom_state 2
void peak_detector(int bar)
{
   static int peak_detector_state_machine = _look_for_top_state;
   switch(peak_detector_state_machine)
   {
      case _look_for_top_state:
         if(High[3 +bar] >= max(High[1 +bar],High[2 +bar],High[4 +bar],High[5 +bar]))
         {
            tops_arrays_append(High[3 +bar],3 +bar);
            arrow_cnt++;
            ObjectCreate(IntegerToString(arrow_cnt),OBJ_ARROW_DOWN,0,Time[3 +bar], High[3 +bar]);   
            peak_detector_state_machine = _look_for_bottom_state;
         }
         else
         if( (High[2 +bar] > max(High[1 +bar],High[3 +bar],High[4 +bar],High[5 +bar]))   //early declaration of a top if next bar is strong
            && ((High[1 +bar]<High[2 +bar])&&(Low[1 +bar]<Low[2 +bar]))
               && (Close[1 +bar]<Open[1 +bar]) )
               {
                  tops_arrays_append(High[2 +bar],2 +bar);
                  arrow_cnt++;
                  ObjectCreate(IntegerToString(arrow_cnt),OBJ_ARROW_DOWN,0,Time[2 +bar], High[2 +bar]);   
                  peak_detector_state_machine = _look_for_bottom_state;
               }
         else
         if(Low[1 +bar ]<bottoms_price_array[0])  //disapproving last bottom because of a lower low taking over it
         {
            //TOCHECK: close potential buy, if it has not breached sl
            //NOTE: disapproved bottom is not going to be removed
            peak_detector_state_machine = _look_for_bottom_state;
         }
         break;
         
      case _look_for_bottom_state:
         if(Low[3 +bar] <= min(Low[1 +bar],Low[2 +bar],Low[4 +bar],Low[5 +bar]))
         {
            bottoms_arrays_append(Low[3 +bar],3 +bar);
            arrow_cnt++;
            ObjectCreate(IntegerToString(arrow_cnt),OBJ_ARROW_UP,0,Time[3 +bar], Low[3 +bar]);   
            peak_detector_state_machine = _look_for_top_state;
         }
         else
         if( (Low[2 +bar] < min(Low[1 +bar],Low[3 +bar],Low[4 +bar],Low[5 +bar]))   //early declaration of a bottom if next bar is strong
            && ((High[1 +bar]>High[2 +bar])&&(Low[1 +bar]>Low[2 +bar]))
               && (Close[1 +bar]>Open[1 +bar]) )
               {
                  bottoms_arrays_append(Low[2 +bar],2 +bar);
                  arrow_cnt++;
                  ObjectCreate(IntegerToString(arrow_cnt),OBJ_ARROW_UP,0,Time[2 +bar], Low[2 +bar]);   
                  peak_detector_state_machine = _look_for_top_state;
               }
         else
         if(High[1 +bar]>tops_price_array[0])  //disapproving last top because of a higher high taking over it
         {
            //TOCHECK: close potential sell, if it has not breached sl
            //NOTE: disapproved top is not going to be removed
            peak_detector_state_machine = _look_for_top_state;
         }
         
         break;
   }
}
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
void tops_arrays_append(double top_price, int top_bar)
{
   for(int i=_peaks_array_size-1; i>0; i--)
   {
      tops_price_array[i] = tops_price_array[i-1];
      tops_bar_array[i] = tops_bar_array[i-1];
   }
   tops_price_array[0] = top_price;
   tops_bar_array[0] = top_bar;
}
void bottoms_arrays_append(double bottoms_price, int bottoms_bar)
{
   for(int i=_peaks_array_size-1; i>0; i--)
   {
      bottoms_price_array[i] = bottoms_price_array[i-1];
      bottoms_bar_array[i] = bottoms_bar_array[i-1];
   }
   bottoms_price_array[0] = bottoms_price;
   bottoms_bar_array[0] = bottoms_bar;
}
