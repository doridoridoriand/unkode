#include <stdio.h>

int main()
{
        int i,j;
        double T[100][1000];

        FILE *output;
        output=fopen("netudendo.txt","w");

        for(i=0;i<100;i++) {
                T[i][0]=100.0;                  //初期値として全体の温度を100とする
        }

        for(j=0;j<1000;j++) {
                T[0][j]=0.0;                    //境界条件として両端の温度を0とする
                T[100-1][j]=0.0;
        }

        for(j=0;j<(1000-1);j++) {
                for(i=1;i<(100-1);i++) {
                        T[i][j+1]=T[i][j]+0.5*(T[i+1][j]+T[i-1][j]-2*T[i][j]);
                }
        }

        for(i=0;i<100;i++) {
                for(j=0;j<1000;j++) {
                        fprintf(output,"%d %d %f\n",i,j,T[i][j]);
                }
                fprintf(output,"\n");
        }

        fclose(output);

        return 0;
}

