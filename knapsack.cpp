#include <iostream>
#include<algorithm>
using namespace std;
struct Item{
  double p,w,pDivw;  
};
bool cmp(Item x ,Item y){
    return x.pDivw>y.pDivw;
}
void display(Item a[],int n){
    cout<<"\nItem no."<<"\nProfit"<<"\nWeight"<<"P/W"<<endl;
    for(int i=0;i<=n-1;i++){
        cout<<"Item"<<i+1<<"\t"<<a[i].p<<"\t"<<a[i].w<<"\t"<<a[i].pDivw<<endl;
    }
}
double knapsack(Item a[],int n,int m){
	int i;
	double x[n]={0.0},remainingW=m,totprofit=0.0;
	for(i=0;i<=n-1;i++){
		if(a[i].w>remainingW)break;
		x[i]=1;
		totprofit+=a[i].p;
		remainingW=remainingW-a[i].w;
	}
	if(remainingW!=0){
		x[i]=remainingW/a[i].w;
		totprofit+=x[i]*a[i].p;
	}
	return totprofit;
}
int main() {
	int n,m;
	cout<<"\nEnter no. of elements:";cin>>n;
	Item a[n];
	cout<<"\nEnter each item's profit and weight\n";
	for(int i=0;i<n;i++){
		cout<<"\nItem"<<i+1<<"\t";
		cin>>a[i].p>>a[i].w;
		a[i].pDivw=double(a[i].p/a[i].w);
	}
	cout<<"\nEnter capacity:";cin>>m;
	sort(a,a+n,cmp);
	display(a,n);
	cout<<"Maximum profit-> "<<knapsack(a,n,m);
    return 0;
}
