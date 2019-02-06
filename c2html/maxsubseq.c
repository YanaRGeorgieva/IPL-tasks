#include<iostream>
#include<stdio.h>
using namespace std;
int n, a[1000001], ans = 0;
void in()
{ scanf("%d", &n);
  for (int i = 0; i < n; i++)
    scanf("%d", &a[i]);
}

void solve()
{ int s = 0;
  for(int i = 0; i < n; i++)
  { s += a[i];
    
    if (s < 0)
      s = 0;
    
    if(s > ans)
      ans = s;
  }
  printf("%d\n", ans);
}

int main()
{ 
  in();
  solve();
  
  return 0;
}
