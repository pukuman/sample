#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

//------------------------------------------------------------------------------
// Sort用構造体
//------------------------------------------------------------------------------
typedef struct SortItemStruct {
  int value;                        // 値
  struct SortItemStruct *small;     // この値より小さい構造体へのアドレス
  struct SortItemStruct *large;     // この値より大きい構造体へのアドレス
} SortItem;


//------------------------------------------------------------------------------
// Sort用構造体の標準出力
//------------------------------------------------------------------------------
void DumpItem(char *comment,SortItem *item){
  printf("%10s:(%p) %5d, small=(%p), large=(%p)\n",comment,item,item->value,item->small,item->large);
}

//------------------------------------------------------------------------------
// Sort用構造体へ、新しい構造体を追加
//   now_item : 追加開始する構造体のアドレス
//   new_item : 追加する構造体
//-----
// * 必ず、new_itemの方が、now_itemよりも値が大きい
// * now_itemを起点に、適切なSort構造体の位置を把握し、そこに追加する
//------------------------------------------------------------------------------
int AddLargeItem(SortItem *now_item, SortItem *new_item){

  // もう先がない
  if(now_item->large == NULL){
    now_item->large   = new_item;
    new_item->small = now_item;
    return 0;
  }
  
  // 先があるので、再帰呼び出し
  if(now_item->large->value <= new_item->value){
    AddLargeItem(now_item->large, new_item);
    return 0;
  }

  // ポインターを付け替える 
  SortItem *next_item;
  next_item = now_item->large;
  now_item->large = new_item;
  new_item->small = now_item;
  new_item->large = next_item;
  next_item->small = new_item;
  //DumpItem("[AddLargeitem]Swap Item.now =", now_item );
  //DumpItem("[AddLargeitem]Swap Item.new =", new_item );
  //DumpItem("[AddLargeitem]Swap Item.next=", next_item);
  return 0; 
}

//------------------------------------------------------------------------------
// Sort用構造体から、最小のItemを検索
//   sort_items : 検索対象のSort用構造体
//   戻り値     : Sort用構造体の中で、一番小さい値を持つ構造体へのアドレス
//------------------------------------------------------------------------------
SortItem *GetMinItem(SortItem *sort_items){
  SortItem *now_item;
  SortItem *min_item;
  now_item = sort_items;

  // small側がなし(NULL)になるまで検索
  while(1){
    if( now_item->small == NULL ){
      min_item = now_item;
      break;
    }
    now_item = now_item->small;
  }
  return min_item;
}

//------------------------------------------------------------------------------
// Sort用構造体へ新しい値を追加
//   sort_items : Sort用構造体
//   new_value  : 追加する値
//------------------------------------------------------------------------------
int AddValue(SortItem *sort_items, int new_value){
  // 新しいiTem用の構造体を確保
  SortItem *new_item;
  new_item = (SortItem *)malloc(sizeof(SortItem));
  new_item->value = new_value;
  new_item->small  = NULL;
  new_item->large  = NULL;
 
  // 最小のItemを検索
  SortItem *min_item;
  min_item = GetMinItem(sort_items);
 
  // 最小Itemと比較し、
  //   小さければ、そのままセット。
  //   大きければ、AddLargeItemを再帰呼び出し。
  if(min_item->value >= new_item->value){
    min_item->small = new_item;
    new_item->large = min_item;
  }else{
    AddLargeItem(min_item, new_item);
  }

  return 0;
}

//------------------------------------------------------------------------------
// 数値配列をソート
//   SortValues  : ソート対象の数値配列
//   max_size    : ソート対象の配列数
//   SortedValues: ソート結果の配列(max_sizeと同じサイズが確保されている前提)
//------------------------------------------------------------------------------
int Sort(int *SortValues, int max_size, int *SortedValues){
  int i;
  SortItem sort_items;
  sort_items.value = SortValues[0];
  sort_items.small  = NULL;
  sort_items.large  = NULL;

  // ソート用の構造体を作成
  for(i=1; i < max_size; i++){
    AddValue(&sort_items, SortValues[i]);
  }

  // 最小Itemを検索
  SortItem *min_item;
  min_item = GetMinItem(&sort_items);

  // 最小Itemから順に、構造体をたぐり、ソート結果配列を生成
  SortItem *now_item;
  now_item = min_item;
  for(i=0; i < max_size; i++){
    SortedValues[i] = now_item->value;
    now_item = now_item->large;
  }
}

int QsortCompareInt(const void *a, const void *b){
  int aNum = *(int*)a;
  int bNum = *(int*)b;
  return aNum - bNum;
}

int main(){
//  int SortValues[] = {10,20,3,4,120,6,8,20,50,19,1};
//  int max_size = sizeof(SortValues)/sizeof(int);
//  int SortedValues[max_size];

  int max_size = 20;            // ソート対象の数
  int SortValues[max_size];     // ソート対象
  int SortedValues[max_size];   // ソート結果
  int i;

  // ソート対象の数値の生成
  srand(time(NULL));            // 乱数初期化
  for(i=0; i < max_size; i++){
    SortValues[i] = rand() % 100;   // 100以内にしとく
  }

  // ソート実行
  Sort(SortValues, max_size, SortedValues);

  // ソート結果表示
  printf("before:");
  for(i=0; i < max_size; i++){
    printf("%3d,",SortValues[i]);
  }
  printf("\n");
  printf("after :");
  for(i=0; i < max_size; i++){
    printf("%3d,",SortedValues[i]);
  }
  printf("\n");

  // 検算
  int sort_result = 0;
  qsort(SortValues, max_size, sizeof(int), QsortCompareInt);
  printf("qsort :");
  for(i=0; i < max_size; i++){
    printf("%3d,",SortValues[i]);
    if(SortValues[i] != SortedValues[i]){
      sort_result ++;
    }
  }
  printf("\n");
  if(sort_result > 0){
    printf("sort result unmatch!!!\n");
  }

  return sort_result;
}

