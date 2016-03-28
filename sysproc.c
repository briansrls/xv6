#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// Halt (shutdown) the system by sending a special
// signal to QEMU.
// Based on: http://pdos.csail.mit.edu/6.828/2012/homework/xv6-syscall.html
// and: https://github.com/t3rm1n4l/pintos/blob/master/devices/shutdown.c
int
sys_halt(void)
{
  char *p = "Shutdown";
  for( ; *p; p++)
    outw(0xB004, 0x2000);
  return 0;
}


int sys_register_signal_handler(void)
{

  int signum; // The number that represents the signal
  int sighandler; // The number that represents the handler
  int trampoline;// This represents the trampoline function

  if(argint(0, &signum) < 0) return -1; // Get the first argument
  if(argint(1, &sighandler) < 0) return -1; // Get the second argument
  if(argint(2, &trampoline) < 0) return -1; // Get the third argument

  proc->handlers[signum] = sighandler; // Set the handler for the specific signal
  proc->trampoline = trampoline;

  return sighandler; // Return the signal handler

  //return 0;
}

int sys_alarm(void)
{

  int seconds; // THe number of seconds for the timer
  if(argint(0, &seconds) < 0) return -1; // Get the first argument

  proc->numberOfTicks = seconds; // Get the number of seconds and put it in the proc
  proc->alarmState = 0; // Set the alarm state to needed, but off
  
  return 0;
}
