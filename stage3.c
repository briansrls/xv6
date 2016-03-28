#include "types.h"
#include "stat.h"
#include "user.h"
#include "signal.h"

static int count = 0;

void handle_signal(siginfo_t info)
{	
	count++;
	if(count>=100000){
	int* ptr = &(info.signum);
	int i;
	for(i=0; i<5; i++){
	ptr+= (int)sizeof(&ptr)/4;
	}
	//printf(1, "Size of element: %d\n", (int)sizeof(&info.signum)*10);
	(*ptr) += (int)sizeof(&ptr)/4;	
	}
		
}
int main(int argc, char *argv[])
{

	int time_init;
        int time_end;
        int time_total;
        int time_avg;
        int x = 5;
        int y = 0;
	
        time_init = uptime();
        signal(SIGFPE, handle_signal);
        x = x / y;
        time_end = uptime();
        time_total = time_end - time_init;
        //this is in mticks, where one tick is 10^-6 mticks.
	time_avg = time_total*10;

        printf(1, "Traps Performed: %d\n", 100000);
        printf(1, "Total Elapsed Time: %d\n", time_total);
        printf(1, "Average Time Per Trap: %d\n", time_avg);

        exit();

}
