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
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;
  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
 // myproc()->sz+=n;
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
    if(myproc()->killed){
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
int
sys_mydate(void)
{
   struct rtcdate* r;
   if(argptr(0,(void*)&r, sizeof(*r) ) <0 )
      return -1;
  cmostime(r) ;   
  //r->day=2;
 // r->hour=4;
  return 0;
}


// System call for printing Page Table
int
sys_mypgtPrint(void)
{
  pde_t *pgdir = myproc()->pgdir;
  pde_t *pde;
  pte_t *pagetable;
  

  uint i, j, k;
  j = 0;
 

  for (i = 0; i < NPDENTRIES; i++)
  {
    pde=&pgdir[i];
    if (*pde & PTE_P)
    {
      if (*pde & PTE_U)
      {
        pagetable = (pte_t *)P2V(PTE_ADDR(*pde));
        for (k = 0; k < NPTENTRIES; k++)
        {
          pte_t pte = pagetable[k];
          if (pte & PTE_P)
          {
            if (pte & PTE_U)
            {
              cprintf("Pgdir entrynum: %d, Entry number: %d, Virtual address: %p, Physical address: %p\n",i, j,P2V(pte), pte);
              j++;
            }
          }
        }
      }
    }
  }
  return 0;
}

