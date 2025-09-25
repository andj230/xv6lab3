/* Lab 3 - Miles Taylor */
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc < 3){
      printf("Usage: nice <pid> <priority>\n");
      exit(1);
  }

  int pid = atoi(argv[1]);
  int priority = atoi(argv[2]);

  if(set_priority(pid, priority) < 0){
    printf("Failed to set priority for pid %d\n", pid);
  }
  else {
    printf("Setting priority of pid %d to %d\n", pid, priority);
  }

  int current = get_priority(pid);
  if(current < 0){
    printf("Failed to get priority for pid %d\n", pid);
  }
  else {
    printf("Priority of pid %d is %d\n", pid, current);
  }

  exit(0);
}