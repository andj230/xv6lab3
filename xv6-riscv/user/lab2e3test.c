
#include "user/user.h"

int
main(int argc, char **argv)
{

// If there is no arguments print this scripts process priority information for testing. 
 if(argc == 1){
        int pid = getpid();
        int priority = get_priority(pid);
        if(priority < 0){
            fprintf(2, "Error: could not get priority of this process.\n");
            exit(1);
        }
        printf("Priority level of this process is %d.\n", priority);
        set_priority(pid, 10);
        printf("New priority level is %d.\n", get_priority(pid));
    }

// If there is an argument assume its a process id and print out priority.
else if(argc == 2){
        int pid = atoi(argv[1]);
        int priority = get_priority(pid);
        if(priority < 0){
            fprintf(2, "Error: could not get priority of PID %d.\n", pid);
            exit(1);
        }
        printf("Priority level of PID %d is %d.\n", pid, priority);
    }

// Change Pid to priority 
else if(argc == 3){
        int pid = atoi(argv[1]);
        int new_priority = atoi(argv[2]);
        int old_priority = get_priority(pid);
        if(old_priority < 0){
            fprintf(2, "Error: could not get priority of PID %d.\n", pid);
            exit(1);
        }
        printf("Previous Priority level of PID %d is %d.\n", pid, old_priority);
        set_priority(pid, new_priority);
        printf("New priority level is %d.\n", get_priority(pid));
    }
    
exit(0);
}