//+------------------------------------------------------------------+
//|                                                         test.mq4 |
//|                        Copyright 2021, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
//*******************<<取引関数>>************************
input int MAGIC = 210510;  //マジックナンバー入力
double Lots;
extern double MinLots = 1;  //変動最低ロット
extern bool LotsFlag = false;  //変動・固定ロットフラグ・・・true=変動ロット
extern bool flag = true;
extern int Slippage = 3;  //スリッページ
extern int Leverage = 10;  //レバレッジ
extern int MaxBal = 100;  //最大使用率
//*******************<<内部変数>>************************
//<<<<<string変数>>>>>
string PosiChk = "No";  //ポジションの保有状態・・・No:無し、Buy:買い、Sell:売り
//グローバル変数 PosiChk 0:No 1:Buy 2:Sell
//<<<<<int変数>>>>>
int TimeFr = 5;  //トレード対象時間足
int cnt = 0;
int Max_Pos_Cnt = 10;
int Pos_Cnt = 0;  //保有ポジションカウント
extern int RSI_Nm = 16;
extern int RSI_Up = 65;
extern int RSI_Dw = 35;
extern int MA_Srt = 63;
extern int MA_Lng = 30;
//<<<<<double変数>>>>>
extern double SAR_St = 0.05;
extern double SAR_Mx = 0.5;
extern double Par_cnt = 4;
extern double MA_SAR_BULL = 0.5;
extern double MA_SAR_BEAR = 0.4;

//=========<<決済用プログラム>>============
void ClosePositions(int IN_MAGIC)
{
   for(int i=0; i<OrdersTotal(); i++)
   {
      if (OrderSelect(i,SELECT_BY_POS,MODE_TRADES) == false) break;
      if (OrderMagicNumber() != IN_MAGIC || OrderSymbol() != Symbol())continue;
      if (OrderType() == OP_BUY)
      {
         int OrderChk = OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White);
         break;
      }
      if (OrderType() == OP_SELL)
      {
         int OrderChk = OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,White);
         break;
      }
   }
}
void CloseAlls(int In_cnt)
{
   for(int i=In_cnt;i > 0;i--)
      {
         ClosePositions(MAGIC_Maker(i));
      }
}
//=========<<買いプログラム>>==========
void TradeBuy(double Index,int IN_MAGIC)
{
   int OrderChk = OrderSend(Symbol(),OP_BUY,Index,Ask,Slippage,0,0,"",IN_MAGIC,0,Blue);
   if(OrderChk >= 1)
   {
      PosiChk = "Buy";
   }    
}
//=========<<売りプログラム>>==========
void TradeSell(double Index,int IN_MAGIC)
{
   int OrderChk = OrderSend(Symbol(),OP_SELL,Index,Bid,Slippage,0,0,"",IN_MAGIC,0,Red);
   if(OrderChk >= 1)
      {
         PosiChk = "Sell";
      }
}
//==========<<パラボリック>>============
int SAR_Flg(int Index)
{
   double SAR_Buf = iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,Index);
   double Cand_Buf = iClose(Symbol(),TimeFr,Index);
   if(SAR_Buf > Cand_Buf)
      {
         return(-1);
      }
   else if(SAR_Buf < Cand_Buf)
      {
         return(1);
      }
   else
      {
         return(0);
      }
}
//==========<<パラボリック連続チェック>>===============
int Sar_Cnt(int Index,int In_Flag)
{
   int cnt_buf = 0;
   for(int i = 0;i < 50; i++)
      {
         if(SAR_Flg(Index + i) == In_Flag)
            {
               cnt_buf = cnt_buf + 1;
            }
         else
            {
               break;
            }   
      }
   return(cnt_buf);
}
//==========<<パラボリック加速度チェック>>=============
double Par_G_Chk(int Pmt)
{
   double ret_buf = 0;
   double calc_buf = 0;
   double ans_buf = 0; 
   for(int i=1; i<30; i++)
      {
         if(SAR_Flg(i) == Pmt && SAR_Flg(i+1) == Pmt && SAR_Flg(i+2) == Pmt)
            {
               double buf_b = 0;
               double buf_a = 0;
               if(SAR_Flg(i) == 1)
                  {
                     buf_b = iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i+1) - iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i+2);
                     buf_a = iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i) - iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i+1);
                     
                  }
               else if(SAR_Flg(i) == -1)
                  {
                     buf_b = iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i+2) - iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i+1);
                     buf_a = iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i+1) - iSAR(Symbol(),TimeFr,SAR_St,SAR_Mx,i);
                     
                  }
               if(buf_a > buf_b)
                  {
                     calc_buf = calc_buf + 1;
                  }
            }
         else
            {
               ans_buf = (double)i - 1;
               break;
            }   
      }
      if(ans_buf != 0 && ans_buf > Par_cnt)
         {
            ret_buf = calc_buf / ans_buf;
         }   
   return(ret_buf);
}
//==========<<MA>>==========
//<<<<MA基本>>>>>>>>
double MA_Tec(int MA_pr,int Index)
{
   double MA_buf= iMA(NULL,TimeFr,MA_pr,0,MODE_SMA,PRICE_CLOSE,Index);
   return(MA_buf);
}
//<<<<<MAサイコロジカル>>>>>>
double MA_Syc(int Kikan)
{
   double ret_buf = 0;
   double calc_buf = 0;
   for(int i = 1;i < Kikan;i++)
      {
         if(MA_Tec(3,i) > MA_Tec(3,i+1))
            {
               calc_buf = calc_buf + 1;
            }
      }
   if(Kikan != 0)   
      {
         ret_buf = calc_buf / (double)Kikan;
      }
   else
      {
         ret_buf = 0;
      }   
   return(ret_buf);   
}
//==========<<MA・パラボリック比較>>===========
bool MA_SAR_Chk(int Index,string Updw)
{
   int SAR_Num = 0;
   double Syc_buf = 0;
   bool flag_buf =false;
   if(Updw == "Up")
      {
         SAR_Num = 1;
         Syc_buf = MA_Syc(Sar_Cnt(Index,SAR_Num));
         if(Syc_buf > MA_SAR_BULL)
            {
               flag_buf = true;
            }
      }
   else if(Updw == "Dw")
      {
         SAR_Num = -1;
         Syc_buf = MA_Syc(Sar_Cnt(Index,SAR_Num));
         if(Syc_buf < MA_SAR_BEAR)
            {
               flag_buf = true;
            }
      }
   return(flag_buf);
}
//==========<<RSI>>==========
//<<<<<RSI基本>>>>>
double RSI(int Index)
{
   double RSI_1 = iRSI(Symbol(),TimeFr,RSI_Nm,PRICE_CLOSE,Index);
   return(RSI_1);
}
//<<<<<RSIテクニカル>>>>>
string RSI_Tec(int Index)
{
   string RSI_Buf = "No";
   if(RSI(Index) >= RSI_Up)
      {
         RSI_Buf = "Up";
      }
   else if(RSI(Index) <= RSI_Dw)
      {
         RSI_Buf = "Dw";
      }
   else
      {
         RSI_Buf = "No";   
      }
      return(RSI_Buf);
}
//===========<<MAGIC発行>>============
int MAGIC_Maker(int Pos_cnt)
{
   int MAGIC_buf = 0;
   MAGIC_buf = MAGIC * 100 + Pos_cnt;
   return(MAGIC_buf);
}
int start()
{
//==========<<ローソク足完成ま更新待機>>==========
   if(Volume[0]>1 || IsTradeAllowed() == false) return(0);
  
   if(iClose(Symbol(),TimeFr,3) < MA_Tec(200,3) && iOpen(Symbol(),TimeFr,3) < MA_Tec(200,3) &&
      iClose(Symbol(),TimeFr,2) > MA_Tec(200,2) && iOpen(Symbol(),TimeFr,2) < MA_Tec(200,2) &&
      iClose(Symbol(),TimeFr,1) > MA_Tec(200,1) && iOpen(Symbol(),TimeFr,1) > MA_Tec(200,1)){
         SendNotification("UP CHANCE");
      } 
   else if(iClose(Symbol(),TimeFr,3) > MA_Tec(200,3) && iOpen(Symbol(),TimeFr,3) > MA_Tec(200,3) &&
      iClose(Symbol(),TimeFr,2) < MA_Tec(200,2) && iOpen(Symbol(),TimeFr,2) > MA_Tec(200,2) &&
      iClose(Symbol(),TimeFr,1) < MA_Tec(200,1) && iOpen(Symbol(),TimeFr,1) < MA_Tec(200,1)){
         SendNotification("UP CHANCE");
      }

   return(0);
}

//+------------------------------------------------------------------+
