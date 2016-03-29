
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "iput test\n");
       6:	a1 2c 63 00 00       	mov    0x632c,%eax
       b:	c7 44 24 04 46 44 00 	movl   $0x4446,0x4(%esp)
      12:	00 
      13:	89 04 24             	mov    %eax,(%esp)
      16:	e8 4d 40 00 00       	call   4068 <printf>

  if(mkdir("iputdir") < 0){
      1b:	c7 04 24 51 44 00 00 	movl   $0x4451,(%esp)
      22:	e8 19 3f 00 00       	call   3f40 <mkdir>
      27:	85 c0                	test   %eax,%eax
      29:	79 1a                	jns    45 <iputtest+0x45>
    printf(stdout, "mkdir failed\n");
      2b:	a1 2c 63 00 00       	mov    0x632c,%eax
      30:	c7 44 24 04 59 44 00 	movl   $0x4459,0x4(%esp)
      37:	00 
      38:	89 04 24             	mov    %eax,(%esp)
      3b:	e8 28 40 00 00       	call   4068 <printf>
    exit();
      40:	e8 93 3e 00 00       	call   3ed8 <exit>
  }
  if(chdir("iputdir") < 0){
      45:	c7 04 24 51 44 00 00 	movl   $0x4451,(%esp)
      4c:	e8 f7 3e 00 00       	call   3f48 <chdir>
      51:	85 c0                	test   %eax,%eax
      53:	79 1a                	jns    6f <iputtest+0x6f>
    printf(stdout, "chdir iputdir failed\n");
      55:	a1 2c 63 00 00       	mov    0x632c,%eax
      5a:	c7 44 24 04 67 44 00 	movl   $0x4467,0x4(%esp)
      61:	00 
      62:	89 04 24             	mov    %eax,(%esp)
      65:	e8 fe 3f 00 00       	call   4068 <printf>
    exit();
      6a:	e8 69 3e 00 00       	call   3ed8 <exit>
  }
  if(unlink("../iputdir") < 0){
      6f:	c7 04 24 7d 44 00 00 	movl   $0x447d,(%esp)
      76:	e8 ad 3e 00 00       	call   3f28 <unlink>
      7b:	85 c0                	test   %eax,%eax
      7d:	79 1a                	jns    99 <iputtest+0x99>
    printf(stdout, "unlink ../iputdir failed\n");
      7f:	a1 2c 63 00 00       	mov    0x632c,%eax
      84:	c7 44 24 04 88 44 00 	movl   $0x4488,0x4(%esp)
      8b:	00 
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 d4 3f 00 00       	call   4068 <printf>
    exit();
      94:	e8 3f 3e 00 00       	call   3ed8 <exit>
  }
  if(chdir("/") < 0){
      99:	c7 04 24 a2 44 00 00 	movl   $0x44a2,(%esp)
      a0:	e8 a3 3e 00 00       	call   3f48 <chdir>
      a5:	85 c0                	test   %eax,%eax
      a7:	79 1a                	jns    c3 <iputtest+0xc3>
    printf(stdout, "chdir / failed\n");
      a9:	a1 2c 63 00 00       	mov    0x632c,%eax
      ae:	c7 44 24 04 a4 44 00 	movl   $0x44a4,0x4(%esp)
      b5:	00 
      b6:	89 04 24             	mov    %eax,(%esp)
      b9:	e8 aa 3f 00 00       	call   4068 <printf>
    exit();
      be:	e8 15 3e 00 00       	call   3ed8 <exit>
  }
  printf(stdout, "iput test ok\n");
      c3:	a1 2c 63 00 00       	mov    0x632c,%eax
      c8:	c7 44 24 04 b4 44 00 	movl   $0x44b4,0x4(%esp)
      cf:	00 
      d0:	89 04 24             	mov    %eax,(%esp)
      d3:	e8 90 3f 00 00       	call   4068 <printf>
}
      d8:	c9                   	leave  
      d9:	c3                   	ret    

000000da <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      da:	55                   	push   %ebp
      db:	89 e5                	mov    %esp,%ebp
      dd:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      e0:	a1 2c 63 00 00       	mov    0x632c,%eax
      e5:	c7 44 24 04 c2 44 00 	movl   $0x44c2,0x4(%esp)
      ec:	00 
      ed:	89 04 24             	mov    %eax,(%esp)
      f0:	e8 73 3f 00 00       	call   4068 <printf>

  pid = fork();
      f5:	e8 d6 3d 00 00       	call   3ed0 <fork>
      fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
      fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     101:	79 1a                	jns    11d <exitiputtest+0x43>
    printf(stdout, "fork failed\n");
     103:	a1 2c 63 00 00       	mov    0x632c,%eax
     108:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
     10f:	00 
     110:	89 04 24             	mov    %eax,(%esp)
     113:	e8 50 3f 00 00       	call   4068 <printf>
    exit();
     118:	e8 bb 3d 00 00       	call   3ed8 <exit>
  }
  if(pid == 0){
     11d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     121:	0f 85 83 00 00 00    	jne    1aa <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     127:	c7 04 24 51 44 00 00 	movl   $0x4451,(%esp)
     12e:	e8 0d 3e 00 00       	call   3f40 <mkdir>
     133:	85 c0                	test   %eax,%eax
     135:	79 1a                	jns    151 <exitiputtest+0x77>
      printf(stdout, "mkdir failed\n");
     137:	a1 2c 63 00 00       	mov    0x632c,%eax
     13c:	c7 44 24 04 59 44 00 	movl   $0x4459,0x4(%esp)
     143:	00 
     144:	89 04 24             	mov    %eax,(%esp)
     147:	e8 1c 3f 00 00       	call   4068 <printf>
      exit();
     14c:	e8 87 3d 00 00       	call   3ed8 <exit>
    }
    if(chdir("iputdir") < 0){
     151:	c7 04 24 51 44 00 00 	movl   $0x4451,(%esp)
     158:	e8 eb 3d 00 00       	call   3f48 <chdir>
     15d:	85 c0                	test   %eax,%eax
     15f:	79 1a                	jns    17b <exitiputtest+0xa1>
      printf(stdout, "child chdir failed\n");
     161:	a1 2c 63 00 00       	mov    0x632c,%eax
     166:	c7 44 24 04 de 44 00 	movl   $0x44de,0x4(%esp)
     16d:	00 
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 f2 3e 00 00       	call   4068 <printf>
      exit();
     176:	e8 5d 3d 00 00       	call   3ed8 <exit>
    }
    if(unlink("../iputdir") < 0){
     17b:	c7 04 24 7d 44 00 00 	movl   $0x447d,(%esp)
     182:	e8 a1 3d 00 00       	call   3f28 <unlink>
     187:	85 c0                	test   %eax,%eax
     189:	79 1a                	jns    1a5 <exitiputtest+0xcb>
      printf(stdout, "unlink ../iputdir failed\n");
     18b:	a1 2c 63 00 00       	mov    0x632c,%eax
     190:	c7 44 24 04 88 44 00 	movl   $0x4488,0x4(%esp)
     197:	00 
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 c8 3e 00 00       	call   4068 <printf>
      exit();
     1a0:	e8 33 3d 00 00       	call   3ed8 <exit>
    }
    exit();
     1a5:	e8 2e 3d 00 00       	call   3ed8 <exit>
  }
  wait();
     1aa:	e8 31 3d 00 00       	call   3ee0 <wait>
  printf(stdout, "exitiput test ok\n");
     1af:	a1 2c 63 00 00       	mov    0x632c,%eax
     1b4:	c7 44 24 04 f2 44 00 	movl   $0x44f2,0x4(%esp)
     1bb:	00 
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 a4 3e 00 00       	call   4068 <printf>
}
     1c4:	c9                   	leave  
     1c5:	c3                   	ret    

000001c6 <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1c6:	55                   	push   %ebp
     1c7:	89 e5                	mov    %esp,%ebp
     1c9:	83 ec 28             	sub    $0x28,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1cc:	a1 2c 63 00 00       	mov    0x632c,%eax
     1d1:	c7 44 24 04 04 45 00 	movl   $0x4504,0x4(%esp)
     1d8:	00 
     1d9:	89 04 24             	mov    %eax,(%esp)
     1dc:	e8 87 3e 00 00       	call   4068 <printf>
  if(mkdir("oidir") < 0){
     1e1:	c7 04 24 13 45 00 00 	movl   $0x4513,(%esp)
     1e8:	e8 53 3d 00 00       	call   3f40 <mkdir>
     1ed:	85 c0                	test   %eax,%eax
     1ef:	79 1a                	jns    20b <openiputtest+0x45>
    printf(stdout, "mkdir oidir failed\n");
     1f1:	a1 2c 63 00 00       	mov    0x632c,%eax
     1f6:	c7 44 24 04 19 45 00 	movl   $0x4519,0x4(%esp)
     1fd:	00 
     1fe:	89 04 24             	mov    %eax,(%esp)
     201:	e8 62 3e 00 00       	call   4068 <printf>
    exit();
     206:	e8 cd 3c 00 00       	call   3ed8 <exit>
  }
  pid = fork();
     20b:	e8 c0 3c 00 00       	call   3ed0 <fork>
     210:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid < 0){
     213:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     217:	79 1a                	jns    233 <openiputtest+0x6d>
    printf(stdout, "fork failed\n");
     219:	a1 2c 63 00 00       	mov    0x632c,%eax
     21e:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
     225:	00 
     226:	89 04 24             	mov    %eax,(%esp)
     229:	e8 3a 3e 00 00       	call   4068 <printf>
    exit();
     22e:	e8 a5 3c 00 00       	call   3ed8 <exit>
  }
  if(pid == 0){
     233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     237:	75 3c                	jne    275 <openiputtest+0xaf>
    int fd = open("oidir", O_RDWR);
     239:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     240:	00 
     241:	c7 04 24 13 45 00 00 	movl   $0x4513,(%esp)
     248:	e8 cb 3c 00 00       	call   3f18 <open>
     24d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0){
     250:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     254:	78 1a                	js     270 <openiputtest+0xaa>
      printf(stdout, "open directory for write succeeded\n");
     256:	a1 2c 63 00 00       	mov    0x632c,%eax
     25b:	c7 44 24 04 30 45 00 	movl   $0x4530,0x4(%esp)
     262:	00 
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 fd 3d 00 00       	call   4068 <printf>
      exit();
     26b:	e8 68 3c 00 00       	call   3ed8 <exit>
    }
    exit();
     270:	e8 63 3c 00 00       	call   3ed8 <exit>
  }
  sleep(1);
     275:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     27c:	e8 e7 3c 00 00       	call   3f68 <sleep>
  if(unlink("oidir") != 0){
     281:	c7 04 24 13 45 00 00 	movl   $0x4513,(%esp)
     288:	e8 9b 3c 00 00       	call   3f28 <unlink>
     28d:	85 c0                	test   %eax,%eax
     28f:	74 1a                	je     2ab <openiputtest+0xe5>
    printf(stdout, "unlink failed\n");
     291:	a1 2c 63 00 00       	mov    0x632c,%eax
     296:	c7 44 24 04 54 45 00 	movl   $0x4554,0x4(%esp)
     29d:	00 
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 c2 3d 00 00       	call   4068 <printf>
    exit();
     2a6:	e8 2d 3c 00 00       	call   3ed8 <exit>
  }
  wait();
     2ab:	e8 30 3c 00 00       	call   3ee0 <wait>
  printf(stdout, "openiput test ok\n");
     2b0:	a1 2c 63 00 00       	mov    0x632c,%eax
     2b5:	c7 44 24 04 63 45 00 	movl   $0x4563,0x4(%esp)
     2bc:	00 
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 a3 3d 00 00       	call   4068 <printf>
}
     2c5:	c9                   	leave  
     2c6:	c3                   	ret    

000002c7 <opentest>:

// simple file system tests

void
opentest(void)
{
     2c7:	55                   	push   %ebp
     2c8:	89 e5                	mov    %esp,%ebp
     2ca:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(stdout, "open test\n");
     2cd:	a1 2c 63 00 00       	mov    0x632c,%eax
     2d2:	c7 44 24 04 75 45 00 	movl   $0x4575,0x4(%esp)
     2d9:	00 
     2da:	89 04 24             	mov    %eax,(%esp)
     2dd:	e8 86 3d 00 00       	call   4068 <printf>
  fd = open("echo", 0);
     2e2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     2e9:	00 
     2ea:	c7 04 24 30 44 00 00 	movl   $0x4430,(%esp)
     2f1:	e8 22 3c 00 00       	call   3f18 <open>
     2f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
     2f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     2fd:	79 1a                	jns    319 <opentest+0x52>
    printf(stdout, "open echo failed!\n");
     2ff:	a1 2c 63 00 00       	mov    0x632c,%eax
     304:	c7 44 24 04 80 45 00 	movl   $0x4580,0x4(%esp)
     30b:	00 
     30c:	89 04 24             	mov    %eax,(%esp)
     30f:	e8 54 3d 00 00       	call   4068 <printf>
    exit();
     314:	e8 bf 3b 00 00       	call   3ed8 <exit>
  }
  close(fd);
     319:	8b 45 f4             	mov    -0xc(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 dc 3b 00 00       	call   3f00 <close>
  fd = open("doesnotexist", 0);
     324:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     32b:	00 
     32c:	c7 04 24 93 45 00 00 	movl   $0x4593,(%esp)
     333:	e8 e0 3b 00 00       	call   3f18 <open>
     338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
     33b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     33f:	78 1a                	js     35b <opentest+0x94>
    printf(stdout, "open doesnotexist succeeded!\n");
     341:	a1 2c 63 00 00       	mov    0x632c,%eax
     346:	c7 44 24 04 a0 45 00 	movl   $0x45a0,0x4(%esp)
     34d:	00 
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 12 3d 00 00       	call   4068 <printf>
    exit();
     356:	e8 7d 3b 00 00       	call   3ed8 <exit>
  }
  printf(stdout, "open test ok\n");
     35b:	a1 2c 63 00 00       	mov    0x632c,%eax
     360:	c7 44 24 04 be 45 00 	movl   $0x45be,0x4(%esp)
     367:	00 
     368:	89 04 24             	mov    %eax,(%esp)
     36b:	e8 f8 3c 00 00       	call   4068 <printf>
}
     370:	c9                   	leave  
     371:	c3                   	ret    

00000372 <writetest>:

void
writetest(void)
{
     372:	55                   	push   %ebp
     373:	89 e5                	mov    %esp,%ebp
     375:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int i;

  printf(stdout, "small file test\n");
     378:	a1 2c 63 00 00       	mov    0x632c,%eax
     37d:	c7 44 24 04 cc 45 00 	movl   $0x45cc,0x4(%esp)
     384:	00 
     385:	89 04 24             	mov    %eax,(%esp)
     388:	e8 db 3c 00 00       	call   4068 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     38d:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     394:	00 
     395:	c7 04 24 dd 45 00 00 	movl   $0x45dd,(%esp)
     39c:	e8 77 3b 00 00       	call   3f18 <open>
     3a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     3a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3a8:	78 21                	js     3cb <writetest+0x59>
    printf(stdout, "creat small succeeded; ok\n");
     3aa:	a1 2c 63 00 00       	mov    0x632c,%eax
     3af:	c7 44 24 04 e3 45 00 	movl   $0x45e3,0x4(%esp)
     3b6:	00 
     3b7:	89 04 24             	mov    %eax,(%esp)
     3ba:	e8 a9 3c 00 00       	call   4068 <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     3bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     3c6:	e9 9f 00 00 00       	jmp    46a <writetest+0xf8>
  printf(stdout, "small file test\n");
  fd = open("small", O_CREATE|O_RDWR);
  if(fd >= 0){
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
     3cb:	a1 2c 63 00 00       	mov    0x632c,%eax
     3d0:	c7 44 24 04 fe 45 00 	movl   $0x45fe,0x4(%esp)
     3d7:	00 
     3d8:	89 04 24             	mov    %eax,(%esp)
     3db:	e8 88 3c 00 00       	call   4068 <printf>
    exit();
     3e0:	e8 f3 3a 00 00       	call   3ed8 <exit>
  }
  for(i = 0; i < 100; i++){
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3e5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     3ec:	00 
     3ed:	c7 44 24 04 1a 46 00 	movl   $0x461a,0x4(%esp)
     3f4:	00 
     3f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 f8 3a 00 00       	call   3ef8 <write>
     400:	83 f8 0a             	cmp    $0xa,%eax
     403:	74 21                	je     426 <writetest+0xb4>
      printf(stdout, "error: write aa %d new file failed\n", i);
     405:	a1 2c 63 00 00       	mov    0x632c,%eax
     40a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     40d:	89 54 24 08          	mov    %edx,0x8(%esp)
     411:	c7 44 24 04 28 46 00 	movl   $0x4628,0x4(%esp)
     418:	00 
     419:	89 04 24             	mov    %eax,(%esp)
     41c:	e8 47 3c 00 00       	call   4068 <printf>
      exit();
     421:	e8 b2 3a 00 00       	call   3ed8 <exit>
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     426:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     42d:	00 
     42e:	c7 44 24 04 4c 46 00 	movl   $0x464c,0x4(%esp)
     435:	00 
     436:	8b 45 f0             	mov    -0x10(%ebp),%eax
     439:	89 04 24             	mov    %eax,(%esp)
     43c:	e8 b7 3a 00 00       	call   3ef8 <write>
     441:	83 f8 0a             	cmp    $0xa,%eax
     444:	74 21                	je     467 <writetest+0xf5>
      printf(stdout, "error: write bb %d new file failed\n", i);
     446:	a1 2c 63 00 00       	mov    0x632c,%eax
     44b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44e:	89 54 24 08          	mov    %edx,0x8(%esp)
     452:	c7 44 24 04 58 46 00 	movl   $0x4658,0x4(%esp)
     459:	00 
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 06 3c 00 00       	call   4068 <printf>
      exit();
     462:	e8 71 3a 00 00       	call   3ed8 <exit>
    printf(stdout, "creat small succeeded; ok\n");
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     467:	ff 45 f4             	incl   -0xc(%ebp)
     46a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     46e:	0f 8e 71 ff ff ff    	jle    3e5 <writetest+0x73>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
      printf(stdout, "error: write bb %d new file failed\n", i);
      exit();
    }
  }
  printf(stdout, "writes ok\n");
     474:	a1 2c 63 00 00       	mov    0x632c,%eax
     479:	c7 44 24 04 7c 46 00 	movl   $0x467c,0x4(%esp)
     480:	00 
     481:	89 04 24             	mov    %eax,(%esp)
     484:	e8 df 3b 00 00       	call   4068 <printf>
  close(fd);
     489:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48c:	89 04 24             	mov    %eax,(%esp)
     48f:	e8 6c 3a 00 00       	call   3f00 <close>
  fd = open("small", O_RDONLY);
     494:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     49b:	00 
     49c:	c7 04 24 dd 45 00 00 	movl   $0x45dd,(%esp)
     4a3:	e8 70 3a 00 00       	call   3f18 <open>
     4a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd >= 0){
     4ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     4af:	78 3e                	js     4ef <writetest+0x17d>
    printf(stdout, "open small succeeded ok\n");
     4b1:	a1 2c 63 00 00       	mov    0x632c,%eax
     4b6:	c7 44 24 04 87 46 00 	movl   $0x4687,0x4(%esp)
     4bd:	00 
     4be:	89 04 24             	mov    %eax,(%esp)
     4c1:	e8 a2 3b 00 00       	call   4068 <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     4c6:	c7 44 24 08 d0 07 00 	movl   $0x7d0,0x8(%esp)
     4cd:	00 
     4ce:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
     4d5:	00 
     4d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4d9:	89 04 24             	mov    %eax,(%esp)
     4dc:	e8 0f 3a 00 00       	call   3ef0 <read>
     4e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(i == 2000){
     4e4:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
     4eb:	74 1c                	je     509 <writetest+0x197>
     4ed:	eb 4c                	jmp    53b <writetest+0x1c9>
  close(fd);
  fd = open("small", O_RDONLY);
  if(fd >= 0){
    printf(stdout, "open small succeeded ok\n");
  } else {
    printf(stdout, "error: open small failed!\n");
     4ef:	a1 2c 63 00 00       	mov    0x632c,%eax
     4f4:	c7 44 24 04 a0 46 00 	movl   $0x46a0,0x4(%esp)
     4fb:	00 
     4fc:	89 04 24             	mov    %eax,(%esp)
     4ff:	e8 64 3b 00 00       	call   4068 <printf>
    exit();
     504:	e8 cf 39 00 00       	call   3ed8 <exit>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
     509:	a1 2c 63 00 00       	mov    0x632c,%eax
     50e:	c7 44 24 04 bb 46 00 	movl   $0x46bb,0x4(%esp)
     515:	00 
     516:	89 04 24             	mov    %eax,(%esp)
     519:	e8 4a 3b 00 00       	call   4068 <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     51e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     521:	89 04 24             	mov    %eax,(%esp)
     524:	e8 d7 39 00 00       	call   3f00 <close>

  if(unlink("small") < 0){
     529:	c7 04 24 dd 45 00 00 	movl   $0x45dd,(%esp)
     530:	e8 f3 39 00 00       	call   3f28 <unlink>
     535:	85 c0                	test   %eax,%eax
     537:	78 1c                	js     555 <writetest+0x1e3>
     539:	eb 34                	jmp    56f <writetest+0x1fd>
  }
  i = read(fd, buf, 2000);
  if(i == 2000){
    printf(stdout, "read succeeded ok\n");
  } else {
    printf(stdout, "read failed\n");
     53b:	a1 2c 63 00 00       	mov    0x632c,%eax
     540:	c7 44 24 04 ce 46 00 	movl   $0x46ce,0x4(%esp)
     547:	00 
     548:	89 04 24             	mov    %eax,(%esp)
     54b:	e8 18 3b 00 00       	call   4068 <printf>
    exit();
     550:	e8 83 39 00 00       	call   3ed8 <exit>
  }
  close(fd);

  if(unlink("small") < 0){
    printf(stdout, "unlink small failed\n");
     555:	a1 2c 63 00 00       	mov    0x632c,%eax
     55a:	c7 44 24 04 db 46 00 	movl   $0x46db,0x4(%esp)
     561:	00 
     562:	89 04 24             	mov    %eax,(%esp)
     565:	e8 fe 3a 00 00       	call   4068 <printf>
    exit();
     56a:	e8 69 39 00 00       	call   3ed8 <exit>
  }
  printf(stdout, "small file test ok\n");
     56f:	a1 2c 63 00 00       	mov    0x632c,%eax
     574:	c7 44 24 04 f0 46 00 	movl   $0x46f0,0x4(%esp)
     57b:	00 
     57c:	89 04 24             	mov    %eax,(%esp)
     57f:	e8 e4 3a 00 00       	call   4068 <printf>
}
     584:	c9                   	leave  
     585:	c3                   	ret    

00000586 <writetest1>:

void
writetest1(void)
{
     586:	55                   	push   %ebp
     587:	89 e5                	mov    %esp,%ebp
     589:	83 ec 28             	sub    $0x28,%esp
  int i, fd, n;

  printf(stdout, "big files test\n");
     58c:	a1 2c 63 00 00       	mov    0x632c,%eax
     591:	c7 44 24 04 04 47 00 	movl   $0x4704,0x4(%esp)
     598:	00 
     599:	89 04 24             	mov    %eax,(%esp)
     59c:	e8 c7 3a 00 00       	call   4068 <printf>

  fd = open("big", O_CREATE|O_RDWR);
     5a1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     5a8:	00 
     5a9:	c7 04 24 14 47 00 00 	movl   $0x4714,(%esp)
     5b0:	e8 63 39 00 00       	call   3f18 <open>
     5b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     5b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     5bc:	79 1a                	jns    5d8 <writetest1+0x52>
    printf(stdout, "error: creat big failed!\n");
     5be:	a1 2c 63 00 00       	mov    0x632c,%eax
     5c3:	c7 44 24 04 18 47 00 	movl   $0x4718,0x4(%esp)
     5ca:	00 
     5cb:	89 04 24             	mov    %eax,(%esp)
     5ce:	e8 95 3a 00 00       	call   4068 <printf>
    exit();
     5d3:	e8 00 39 00 00       	call   3ed8 <exit>
  }

  for(i = 0; i < MAXFILE; i++){
     5d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     5df:	eb 50                	jmp    631 <writetest1+0xab>
    ((int*)buf)[0] = i;
     5e1:	b8 20 8b 00 00       	mov    $0x8b20,%eax
     5e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5e9:	89 10                	mov    %edx,(%eax)
    if(write(fd, buf, 512) != 512){
     5eb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     5f2:	00 
     5f3:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
     5fa:	00 
     5fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5fe:	89 04 24             	mov    %eax,(%esp)
     601:	e8 f2 38 00 00       	call   3ef8 <write>
     606:	3d 00 02 00 00       	cmp    $0x200,%eax
     60b:	74 21                	je     62e <writetest1+0xa8>
      printf(stdout, "error: write big file failed\n", i);
     60d:	a1 2c 63 00 00       	mov    0x632c,%eax
     612:	8b 55 f4             	mov    -0xc(%ebp),%edx
     615:	89 54 24 08          	mov    %edx,0x8(%esp)
     619:	c7 44 24 04 32 47 00 	movl   $0x4732,0x4(%esp)
     620:	00 
     621:	89 04 24             	mov    %eax,(%esp)
     624:	e8 3f 3a 00 00       	call   4068 <printf>
      exit();
     629:	e8 aa 38 00 00       	call   3ed8 <exit>
  if(fd < 0){
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     62e:	ff 45 f4             	incl   -0xc(%ebp)
     631:	8b 45 f4             	mov    -0xc(%ebp),%eax
     634:	3d 8b 00 00 00       	cmp    $0x8b,%eax
     639:	76 a6                	jbe    5e1 <writetest1+0x5b>
      printf(stdout, "error: write big file failed\n", i);
      exit();
    }
  }

  close(fd);
     63b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     63e:	89 04 24             	mov    %eax,(%esp)
     641:	e8 ba 38 00 00       	call   3f00 <close>

  fd = open("big", O_RDONLY);
     646:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     64d:	00 
     64e:	c7 04 24 14 47 00 00 	movl   $0x4714,(%esp)
     655:	e8 be 38 00 00       	call   3f18 <open>
     65a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     65d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     661:	79 1a                	jns    67d <writetest1+0xf7>
    printf(stdout, "error: open big failed!\n");
     663:	a1 2c 63 00 00       	mov    0x632c,%eax
     668:	c7 44 24 04 50 47 00 	movl   $0x4750,0x4(%esp)
     66f:	00 
     670:	89 04 24             	mov    %eax,(%esp)
     673:	e8 f0 39 00 00       	call   4068 <printf>
    exit();
     678:	e8 5b 38 00 00       	call   3ed8 <exit>
  }

  n = 0;
     67d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;){
    i = read(fd, buf, 512);
     684:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     68b:	00 
     68c:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
     693:	00 
     694:	8b 45 ec             	mov    -0x14(%ebp),%eax
     697:	89 04 24             	mov    %eax,(%esp)
     69a:	e8 51 38 00 00       	call   3ef0 <read>
     69f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(i == 0){
     6a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     6a6:	75 2e                	jne    6d6 <writetest1+0x150>
      if(n == MAXFILE - 1){
     6a8:	81 7d f0 8b 00 00 00 	cmpl   $0x8b,-0x10(%ebp)
     6af:	0f 85 8b 00 00 00    	jne    740 <writetest1+0x1ba>
        printf(stdout, "read only %d blocks from big", n);
     6b5:	a1 2c 63 00 00       	mov    0x632c,%eax
     6ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
     6bd:	89 54 24 08          	mov    %edx,0x8(%esp)
     6c1:	c7 44 24 04 69 47 00 	movl   $0x4769,0x4(%esp)
     6c8:	00 
     6c9:	89 04 24             	mov    %eax,(%esp)
     6cc:	e8 97 39 00 00       	call   4068 <printf>
        exit();
     6d1:	e8 02 38 00 00       	call   3ed8 <exit>
      }
      break;
    } else if(i != 512){
     6d6:	81 7d f4 00 02 00 00 	cmpl   $0x200,-0xc(%ebp)
     6dd:	74 21                	je     700 <writetest1+0x17a>
      printf(stdout, "read failed %d\n", i);
     6df:	a1 2c 63 00 00       	mov    0x632c,%eax
     6e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6e7:	89 54 24 08          	mov    %edx,0x8(%esp)
     6eb:	c7 44 24 04 86 47 00 	movl   $0x4786,0x4(%esp)
     6f2:	00 
     6f3:	89 04 24             	mov    %eax,(%esp)
     6f6:	e8 6d 39 00 00       	call   4068 <printf>
      exit();
     6fb:	e8 d8 37 00 00       	call   3ed8 <exit>
    }
    if(((int*)buf)[0] != n){
     700:	b8 20 8b 00 00       	mov    $0x8b20,%eax
     705:	8b 00                	mov    (%eax),%eax
     707:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     70a:	74 2c                	je     738 <writetest1+0x1b2>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
     70c:	b8 20 8b 00 00       	mov    $0x8b20,%eax
    } else if(i != 512){
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
      printf(stdout, "read content of block %d is %d\n",
     711:	8b 10                	mov    (%eax),%edx
     713:	a1 2c 63 00 00       	mov    0x632c,%eax
     718:	89 54 24 0c          	mov    %edx,0xc(%esp)
     71c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     71f:	89 54 24 08          	mov    %edx,0x8(%esp)
     723:	c7 44 24 04 98 47 00 	movl   $0x4798,0x4(%esp)
     72a:	00 
     72b:	89 04 24             	mov    %eax,(%esp)
     72e:	e8 35 39 00 00       	call   4068 <printf>
             n, ((int*)buf)[0]);
      exit();
     733:	e8 a0 37 00 00       	call   3ed8 <exit>
    }
    n++;
     738:	ff 45 f0             	incl   -0x10(%ebp)
  }
     73b:	e9 44 ff ff ff       	jmp    684 <writetest1+0xfe>
    if(i == 0){
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
     740:	90                   	nop
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
  }
  close(fd);
     741:	8b 45 ec             	mov    -0x14(%ebp),%eax
     744:	89 04 24             	mov    %eax,(%esp)
     747:	e8 b4 37 00 00       	call   3f00 <close>
  if(unlink("big") < 0){
     74c:	c7 04 24 14 47 00 00 	movl   $0x4714,(%esp)
     753:	e8 d0 37 00 00       	call   3f28 <unlink>
     758:	85 c0                	test   %eax,%eax
     75a:	79 1a                	jns    776 <writetest1+0x1f0>
    printf(stdout, "unlink big failed\n");
     75c:	a1 2c 63 00 00       	mov    0x632c,%eax
     761:	c7 44 24 04 b8 47 00 	movl   $0x47b8,0x4(%esp)
     768:	00 
     769:	89 04 24             	mov    %eax,(%esp)
     76c:	e8 f7 38 00 00       	call   4068 <printf>
    exit();
     771:	e8 62 37 00 00       	call   3ed8 <exit>
  }
  printf(stdout, "big files ok\n");
     776:	a1 2c 63 00 00       	mov    0x632c,%eax
     77b:	c7 44 24 04 cb 47 00 	movl   $0x47cb,0x4(%esp)
     782:	00 
     783:	89 04 24             	mov    %eax,(%esp)
     786:	e8 dd 38 00 00       	call   4068 <printf>
}
     78b:	c9                   	leave  
     78c:	c3                   	ret    

0000078d <createtest>:

void
createtest(void)
{
     78d:	55                   	push   %ebp
     78e:	89 e5                	mov    %esp,%ebp
     790:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     793:	a1 2c 63 00 00       	mov    0x632c,%eax
     798:	c7 44 24 04 dc 47 00 	movl   $0x47dc,0x4(%esp)
     79f:	00 
     7a0:	89 04 24             	mov    %eax,(%esp)
     7a3:	e8 c0 38 00 00       	call   4068 <printf>

  name[0] = 'a';
     7a8:	c6 05 20 ab 00 00 61 	movb   $0x61,0xab20
  name[2] = '\0';
     7af:	c6 05 22 ab 00 00 00 	movb   $0x0,0xab22
  for(i = 0; i < 52; i++){
     7b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     7bd:	eb 30                	jmp    7ef <createtest+0x62>
    name[1] = '0' + i;
     7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c2:	83 c0 30             	add    $0x30,%eax
     7c5:	a2 21 ab 00 00       	mov    %al,0xab21
    fd = open(name, O_CREATE|O_RDWR);
     7ca:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     7d1:	00 
     7d2:	c7 04 24 20 ab 00 00 	movl   $0xab20,(%esp)
     7d9:	e8 3a 37 00 00       	call   3f18 <open>
     7de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(fd);
     7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     7e4:	89 04 24             	mov    %eax,(%esp)
     7e7:	e8 14 37 00 00       	call   3f00 <close>

  printf(stdout, "many creates, followed by unlink test\n");

  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     7ec:	ff 45 f4             	incl   -0xc(%ebp)
     7ef:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     7f3:	7e ca                	jle    7bf <createtest+0x32>
    name[1] = '0' + i;
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
     7f5:	c6 05 20 ab 00 00 61 	movb   $0x61,0xab20
  name[2] = '\0';
     7fc:	c6 05 22 ab 00 00 00 	movb   $0x0,0xab22
  for(i = 0; i < 52; i++){
     803:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     80a:	eb 1a                	jmp    826 <createtest+0x99>
    name[1] = '0' + i;
     80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     80f:	83 c0 30             	add    $0x30,%eax
     812:	a2 21 ab 00 00       	mov    %al,0xab21
    unlink(name);
     817:	c7 04 24 20 ab 00 00 	movl   $0xab20,(%esp)
     81e:	e8 05 37 00 00       	call   3f28 <unlink>
    fd = open(name, O_CREATE|O_RDWR);
    close(fd);
  }
  name[0] = 'a';
  name[2] = '\0';
  for(i = 0; i < 52; i++){
     823:	ff 45 f4             	incl   -0xc(%ebp)
     826:	83 7d f4 33          	cmpl   $0x33,-0xc(%ebp)
     82a:	7e e0                	jle    80c <createtest+0x7f>
    name[1] = '0' + i;
    unlink(name);
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     82c:	a1 2c 63 00 00       	mov    0x632c,%eax
     831:	c7 44 24 04 04 48 00 	movl   $0x4804,0x4(%esp)
     838:	00 
     839:	89 04 24             	mov    %eax,(%esp)
     83c:	e8 27 38 00 00       	call   4068 <printf>
}
     841:	c9                   	leave  
     842:	c3                   	ret    

00000843 <dirtest>:

void dirtest(void)
{
     843:	55                   	push   %ebp
     844:	89 e5                	mov    %esp,%ebp
     846:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "mkdir test\n");
     849:	a1 2c 63 00 00       	mov    0x632c,%eax
     84e:	c7 44 24 04 2a 48 00 	movl   $0x482a,0x4(%esp)
     855:	00 
     856:	89 04 24             	mov    %eax,(%esp)
     859:	e8 0a 38 00 00       	call   4068 <printf>

  if(mkdir("dir0") < 0){
     85e:	c7 04 24 36 48 00 00 	movl   $0x4836,(%esp)
     865:	e8 d6 36 00 00       	call   3f40 <mkdir>
     86a:	85 c0                	test   %eax,%eax
     86c:	79 1a                	jns    888 <dirtest+0x45>
    printf(stdout, "mkdir failed\n");
     86e:	a1 2c 63 00 00       	mov    0x632c,%eax
     873:	c7 44 24 04 59 44 00 	movl   $0x4459,0x4(%esp)
     87a:	00 
     87b:	89 04 24             	mov    %eax,(%esp)
     87e:	e8 e5 37 00 00       	call   4068 <printf>
    exit();
     883:	e8 50 36 00 00       	call   3ed8 <exit>
  }

  if(chdir("dir0") < 0){
     888:	c7 04 24 36 48 00 00 	movl   $0x4836,(%esp)
     88f:	e8 b4 36 00 00       	call   3f48 <chdir>
     894:	85 c0                	test   %eax,%eax
     896:	79 1a                	jns    8b2 <dirtest+0x6f>
    printf(stdout, "chdir dir0 failed\n");
     898:	a1 2c 63 00 00       	mov    0x632c,%eax
     89d:	c7 44 24 04 3b 48 00 	movl   $0x483b,0x4(%esp)
     8a4:	00 
     8a5:	89 04 24             	mov    %eax,(%esp)
     8a8:	e8 bb 37 00 00       	call   4068 <printf>
    exit();
     8ad:	e8 26 36 00 00       	call   3ed8 <exit>
  }

  if(chdir("..") < 0){
     8b2:	c7 04 24 4e 48 00 00 	movl   $0x484e,(%esp)
     8b9:	e8 8a 36 00 00       	call   3f48 <chdir>
     8be:	85 c0                	test   %eax,%eax
     8c0:	79 1a                	jns    8dc <dirtest+0x99>
    printf(stdout, "chdir .. failed\n");
     8c2:	a1 2c 63 00 00       	mov    0x632c,%eax
     8c7:	c7 44 24 04 51 48 00 	movl   $0x4851,0x4(%esp)
     8ce:	00 
     8cf:	89 04 24             	mov    %eax,(%esp)
     8d2:	e8 91 37 00 00       	call   4068 <printf>
    exit();
     8d7:	e8 fc 35 00 00       	call   3ed8 <exit>
  }

  if(unlink("dir0") < 0){
     8dc:	c7 04 24 36 48 00 00 	movl   $0x4836,(%esp)
     8e3:	e8 40 36 00 00       	call   3f28 <unlink>
     8e8:	85 c0                	test   %eax,%eax
     8ea:	79 1a                	jns    906 <dirtest+0xc3>
    printf(stdout, "unlink dir0 failed\n");
     8ec:	a1 2c 63 00 00       	mov    0x632c,%eax
     8f1:	c7 44 24 04 62 48 00 	movl   $0x4862,0x4(%esp)
     8f8:	00 
     8f9:	89 04 24             	mov    %eax,(%esp)
     8fc:	e8 67 37 00 00       	call   4068 <printf>
    exit();
     901:	e8 d2 35 00 00       	call   3ed8 <exit>
  }
  printf(stdout, "mkdir test ok\n");
     906:	a1 2c 63 00 00       	mov    0x632c,%eax
     90b:	c7 44 24 04 76 48 00 	movl   $0x4876,0x4(%esp)
     912:	00 
     913:	89 04 24             	mov    %eax,(%esp)
     916:	e8 4d 37 00 00       	call   4068 <printf>
}
     91b:	c9                   	leave  
     91c:	c3                   	ret    

0000091d <exectest>:

void
exectest(void)
{
     91d:	55                   	push   %ebp
     91e:	89 e5                	mov    %esp,%ebp
     920:	83 ec 18             	sub    $0x18,%esp
  printf(stdout, "exec test\n");
     923:	a1 2c 63 00 00       	mov    0x632c,%eax
     928:	c7 44 24 04 85 48 00 	movl   $0x4885,0x4(%esp)
     92f:	00 
     930:	89 04 24             	mov    %eax,(%esp)
     933:	e8 30 37 00 00       	call   4068 <printf>
  if(exec("echo", echoargv) < 0){
     938:	c7 44 24 04 18 63 00 	movl   $0x6318,0x4(%esp)
     93f:	00 
     940:	c7 04 24 30 44 00 00 	movl   $0x4430,(%esp)
     947:	e8 c4 35 00 00       	call   3f10 <exec>
     94c:	85 c0                	test   %eax,%eax
     94e:	79 1a                	jns    96a <exectest+0x4d>
    printf(stdout, "exec echo failed\n");
     950:	a1 2c 63 00 00       	mov    0x632c,%eax
     955:	c7 44 24 04 90 48 00 	movl   $0x4890,0x4(%esp)
     95c:	00 
     95d:	89 04 24             	mov    %eax,(%esp)
     960:	e8 03 37 00 00       	call   4068 <printf>
    exit();
     965:	e8 6e 35 00 00       	call   3ed8 <exit>
  }
}
     96a:	c9                   	leave  
     96b:	c3                   	ret    

0000096c <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     96c:	55                   	push   %ebp
     96d:	89 e5                	mov    %esp,%ebp
     96f:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     972:	8d 45 d8             	lea    -0x28(%ebp),%eax
     975:	89 04 24             	mov    %eax,(%esp)
     978:	e8 6b 35 00 00       	call   3ee8 <pipe>
     97d:	85 c0                	test   %eax,%eax
     97f:	74 19                	je     99a <pipe1+0x2e>
    printf(1, "pipe() failed\n");
     981:	c7 44 24 04 a2 48 00 	movl   $0x48a2,0x4(%esp)
     988:	00 
     989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     990:	e8 d3 36 00 00       	call   4068 <printf>
    exit();
     995:	e8 3e 35 00 00       	call   3ed8 <exit>
  }
  pid = fork();
     99a:	e8 31 35 00 00       	call   3ed0 <fork>
     99f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  seq = 0;
     9a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  if(pid == 0){
     9a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     9ad:	0f 85 83 00 00 00    	jne    a36 <pipe1+0xca>
    close(fds[0]);
     9b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
     9b6:	89 04 24             	mov    %eax,(%esp)
     9b9:	e8 42 35 00 00       	call   3f00 <close>
    for(n = 0; n < 5; n++){
     9be:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     9c5:	eb 64                	jmp    a2b <pipe1+0xbf>
      for(i = 0; i < 1033; i++)
     9c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     9ce:	eb 14                	jmp    9e4 <pipe1+0x78>
        buf[i] = seq++;
     9d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
     9d6:	81 c2 20 8b 00 00    	add    $0x8b20,%edx
     9dc:	88 02                	mov    %al,(%edx)
     9de:	ff 45 f4             	incl   -0xc(%ebp)
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
      for(i = 0; i < 1033; i++)
     9e1:	ff 45 f0             	incl   -0x10(%ebp)
     9e4:	81 7d f0 08 04 00 00 	cmpl   $0x408,-0x10(%ebp)
     9eb:	7e e3                	jle    9d0 <pipe1+0x64>
        buf[i] = seq++;
      if(write(fds[1], buf, 1033) != 1033){
     9ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9f0:	c7 44 24 08 09 04 00 	movl   $0x409,0x8(%esp)
     9f7:	00 
     9f8:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
     9ff:	00 
     a00:	89 04 24             	mov    %eax,(%esp)
     a03:	e8 f0 34 00 00       	call   3ef8 <write>
     a08:	3d 09 04 00 00       	cmp    $0x409,%eax
     a0d:	74 19                	je     a28 <pipe1+0xbc>
        printf(1, "pipe1 oops 1\n");
     a0f:	c7 44 24 04 b1 48 00 	movl   $0x48b1,0x4(%esp)
     a16:	00 
     a17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a1e:	e8 45 36 00 00       	call   4068 <printf>
        exit();
     a23:	e8 b0 34 00 00       	call   3ed8 <exit>
  }
  pid = fork();
  seq = 0;
  if(pid == 0){
    close(fds[0]);
    for(n = 0; n < 5; n++){
     a28:	ff 45 ec             	incl   -0x14(%ebp)
     a2b:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
     a2f:	7e 96                	jle    9c7 <pipe1+0x5b>
      if(write(fds[1], buf, 1033) != 1033){
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
     a31:	e8 a2 34 00 00       	call   3ed8 <exit>
  } else if(pid > 0){
     a36:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     a3a:	0f 8e f9 00 00 00    	jle    b39 <pipe1+0x1cd>
    close(fds[1]);
     a40:	8b 45 dc             	mov    -0x24(%ebp),%eax
     a43:	89 04 24             	mov    %eax,(%esp)
     a46:	e8 b5 34 00 00       	call   3f00 <close>
    total = 0;
     a4b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    cc = 1;
     a52:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a59:	eb 68                	jmp    ac3 <pipe1+0x157>
      for(i = 0; i < n; i++){
     a5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     a62:	eb 3d                	jmp    aa1 <pipe1+0x135>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a67:	05 20 8b 00 00       	add    $0x8b20,%eax
     a6c:	8a 00                	mov    (%eax),%al
     a6e:	0f be c0             	movsbl %al,%eax
     a71:	33 45 f4             	xor    -0xc(%ebp),%eax
     a74:	25 ff 00 00 00       	and    $0xff,%eax
     a79:	85 c0                	test   %eax,%eax
     a7b:	0f 95 c0             	setne  %al
     a7e:	ff 45 f4             	incl   -0xc(%ebp)
     a81:	84 c0                	test   %al,%al
     a83:	74 19                	je     a9e <pipe1+0x132>
          printf(1, "pipe1 oops 2\n");
     a85:	c7 44 24 04 bf 48 00 	movl   $0x48bf,0x4(%esp)
     a8c:	00 
     a8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a94:	e8 cf 35 00 00       	call   4068 <printf>
     a99:	e9 b4 00 00 00       	jmp    b52 <pipe1+0x1e6>
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
      for(i = 0; i < n; i++){
     a9e:	ff 45 f0             	incl   -0x10(%ebp)
     aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     aa4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     aa7:	7c bb                	jl     a64 <pipe1+0xf8>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
          printf(1, "pipe1 oops 2\n");
          return;
        }
      }
      total += n;
     aa9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     aac:	01 45 e4             	add    %eax,-0x1c(%ebp)
      cc = cc * 2;
     aaf:	d1 65 e8             	shll   -0x18(%ebp)
      if(cc > sizeof(buf))
     ab2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ab5:	3d 00 20 00 00       	cmp    $0x2000,%eax
     aba:	76 07                	jbe    ac3 <pipe1+0x157>
        cc = sizeof(buf);
     abc:	c7 45 e8 00 20 00 00 	movl   $0x2000,-0x18(%ebp)
    exit();
  } else if(pid > 0){
    close(fds[1]);
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     ac3:	8b 45 d8             	mov    -0x28(%ebp),%eax
     ac6:	8b 55 e8             	mov    -0x18(%ebp),%edx
     ac9:	89 54 24 08          	mov    %edx,0x8(%esp)
     acd:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
     ad4:	00 
     ad5:	89 04 24             	mov    %eax,(%esp)
     ad8:	e8 13 34 00 00       	call   3ef0 <read>
     add:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ae0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ae4:	0f 8f 71 ff ff ff    	jg     a5b <pipe1+0xef>
      total += n;
      cc = cc * 2;
      if(cc > sizeof(buf))
        cc = sizeof(buf);
    }
    if(total != 5 * 1033){
     aea:	81 7d e4 2d 14 00 00 	cmpl   $0x142d,-0x1c(%ebp)
     af1:	74 20                	je     b13 <pipe1+0x1a7>
      printf(1, "pipe1 oops 3 total %d\n", total);
     af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     af6:	89 44 24 08          	mov    %eax,0x8(%esp)
     afa:	c7 44 24 04 cd 48 00 	movl   $0x48cd,0x4(%esp)
     b01:	00 
     b02:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b09:	e8 5a 35 00 00       	call   4068 <printf>
      exit();
     b0e:	e8 c5 33 00 00       	call   3ed8 <exit>
    }
    close(fds[0]);
     b13:	8b 45 d8             	mov    -0x28(%ebp),%eax
     b16:	89 04 24             	mov    %eax,(%esp)
     b19:	e8 e2 33 00 00       	call   3f00 <close>
    wait();
     b1e:	e8 bd 33 00 00       	call   3ee0 <wait>
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
     b23:	c7 44 24 04 e4 48 00 	movl   $0x48e4,0x4(%esp)
     b2a:	00 
     b2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b32:	e8 31 35 00 00       	call   4068 <printf>
     b37:	eb 19                	jmp    b52 <pipe1+0x1e6>
      exit();
    }
    close(fds[0]);
    wait();
  } else {
    printf(1, "fork() failed\n");
     b39:	c7 44 24 04 ee 48 00 	movl   $0x48ee,0x4(%esp)
     b40:	00 
     b41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b48:	e8 1b 35 00 00       	call   4068 <printf>
    exit();
     b4d:	e8 86 33 00 00       	call   3ed8 <exit>
  }
  printf(1, "pipe1 ok\n");
}
     b52:	c9                   	leave  
     b53:	c3                   	ret    

00000b54 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     b54:	55                   	push   %ebp
     b55:	89 e5                	mov    %esp,%ebp
     b57:	83 ec 38             	sub    $0x38,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     b5a:	c7 44 24 04 fd 48 00 	movl   $0x48fd,0x4(%esp)
     b61:	00 
     b62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     b69:	e8 fa 34 00 00       	call   4068 <printf>
  pid1 = fork();
     b6e:	e8 5d 33 00 00       	call   3ed0 <fork>
     b73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid1 == 0)
     b76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     b7a:	75 02                	jne    b7e <preempt+0x2a>
    for(;;)
      ;
     b7c:	eb fe                	jmp    b7c <preempt+0x28>

  pid2 = fork();
     b7e:	e8 4d 33 00 00       	call   3ed0 <fork>
     b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid2 == 0)
     b86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b8a:	75 02                	jne    b8e <preempt+0x3a>
    for(;;)
      ;
     b8c:	eb fe                	jmp    b8c <preempt+0x38>

  pipe(pfds);
     b8e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b91:	89 04 24             	mov    %eax,(%esp)
     b94:	e8 4f 33 00 00       	call   3ee8 <pipe>
  pid3 = fork();
     b99:	e8 32 33 00 00       	call   3ed0 <fork>
     b9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid3 == 0){
     ba1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ba5:	75 4c                	jne    bf3 <preempt+0x9f>
    close(pfds[0]);
     ba7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     baa:	89 04 24             	mov    %eax,(%esp)
     bad:	e8 4e 33 00 00       	call   3f00 <close>
    if(write(pfds[1], "x", 1) != 1)
     bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bb5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bbc:	00 
     bbd:	c7 44 24 04 07 49 00 	movl   $0x4907,0x4(%esp)
     bc4:	00 
     bc5:	89 04 24             	mov    %eax,(%esp)
     bc8:	e8 2b 33 00 00       	call   3ef8 <write>
     bcd:	83 f8 01             	cmp    $0x1,%eax
     bd0:	74 14                	je     be6 <preempt+0x92>
      printf(1, "preempt write error");
     bd2:	c7 44 24 04 09 49 00 	movl   $0x4909,0x4(%esp)
     bd9:	00 
     bda:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     be1:	e8 82 34 00 00       	call   4068 <printf>
    close(pfds[1]);
     be6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     be9:	89 04 24             	mov    %eax,(%esp)
     bec:	e8 0f 33 00 00       	call   3f00 <close>
    for(;;)
      ;
     bf1:	eb fe                	jmp    bf1 <preempt+0x9d>
  }

  close(pfds[1]);
     bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
     bf6:	89 04 24             	mov    %eax,(%esp)
     bf9:	e8 02 33 00 00       	call   3f00 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c01:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
     c08:	00 
     c09:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
     c10:	00 
     c11:	89 04 24             	mov    %eax,(%esp)
     c14:	e8 d7 32 00 00       	call   3ef0 <read>
     c19:	83 f8 01             	cmp    $0x1,%eax
     c1c:	74 16                	je     c34 <preempt+0xe0>
    printf(1, "preempt read error");
     c1e:	c7 44 24 04 1d 49 00 	movl   $0x491d,0x4(%esp)
     c25:	00 
     c26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c2d:	e8 36 34 00 00       	call   4068 <printf>
     c32:	eb 77                	jmp    cab <preempt+0x157>
    return;
  }
  close(pfds[0]);
     c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     c37:	89 04 24             	mov    %eax,(%esp)
     c3a:	e8 c1 32 00 00       	call   3f00 <close>
  printf(1, "kill... ");
     c3f:	c7 44 24 04 30 49 00 	movl   $0x4930,0x4(%esp)
     c46:	00 
     c47:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c4e:	e8 15 34 00 00       	call   4068 <printf>
  kill(pid1);
     c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c56:	89 04 24             	mov    %eax,(%esp)
     c59:	e8 aa 32 00 00       	call   3f08 <kill>
  kill(pid2);
     c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c61:	89 04 24             	mov    %eax,(%esp)
     c64:	e8 9f 32 00 00       	call   3f08 <kill>
  kill(pid3);
     c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c6c:	89 04 24             	mov    %eax,(%esp)
     c6f:	e8 94 32 00 00       	call   3f08 <kill>
  printf(1, "wait... ");
     c74:	c7 44 24 04 39 49 00 	movl   $0x4939,0x4(%esp)
     c7b:	00 
     c7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     c83:	e8 e0 33 00 00       	call   4068 <printf>
  wait();
     c88:	e8 53 32 00 00       	call   3ee0 <wait>
  wait();
     c8d:	e8 4e 32 00 00       	call   3ee0 <wait>
  wait();
     c92:	e8 49 32 00 00       	call   3ee0 <wait>
  printf(1, "preempt ok\n");
     c97:	c7 44 24 04 42 49 00 	movl   $0x4942,0x4(%esp)
     c9e:	00 
     c9f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ca6:	e8 bd 33 00 00       	call   4068 <printf>
}
     cab:	c9                   	leave  
     cac:	c3                   	ret    

00000cad <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     cad:	55                   	push   %ebp
     cae:	89 e5                	mov    %esp,%ebp
     cb0:	83 ec 28             	sub    $0x28,%esp
  int i, pid;

  for(i = 0; i < 100; i++){
     cb3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cba:	eb 52                	jmp    d0e <exitwait+0x61>
    pid = fork();
     cbc:	e8 0f 32 00 00       	call   3ed0 <fork>
     cc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0){
     cc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cc8:	79 16                	jns    ce0 <exitwait+0x33>
      printf(1, "fork failed\n");
     cca:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
     cd1:	00 
     cd2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cd9:	e8 8a 33 00 00       	call   4068 <printf>
      return;
     cde:	eb 48                	jmp    d28 <exitwait+0x7b>
    }
    if(pid){
     ce0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ce4:	74 20                	je     d06 <exitwait+0x59>
      if(wait() != pid){
     ce6:	e8 f5 31 00 00       	call   3ee0 <wait>
     ceb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     cee:	74 1b                	je     d0b <exitwait+0x5e>
        printf(1, "wait wrong pid\n");
     cf0:	c7 44 24 04 4e 49 00 	movl   $0x494e,0x4(%esp)
     cf7:	00 
     cf8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     cff:	e8 64 33 00 00       	call   4068 <printf>
        return;
     d04:	eb 22                	jmp    d28 <exitwait+0x7b>
      }
    } else {
      exit();
     d06:	e8 cd 31 00 00       	call   3ed8 <exit>
void
exitwait(void)
{
  int i, pid;

  for(i = 0; i < 100; i++){
     d0b:	ff 45 f4             	incl   -0xc(%ebp)
     d0e:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
     d12:	7e a8                	jle    cbc <exitwait+0xf>
      }
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
     d14:	c7 44 24 04 5e 49 00 	movl   $0x495e,0x4(%esp)
     d1b:	00 
     d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d23:	e8 40 33 00 00       	call   4068 <printf>
}
     d28:	c9                   	leave  
     d29:	c3                   	ret    

00000d2a <mem>:

void
mem(void)
{
     d2a:	55                   	push   %ebp
     d2b:	89 e5                	mov    %esp,%ebp
     d2d:	83 ec 28             	sub    $0x28,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     d30:	c7 44 24 04 6b 49 00 	movl   $0x496b,0x4(%esp)
     d37:	00 
     d38:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d3f:	e8 24 33 00 00       	call   4068 <printf>
  ppid = getpid();
     d44:	e8 0f 32 00 00       	call   3f58 <getpid>
     d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((pid = fork()) == 0){
     d4c:	e8 7f 31 00 00       	call   3ed0 <fork>
     d51:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d58:	0f 85 aa 00 00 00    	jne    e08 <mem+0xde>
    m1 = 0;
     d5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while((m2 = malloc(10001)) != 0){
     d65:	eb 0e                	jmp    d75 <mem+0x4b>
      *(char**)m2 = m1;
     d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d6d:	89 10                	mov    %edx,(%eax)
      m1 = m2;
     d6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d72:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "mem test\n");
  ppid = getpid();
  if((pid = fork()) == 0){
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
     d75:	c7 04 24 11 27 00 00 	movl   $0x2711,(%esp)
     d7c:	e8 d0 35 00 00       	call   4351 <malloc>
     d81:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d84:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d88:	75 dd                	jne    d67 <mem+0x3d>
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     d8a:	eb 19                	jmp    da5 <mem+0x7b>
      m2 = *(char**)m1;
     d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8f:	8b 00                	mov    (%eax),%eax
     d91:	89 45 e8             	mov    %eax,-0x18(%ebp)
      free(m1);
     d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d97:	89 04 24             	mov    %eax,(%esp)
     d9a:	e8 79 34 00 00       	call   4218 <free>
      m1 = m2;
     d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    m1 = 0;
    while((m2 = malloc(10001)) != 0){
      *(char**)m2 = m1;
      m1 = m2;
    }
    while(m1){
     da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     da9:	75 e1                	jne    d8c <mem+0x62>
      m2 = *(char**)m1;
      free(m1);
      m1 = m2;
    }
    m1 = malloc(1024*20);
     dab:	c7 04 24 00 50 00 00 	movl   $0x5000,(%esp)
     db2:	e8 9a 35 00 00       	call   4351 <malloc>
     db7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(m1 == 0){
     dba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     dbe:	75 24                	jne    de4 <mem+0xba>
      printf(1, "couldn't allocate mem?!!\n");
     dc0:	c7 44 24 04 75 49 00 	movl   $0x4975,0x4(%esp)
     dc7:	00 
     dc8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dcf:	e8 94 32 00 00       	call   4068 <printf>
      kill(ppid);
     dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     dd7:	89 04 24             	mov    %eax,(%esp)
     dda:	e8 29 31 00 00       	call   3f08 <kill>
      exit();
     ddf:	e8 f4 30 00 00       	call   3ed8 <exit>
    }
    free(m1);
     de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de7:	89 04 24             	mov    %eax,(%esp)
     dea:	e8 29 34 00 00       	call   4218 <free>
    printf(1, "mem ok\n");
     def:	c7 44 24 04 8f 49 00 	movl   $0x498f,0x4(%esp)
     df6:	00 
     df7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dfe:	e8 65 32 00 00       	call   4068 <printf>
    exit();
     e03:	e8 d0 30 00 00       	call   3ed8 <exit>
  } else {
    wait();
     e08:	e8 d3 30 00 00       	call   3ee0 <wait>
  }
}
     e0d:	c9                   	leave  
     e0e:	c3                   	ret    

00000e0f <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     e0f:	55                   	push   %ebp
     e10:	89 e5                	mov    %esp,%ebp
     e12:	83 ec 48             	sub    $0x48,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     e15:	c7 44 24 04 97 49 00 	movl   $0x4997,0x4(%esp)
     e1c:	00 
     e1d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e24:	e8 3f 32 00 00       	call   4068 <printf>

  unlink("sharedfd");
     e29:	c7 04 24 a6 49 00 00 	movl   $0x49a6,(%esp)
     e30:	e8 f3 30 00 00       	call   3f28 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e35:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
     e3c:	00 
     e3d:	c7 04 24 a6 49 00 00 	movl   $0x49a6,(%esp)
     e44:	e8 cf 30 00 00       	call   3f18 <open>
     e49:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     e4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e50:	79 19                	jns    e6b <sharedfd+0x5c>
    printf(1, "fstests: cannot open sharedfd for writing");
     e52:	c7 44 24 04 b0 49 00 	movl   $0x49b0,0x4(%esp)
     e59:	00 
     e5a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e61:	e8 02 32 00 00       	call   4068 <printf>
     e66:	e9 9a 01 00 00       	jmp    1005 <sharedfd+0x1f6>
    return;
  }
  pid = fork();
     e6b:	e8 60 30 00 00       	call   3ed0 <fork>
     e70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     e77:	75 07                	jne    e80 <sharedfd+0x71>
     e79:	b8 63 00 00 00       	mov    $0x63,%eax
     e7e:	eb 05                	jmp    e85 <sharedfd+0x76>
     e80:	b8 70 00 00 00       	mov    $0x70,%eax
     e85:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     e8c:	00 
     e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
     e91:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     e94:	89 04 24             	mov    %eax,(%esp)
     e97:	e8 74 2e 00 00       	call   3d10 <memset>
  for(i = 0; i < 1000; i++){
     e9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ea3:	eb 38                	jmp    edd <sharedfd+0xce>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     ea5:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     eac:	00 
     ead:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
     eb7:	89 04 24             	mov    %eax,(%esp)
     eba:	e8 39 30 00 00       	call   3ef8 <write>
     ebf:	83 f8 0a             	cmp    $0xa,%eax
     ec2:	74 16                	je     eda <sharedfd+0xcb>
      printf(1, "fstests: write sharedfd failed\n");
     ec4:	c7 44 24 04 dc 49 00 	movl   $0x49dc,0x4(%esp)
     ecb:	00 
     ecc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ed3:	e8 90 31 00 00       	call   4068 <printf>
      break;
     ed8:	eb 0c                	jmp    ee6 <sharedfd+0xd7>
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
  memset(buf, pid==0?'c':'p', sizeof(buf));
  for(i = 0; i < 1000; i++){
     eda:	ff 45 f4             	incl   -0xc(%ebp)
     edd:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
     ee4:	7e bf                	jle    ea5 <sharedfd+0x96>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
      printf(1, "fstests: write sharedfd failed\n");
      break;
    }
  }
  if(pid == 0)
     ee6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     eea:	75 05                	jne    ef1 <sharedfd+0xe2>
    exit();
     eec:	e8 e7 2f 00 00       	call   3ed8 <exit>
  else
    wait();
     ef1:	e8 ea 2f 00 00       	call   3ee0 <wait>
  close(fd);
     ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ef9:	89 04 24             	mov    %eax,(%esp)
     efc:	e8 ff 2f 00 00       	call   3f00 <close>
  fd = open("sharedfd", 0);
     f01:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f08:	00 
     f09:	c7 04 24 a6 49 00 00 	movl   $0x49a6,(%esp)
     f10:	e8 03 30 00 00       	call   3f18 <open>
     f15:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(fd < 0){
     f18:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     f1c:	79 19                	jns    f37 <sharedfd+0x128>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f1e:	c7 44 24 04 fc 49 00 	movl   $0x49fc,0x4(%esp)
     f25:	00 
     f26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f2d:	e8 36 31 00 00       	call   4068 <printf>
     f32:	e9 ce 00 00 00       	jmp    1005 <sharedfd+0x1f6>
    return;
  }
  nc = np = 0;
     f37:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f44:	eb 36                	jmp    f7c <sharedfd+0x16d>
    for(i = 0; i < sizeof(buf); i++){
     f46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     f4d:	eb 25                	jmp    f74 <sharedfd+0x165>
      if(buf[i] == 'c')
     f4f:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f55:	01 d0                	add    %edx,%eax
     f57:	8a 00                	mov    (%eax),%al
     f59:	3c 63                	cmp    $0x63,%al
     f5b:	75 03                	jne    f60 <sharedfd+0x151>
        nc++;
     f5d:	ff 45 f0             	incl   -0x10(%ebp)
      if(buf[i] == 'p')
     f60:	8d 55 d6             	lea    -0x2a(%ebp),%edx
     f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f66:	01 d0                	add    %edx,%eax
     f68:	8a 00                	mov    (%eax),%al
     f6a:	3c 70                	cmp    $0x70,%al
     f6c:	75 03                	jne    f71 <sharedfd+0x162>
        np++;
     f6e:	ff 45 ec             	incl   -0x14(%ebp)
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i = 0; i < sizeof(buf); i++){
     f71:	ff 45 f4             	incl   -0xc(%ebp)
     f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f77:	83 f8 09             	cmp    $0x9,%eax
     f7a:	76 d3                	jbe    f4f <sharedfd+0x140>
  if(fd < 0){
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f7c:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f83:	00 
     f84:	8d 45 d6             	lea    -0x2a(%ebp),%eax
     f87:	89 44 24 04          	mov    %eax,0x4(%esp)
     f8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f8e:	89 04 24             	mov    %eax,(%esp)
     f91:	e8 5a 2f 00 00       	call   3ef0 <read>
     f96:	89 45 e0             	mov    %eax,-0x20(%ebp)
     f99:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     f9d:	7f a7                	jg     f46 <sharedfd+0x137>
        nc++;
      if(buf[i] == 'p')
        np++;
    }
  }
  close(fd);
     f9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa2:	89 04 24             	mov    %eax,(%esp)
     fa5:	e8 56 2f 00 00       	call   3f00 <close>
  unlink("sharedfd");
     faa:	c7 04 24 a6 49 00 00 	movl   $0x49a6,(%esp)
     fb1:	e8 72 2f 00 00       	call   3f28 <unlink>
  if(nc == 10000 && np == 10000){
     fb6:	81 7d f0 10 27 00 00 	cmpl   $0x2710,-0x10(%ebp)
     fbd:	75 1f                	jne    fde <sharedfd+0x1cf>
     fbf:	81 7d ec 10 27 00 00 	cmpl   $0x2710,-0x14(%ebp)
     fc6:	75 16                	jne    fde <sharedfd+0x1cf>
    printf(1, "sharedfd ok\n");
     fc8:	c7 44 24 04 27 4a 00 	movl   $0x4a27,0x4(%esp)
     fcf:	00 
     fd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fd7:	e8 8c 30 00 00       	call   4068 <printf>
     fdc:	eb 27                	jmp    1005 <sharedfd+0x1f6>
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
     fde:	8b 45 ec             	mov    -0x14(%ebp),%eax
     fe1:	89 44 24 0c          	mov    %eax,0xc(%esp)
     fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fe8:	89 44 24 08          	mov    %eax,0x8(%esp)
     fec:	c7 44 24 04 34 4a 00 	movl   $0x4a34,0x4(%esp)
     ff3:	00 
     ff4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     ffb:	e8 68 30 00 00       	call   4068 <printf>
    exit();
    1000:	e8 d3 2e 00 00       	call   3ed8 <exit>
  }
}
    1005:	c9                   	leave  
    1006:	c3                   	ret    

00001007 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
    1007:	55                   	push   %ebp
    1008:	89 e5                	mov    %esp,%ebp
    100a:	57                   	push   %edi
    100b:	56                   	push   %esi
    100c:	53                   	push   %ebx
    100d:	83 ec 4c             	sub    $0x4c,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
    1010:	8d 55 b8             	lea    -0x48(%ebp),%edx
    1013:	bb b0 4a 00 00       	mov    $0x4ab0,%ebx
    1018:	b8 04 00 00 00       	mov    $0x4,%eax
    101d:	89 d7                	mov    %edx,%edi
    101f:	89 de                	mov    %ebx,%esi
    1021:	89 c1                	mov    %eax,%ecx
    1023:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  char *fname;

  printf(1, "fourfiles test\n");
    1025:	c7 44 24 04 49 4a 00 	movl   $0x4a49,0x4(%esp)
    102c:	00 
    102d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1034:	e8 2f 30 00 00       	call   4068 <printf>

  for(pi = 0; pi < 4; pi++){
    1039:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    1040:	e9 fa 00 00 00       	jmp    113f <fourfiles+0x138>
    fname = names[pi];
    1045:	8b 45 d8             	mov    -0x28(%ebp),%eax
    1048:	8b 44 85 b8          	mov    -0x48(%ebp,%eax,4),%eax
    104c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unlink(fname);
    104f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1052:	89 04 24             	mov    %eax,(%esp)
    1055:	e8 ce 2e 00 00       	call   3f28 <unlink>

    pid = fork();
    105a:	e8 71 2e 00 00       	call   3ed0 <fork>
    105f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    if(pid < 0){
    1062:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    1066:	79 19                	jns    1081 <fourfiles+0x7a>
      printf(1, "fork failed\n");
    1068:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    106f:	00 
    1070:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1077:	e8 ec 2f 00 00       	call   4068 <printf>
      exit();
    107c:	e8 57 2e 00 00       	call   3ed8 <exit>
    }

    if(pid == 0){
    1081:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
    1085:	0f 85 b1 00 00 00    	jne    113c <fourfiles+0x135>
      fd = open(fname, O_CREATE | O_RDWR);
    108b:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1092:	00 
    1093:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1096:	89 04 24             	mov    %eax,(%esp)
    1099:	e8 7a 2e 00 00       	call   3f18 <open>
    109e:	89 45 cc             	mov    %eax,-0x34(%ebp)
      if(fd < 0){
    10a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
    10a5:	79 19                	jns    10c0 <fourfiles+0xb9>
        printf(1, "create failed\n");
    10a7:	c7 44 24 04 59 4a 00 	movl   $0x4a59,0x4(%esp)
    10ae:	00 
    10af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    10b6:	e8 ad 2f 00 00       	call   4068 <printf>
        exit();
    10bb:	e8 18 2e 00 00       	call   3ed8 <exit>
      }
      
      memset(buf, '0'+pi, 512);
    10c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
    10c3:	83 c0 30             	add    $0x30,%eax
    10c6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    10cd:	00 
    10ce:	89 44 24 04          	mov    %eax,0x4(%esp)
    10d2:	c7 04 24 20 8b 00 00 	movl   $0x8b20,(%esp)
    10d9:	e8 32 2c 00 00       	call   3d10 <memset>
      for(i = 0; i < 12; i++){
    10de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    10e5:	eb 4a                	jmp    1131 <fourfiles+0x12a>
        if((n = write(fd, buf, 500)) != 500){
    10e7:	c7 44 24 08 f4 01 00 	movl   $0x1f4,0x8(%esp)
    10ee:	00 
    10ef:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    10f6:	00 
    10f7:	8b 45 cc             	mov    -0x34(%ebp),%eax
    10fa:	89 04 24             	mov    %eax,(%esp)
    10fd:	e8 f6 2d 00 00       	call   3ef8 <write>
    1102:	89 45 c8             	mov    %eax,-0x38(%ebp)
    1105:	81 7d c8 f4 01 00 00 	cmpl   $0x1f4,-0x38(%ebp)
    110c:	74 20                	je     112e <fourfiles+0x127>
          printf(1, "write failed %d\n", n);
    110e:	8b 45 c8             	mov    -0x38(%ebp),%eax
    1111:	89 44 24 08          	mov    %eax,0x8(%esp)
    1115:	c7 44 24 04 68 4a 00 	movl   $0x4a68,0x4(%esp)
    111c:	00 
    111d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1124:	e8 3f 2f 00 00       	call   4068 <printf>
          exit();
    1129:	e8 aa 2d 00 00       	call   3ed8 <exit>
        printf(1, "create failed\n");
        exit();
      }
      
      memset(buf, '0'+pi, 512);
      for(i = 0; i < 12; i++){
    112e:	ff 45 e4             	incl   -0x1c(%ebp)
    1131:	83 7d e4 0b          	cmpl   $0xb,-0x1c(%ebp)
    1135:	7e b0                	jle    10e7 <fourfiles+0xe0>
        if((n = write(fd, buf, 500)) != 500){
          printf(1, "write failed %d\n", n);
          exit();
        }
      }
      exit();
    1137:	e8 9c 2d 00 00       	call   3ed8 <exit>
  char *names[] = { "f0", "f1", "f2", "f3" };
  char *fname;

  printf(1, "fourfiles test\n");

  for(pi = 0; pi < 4; pi++){
    113c:	ff 45 d8             	incl   -0x28(%ebp)
    113f:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
    1143:	0f 8e fc fe ff ff    	jle    1045 <fourfiles+0x3e>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1149:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    1150:	eb 08                	jmp    115a <fourfiles+0x153>
    wait();
    1152:	e8 89 2d 00 00       	call   3ee0 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    1157:	ff 45 d8             	incl   -0x28(%ebp)
    115a:	83 7d d8 03          	cmpl   $0x3,-0x28(%ebp)
    115e:	7e f2                	jle    1152 <fourfiles+0x14b>
    wait();
  }

  for(i = 0; i < 2; i++){
    1160:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    1167:	e9 d9 00 00 00       	jmp    1245 <fourfiles+0x23e>
    fname = names[i];
    116c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    116f:	8b 44 85 b8          	mov    -0x48(%ebp,%eax,4),%eax
    1173:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    fd = open(fname, 0);
    1176:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    117d:	00 
    117e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    1181:	89 04 24             	mov    %eax,(%esp)
    1184:	e8 8f 2d 00 00       	call   3f18 <open>
    1189:	89 45 cc             	mov    %eax,-0x34(%ebp)
    total = 0;
    118c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1193:	eb 4a                	jmp    11df <fourfiles+0x1d8>
      for(j = 0; j < n; j++){
    1195:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
    119c:	eb 33                	jmp    11d1 <fourfiles+0x1ca>
        if(buf[j] != '0'+i){
    119e:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11a1:	05 20 8b 00 00       	add    $0x8b20,%eax
    11a6:	8a 00                	mov    (%eax),%al
    11a8:	0f be c0             	movsbl %al,%eax
    11ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    11ae:	83 c2 30             	add    $0x30,%edx
    11b1:	39 d0                	cmp    %edx,%eax
    11b3:	74 19                	je     11ce <fourfiles+0x1c7>
          printf(1, "wrong char\n");
    11b5:	c7 44 24 04 79 4a 00 	movl   $0x4a79,0x4(%esp)
    11bc:	00 
    11bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    11c4:	e8 9f 2e 00 00       	call   4068 <printf>
          exit();
    11c9:	e8 0a 2d 00 00       	call   3ed8 <exit>
  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
    11ce:	ff 45 e0             	incl   -0x20(%ebp)
    11d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
    11d4:	3b 45 c8             	cmp    -0x38(%ebp),%eax
    11d7:	7c c5                	jl     119e <fourfiles+0x197>
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
          exit();
        }
      }
      total += n;
    11d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
    11dc:	01 45 dc             	add    %eax,-0x24(%ebp)

  for(i = 0; i < 2; i++){
    fname = names[i];
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
    11df:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    11e6:	00 
    11e7:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    11ee:	00 
    11ef:	8b 45 cc             	mov    -0x34(%ebp),%eax
    11f2:	89 04 24             	mov    %eax,(%esp)
    11f5:	e8 f6 2c 00 00       	call   3ef0 <read>
    11fa:	89 45 c8             	mov    %eax,-0x38(%ebp)
    11fd:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
    1201:	7f 92                	jg     1195 <fourfiles+0x18e>
          exit();
        }
      }
      total += n;
    }
    close(fd);
    1203:	8b 45 cc             	mov    -0x34(%ebp),%eax
    1206:	89 04 24             	mov    %eax,(%esp)
    1209:	e8 f2 2c 00 00       	call   3f00 <close>
    if(total != 12*500){
    120e:	81 7d dc 70 17 00 00 	cmpl   $0x1770,-0x24(%ebp)
    1215:	74 20                	je     1237 <fourfiles+0x230>
      printf(1, "wrong length %d\n", total);
    1217:	8b 45 dc             	mov    -0x24(%ebp),%eax
    121a:	89 44 24 08          	mov    %eax,0x8(%esp)
    121e:	c7 44 24 04 85 4a 00 	movl   $0x4a85,0x4(%esp)
    1225:	00 
    1226:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    122d:	e8 36 2e 00 00       	call   4068 <printf>
      exit();
    1232:	e8 a1 2c 00 00       	call   3ed8 <exit>
    }
    unlink(fname);
    1237:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    123a:	89 04 24             	mov    %eax,(%esp)
    123d:	e8 e6 2c 00 00       	call   3f28 <unlink>

  for(pi = 0; pi < 4; pi++){
    wait();
  }

  for(i = 0; i < 2; i++){
    1242:	ff 45 e4             	incl   -0x1c(%ebp)
    1245:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1249:	0f 8e 1d ff ff ff    	jle    116c <fourfiles+0x165>
      exit();
    }
    unlink(fname);
  }

  printf(1, "fourfiles ok\n");
    124f:	c7 44 24 04 96 4a 00 	movl   $0x4a96,0x4(%esp)
    1256:	00 
    1257:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    125e:	e8 05 2e 00 00       	call   4068 <printf>
}
    1263:	83 c4 4c             	add    $0x4c,%esp
    1266:	5b                   	pop    %ebx
    1267:	5e                   	pop    %esi
    1268:	5f                   	pop    %edi
    1269:	5d                   	pop    %ebp
    126a:	c3                   	ret    

0000126b <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    126b:	55                   	push   %ebp
    126c:	89 e5                	mov    %esp,%ebp
    126e:	83 ec 48             	sub    $0x48,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1271:	c7 44 24 04 c0 4a 00 	movl   $0x4ac0,0x4(%esp)
    1278:	00 
    1279:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1280:	e8 e3 2d 00 00       	call   4068 <printf>

  for(pi = 0; pi < 4; pi++){
    1285:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    128c:	e9 f2 00 00 00       	jmp    1383 <createdelete+0x118>
    pid = fork();
    1291:	e8 3a 2c 00 00       	call   3ed0 <fork>
    1296:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1299:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    129d:	79 19                	jns    12b8 <createdelete+0x4d>
      printf(1, "fork failed\n");
    129f:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    12a6:	00 
    12a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12ae:	e8 b5 2d 00 00       	call   4068 <printf>
      exit();
    12b3:	e8 20 2c 00 00       	call   3ed8 <exit>
    }

    if(pid == 0){
    12b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    12bc:	0f 85 be 00 00 00    	jne    1380 <createdelete+0x115>
      name[0] = 'p' + pi;
    12c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c5:	83 c0 70             	add    $0x70,%eax
    12c8:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[2] = '\0';
    12cb:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
      for(i = 0; i < N; i++){
    12cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    12d6:	e9 96 00 00 00       	jmp    1371 <createdelete+0x106>
        name[1] = '0' + i;
    12db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12de:	83 c0 30             	add    $0x30,%eax
    12e1:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12e4:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    12eb:	00 
    12ec:	8d 45 c8             	lea    -0x38(%ebp),%eax
    12ef:	89 04 24             	mov    %eax,(%esp)
    12f2:	e8 21 2c 00 00       	call   3f18 <open>
    12f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(fd < 0){
    12fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    12fe:	79 19                	jns    1319 <createdelete+0xae>
          printf(1, "create failed\n");
    1300:	c7 44 24 04 59 4a 00 	movl   $0x4a59,0x4(%esp)
    1307:	00 
    1308:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    130f:	e8 54 2d 00 00       	call   4068 <printf>
          exit();
    1314:	e8 bf 2b 00 00       	call   3ed8 <exit>
        }
        close(fd);
    1319:	8b 45 e8             	mov    -0x18(%ebp),%eax
    131c:	89 04 24             	mov    %eax,(%esp)
    131f:	e8 dc 2b 00 00       	call   3f00 <close>
        if(i > 0 && (i % 2 ) == 0){
    1324:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1328:	7e 44                	jle    136e <createdelete+0x103>
    132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132d:	83 e0 01             	and    $0x1,%eax
    1330:	85 c0                	test   %eax,%eax
    1332:	75 3a                	jne    136e <createdelete+0x103>
          name[1] = '0' + (i / 2);
    1334:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1337:	89 c2                	mov    %eax,%edx
    1339:	c1 ea 1f             	shr    $0x1f,%edx
    133c:	01 d0                	add    %edx,%eax
    133e:	d1 f8                	sar    %eax
    1340:	83 c0 30             	add    $0x30,%eax
    1343:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1346:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1349:	89 04 24             	mov    %eax,(%esp)
    134c:	e8 d7 2b 00 00       	call   3f28 <unlink>
    1351:	85 c0                	test   %eax,%eax
    1353:	79 19                	jns    136e <createdelete+0x103>
            printf(1, "unlink failed\n");
    1355:	c7 44 24 04 54 45 00 	movl   $0x4554,0x4(%esp)
    135c:	00 
    135d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1364:	e8 ff 2c 00 00       	call   4068 <printf>
            exit();
    1369:	e8 6a 2b 00 00       	call   3ed8 <exit>
    }

    if(pid == 0){
      name[0] = 'p' + pi;
      name[2] = '\0';
      for(i = 0; i < N; i++){
    136e:	ff 45 f4             	incl   -0xc(%ebp)
    1371:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    1375:	0f 8e 60 ff ff ff    	jle    12db <createdelete+0x70>
            printf(1, "unlink failed\n");
            exit();
          }
        }
      }
      exit();
    137b:	e8 58 2b 00 00       	call   3ed8 <exit>
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");

  for(pi = 0; pi < 4; pi++){
    1380:	ff 45 f0             	incl   -0x10(%ebp)
    1383:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1387:	0f 8e 04 ff ff ff    	jle    1291 <createdelete+0x26>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    138d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1394:	eb 08                	jmp    139e <createdelete+0x133>
    wait();
    1396:	e8 45 2b 00 00       	call   3ee0 <wait>
      }
      exit();
    }
  }

  for(pi = 0; pi < 4; pi++){
    139b:	ff 45 f0             	incl   -0x10(%ebp)
    139e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    13a2:	7e f2                	jle    1396 <createdelete+0x12b>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
    13a4:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13a8:	8a 45 ca             	mov    -0x36(%ebp),%al
    13ab:	88 45 c9             	mov    %al,-0x37(%ebp)
    13ae:	8a 45 c9             	mov    -0x37(%ebp),%al
    13b1:	88 45 c8             	mov    %al,-0x38(%ebp)
  for(i = 0; i < N; i++){
    13b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    13bb:	e9 b9 00 00 00       	jmp    1479 <createdelete+0x20e>
    for(pi = 0; pi < 4; pi++){
    13c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    13c7:	e9 a0 00 00 00       	jmp    146c <createdelete+0x201>
      name[0] = 'p' + pi;
    13cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    13cf:	83 c0 70             	add    $0x70,%eax
    13d2:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    13d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13d8:	83 c0 30             	add    $0x30,%eax
    13db:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    13de:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13e5:	00 
    13e6:	8d 45 c8             	lea    -0x38(%ebp),%eax
    13e9:	89 04 24             	mov    %eax,(%esp)
    13ec:	e8 27 2b 00 00       	call   3f18 <open>
    13f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((i == 0 || i >= N/2) && fd < 0){
    13f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13f8:	74 06                	je     1400 <createdelete+0x195>
    13fa:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    13fe:	7e 26                	jle    1426 <createdelete+0x1bb>
    1400:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1404:	79 20                	jns    1426 <createdelete+0x1bb>
        printf(1, "oops createdelete %s didn't exist\n", name);
    1406:	8d 45 c8             	lea    -0x38(%ebp),%eax
    1409:	89 44 24 08          	mov    %eax,0x8(%esp)
    140d:	c7 44 24 04 d4 4a 00 	movl   $0x4ad4,0x4(%esp)
    1414:	00 
    1415:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    141c:	e8 47 2c 00 00       	call   4068 <printf>
        exit();
    1421:	e8 b2 2a 00 00       	call   3ed8 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    142a:	7e 2c                	jle    1458 <createdelete+0x1ed>
    142c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
    1430:	7f 26                	jg     1458 <createdelete+0x1ed>
    1432:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    1436:	78 20                	js     1458 <createdelete+0x1ed>
        printf(1, "oops createdelete %s did exist\n", name);
    1438:	8d 45 c8             	lea    -0x38(%ebp),%eax
    143b:	89 44 24 08          	mov    %eax,0x8(%esp)
    143f:	c7 44 24 04 f8 4a 00 	movl   $0x4af8,0x4(%esp)
    1446:	00 
    1447:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    144e:	e8 15 2c 00 00       	call   4068 <printf>
        exit();
    1453:	e8 80 2a 00 00       	call   3ed8 <exit>
      }
      if(fd >= 0)
    1458:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    145c:	78 0b                	js     1469 <createdelete+0x1fe>
        close(fd);
    145e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1461:	89 04 24             	mov    %eax,(%esp)
    1464:	e8 97 2a 00 00       	call   3f00 <close>
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    1469:	ff 45 f0             	incl   -0x10(%ebp)
    146c:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    1470:	0f 8e 56 ff ff ff    	jle    13cc <createdelete+0x161>
  for(pi = 0; pi < 4; pi++){
    wait();
  }

  name[0] = name[1] = name[2] = 0;
  for(i = 0; i < N; i++){
    1476:	ff 45 f4             	incl   -0xc(%ebp)
    1479:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    147d:	0f 8e 3d ff ff ff    	jle    13c0 <createdelete+0x155>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    1483:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    148a:	eb 32                	jmp    14be <createdelete+0x253>
    for(pi = 0; pi < 4; pi++){
    148c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1493:	eb 20                	jmp    14b5 <createdelete+0x24a>
      name[0] = 'p' + i;
    1495:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1498:	83 c0 70             	add    $0x70,%eax
    149b:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    149e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a1:	83 c0 30             	add    $0x30,%eax
    14a4:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    14a7:	8d 45 c8             	lea    -0x38(%ebp),%eax
    14aa:	89 04 24             	mov    %eax,(%esp)
    14ad:	e8 76 2a 00 00       	call   3f28 <unlink>
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    for(pi = 0; pi < 4; pi++){
    14b2:	ff 45 f0             	incl   -0x10(%ebp)
    14b5:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
    14b9:	7e da                	jle    1495 <createdelete+0x22a>
      if(fd >= 0)
        close(fd);
    }
  }

  for(i = 0; i < N; i++){
    14bb:	ff 45 f4             	incl   -0xc(%ebp)
    14be:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    14c2:	7e c8                	jle    148c <createdelete+0x221>
      name[1] = '0' + i;
      unlink(name);
    }
  }

  printf(1, "createdelete ok\n");
    14c4:	c7 44 24 04 18 4b 00 	movl   $0x4b18,0x4(%esp)
    14cb:	00 
    14cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14d3:	e8 90 2b 00 00       	call   4068 <printf>
}
    14d8:	c9                   	leave  
    14d9:	c3                   	ret    

000014da <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    14da:	55                   	push   %ebp
    14db:	89 e5                	mov    %esp,%ebp
    14dd:	83 ec 28             	sub    $0x28,%esp
  int fd, fd1;

  printf(1, "unlinkread test\n");
    14e0:	c7 44 24 04 29 4b 00 	movl   $0x4b29,0x4(%esp)
    14e7:	00 
    14e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14ef:	e8 74 2b 00 00       	call   4068 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    14f4:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    14fb:	00 
    14fc:	c7 04 24 3a 4b 00 00 	movl   $0x4b3a,(%esp)
    1503:	e8 10 2a 00 00       	call   3f18 <open>
    1508:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    150b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    150f:	79 19                	jns    152a <unlinkread+0x50>
    printf(1, "create unlinkread failed\n");
    1511:	c7 44 24 04 45 4b 00 	movl   $0x4b45,0x4(%esp)
    1518:	00 
    1519:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1520:	e8 43 2b 00 00       	call   4068 <printf>
    exit();
    1525:	e8 ae 29 00 00       	call   3ed8 <exit>
  }
  write(fd, "hello", 5);
    152a:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    1531:	00 
    1532:	c7 44 24 04 5f 4b 00 	movl   $0x4b5f,0x4(%esp)
    1539:	00 
    153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    153d:	89 04 24             	mov    %eax,(%esp)
    1540:	e8 b3 29 00 00       	call   3ef8 <write>
  close(fd);
    1545:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1548:	89 04 24             	mov    %eax,(%esp)
    154b:	e8 b0 29 00 00       	call   3f00 <close>

  fd = open("unlinkread", O_RDWR);
    1550:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    1557:	00 
    1558:	c7 04 24 3a 4b 00 00 	movl   $0x4b3a,(%esp)
    155f:	e8 b4 29 00 00       	call   3f18 <open>
    1564:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    156b:	79 19                	jns    1586 <unlinkread+0xac>
    printf(1, "open unlinkread failed\n");
    156d:	c7 44 24 04 65 4b 00 	movl   $0x4b65,0x4(%esp)
    1574:	00 
    1575:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    157c:	e8 e7 2a 00 00       	call   4068 <printf>
    exit();
    1581:	e8 52 29 00 00       	call   3ed8 <exit>
  }
  if(unlink("unlinkread") != 0){
    1586:	c7 04 24 3a 4b 00 00 	movl   $0x4b3a,(%esp)
    158d:	e8 96 29 00 00       	call   3f28 <unlink>
    1592:	85 c0                	test   %eax,%eax
    1594:	74 19                	je     15af <unlinkread+0xd5>
    printf(1, "unlink unlinkread failed\n");
    1596:	c7 44 24 04 7d 4b 00 	movl   $0x4b7d,0x4(%esp)
    159d:	00 
    159e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    15a5:	e8 be 2a 00 00       	call   4068 <printf>
    exit();
    15aa:	e8 29 29 00 00       	call   3ed8 <exit>
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    15af:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    15b6:	00 
    15b7:	c7 04 24 3a 4b 00 00 	movl   $0x4b3a,(%esp)
    15be:	e8 55 29 00 00       	call   3f18 <open>
    15c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  write(fd1, "yyy", 3);
    15c6:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
    15cd:	00 
    15ce:	c7 44 24 04 97 4b 00 	movl   $0x4b97,0x4(%esp)
    15d5:	00 
    15d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15d9:	89 04 24             	mov    %eax,(%esp)
    15dc:	e8 17 29 00 00       	call   3ef8 <write>
  close(fd1);
    15e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15e4:	89 04 24             	mov    %eax,(%esp)
    15e7:	e8 14 29 00 00       	call   3f00 <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    15ec:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    15f3:	00 
    15f4:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    15fb:	00 
    15fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ff:	89 04 24             	mov    %eax,(%esp)
    1602:	e8 e9 28 00 00       	call   3ef0 <read>
    1607:	83 f8 05             	cmp    $0x5,%eax
    160a:	74 19                	je     1625 <unlinkread+0x14b>
    printf(1, "unlinkread read failed");
    160c:	c7 44 24 04 9b 4b 00 	movl   $0x4b9b,0x4(%esp)
    1613:	00 
    1614:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    161b:	e8 48 2a 00 00       	call   4068 <printf>
    exit();
    1620:	e8 b3 28 00 00       	call   3ed8 <exit>
  }
  if(buf[0] != 'h'){
    1625:	a0 20 8b 00 00       	mov    0x8b20,%al
    162a:	3c 68                	cmp    $0x68,%al
    162c:	74 19                	je     1647 <unlinkread+0x16d>
    printf(1, "unlinkread wrong data\n");
    162e:	c7 44 24 04 b2 4b 00 	movl   $0x4bb2,0x4(%esp)
    1635:	00 
    1636:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    163d:	e8 26 2a 00 00       	call   4068 <printf>
    exit();
    1642:	e8 91 28 00 00       	call   3ed8 <exit>
  }
  if(write(fd, buf, 10) != 10){
    1647:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    164e:	00 
    164f:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    1656:	00 
    1657:	8b 45 f4             	mov    -0xc(%ebp),%eax
    165a:	89 04 24             	mov    %eax,(%esp)
    165d:	e8 96 28 00 00       	call   3ef8 <write>
    1662:	83 f8 0a             	cmp    $0xa,%eax
    1665:	74 19                	je     1680 <unlinkread+0x1a6>
    printf(1, "unlinkread write failed\n");
    1667:	c7 44 24 04 c9 4b 00 	movl   $0x4bc9,0x4(%esp)
    166e:	00 
    166f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1676:	e8 ed 29 00 00       	call   4068 <printf>
    exit();
    167b:	e8 58 28 00 00       	call   3ed8 <exit>
  }
  close(fd);
    1680:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1683:	89 04 24             	mov    %eax,(%esp)
    1686:	e8 75 28 00 00       	call   3f00 <close>
  unlink("unlinkread");
    168b:	c7 04 24 3a 4b 00 00 	movl   $0x4b3a,(%esp)
    1692:	e8 91 28 00 00       	call   3f28 <unlink>
  printf(1, "unlinkread ok\n");
    1697:	c7 44 24 04 e2 4b 00 	movl   $0x4be2,0x4(%esp)
    169e:	00 
    169f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16a6:	e8 bd 29 00 00       	call   4068 <printf>
}
    16ab:	c9                   	leave  
    16ac:	c3                   	ret    

000016ad <linktest>:

void
linktest(void)
{
    16ad:	55                   	push   %ebp
    16ae:	89 e5                	mov    %esp,%ebp
    16b0:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "linktest\n");
    16b3:	c7 44 24 04 f1 4b 00 	movl   $0x4bf1,0x4(%esp)
    16ba:	00 
    16bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    16c2:	e8 a1 29 00 00       	call   4068 <printf>

  unlink("lf1");
    16c7:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    16ce:	e8 55 28 00 00       	call   3f28 <unlink>
  unlink("lf2");
    16d3:	c7 04 24 ff 4b 00 00 	movl   $0x4bff,(%esp)
    16da:	e8 49 28 00 00       	call   3f28 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    16df:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    16e6:	00 
    16e7:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    16ee:	e8 25 28 00 00       	call   3f18 <open>
    16f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    16f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    16fa:	79 19                	jns    1715 <linktest+0x68>
    printf(1, "create lf1 failed\n");
    16fc:	c7 44 24 04 03 4c 00 	movl   $0x4c03,0x4(%esp)
    1703:	00 
    1704:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    170b:	e8 58 29 00 00       	call   4068 <printf>
    exit();
    1710:	e8 c3 27 00 00       	call   3ed8 <exit>
  }
  if(write(fd, "hello", 5) != 5){
    1715:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
    171c:	00 
    171d:	c7 44 24 04 5f 4b 00 	movl   $0x4b5f,0x4(%esp)
    1724:	00 
    1725:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1728:	89 04 24             	mov    %eax,(%esp)
    172b:	e8 c8 27 00 00       	call   3ef8 <write>
    1730:	83 f8 05             	cmp    $0x5,%eax
    1733:	74 19                	je     174e <linktest+0xa1>
    printf(1, "write lf1 failed\n");
    1735:	c7 44 24 04 16 4c 00 	movl   $0x4c16,0x4(%esp)
    173c:	00 
    173d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1744:	e8 1f 29 00 00       	call   4068 <printf>
    exit();
    1749:	e8 8a 27 00 00       	call   3ed8 <exit>
  }
  close(fd);
    174e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1751:	89 04 24             	mov    %eax,(%esp)
    1754:	e8 a7 27 00 00       	call   3f00 <close>

  if(link("lf1", "lf2") < 0){
    1759:	c7 44 24 04 ff 4b 00 	movl   $0x4bff,0x4(%esp)
    1760:	00 
    1761:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    1768:	e8 cb 27 00 00       	call   3f38 <link>
    176d:	85 c0                	test   %eax,%eax
    176f:	79 19                	jns    178a <linktest+0xdd>
    printf(1, "link lf1 lf2 failed\n");
    1771:	c7 44 24 04 28 4c 00 	movl   $0x4c28,0x4(%esp)
    1778:	00 
    1779:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1780:	e8 e3 28 00 00       	call   4068 <printf>
    exit();
    1785:	e8 4e 27 00 00       	call   3ed8 <exit>
  }
  unlink("lf1");
    178a:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    1791:	e8 92 27 00 00       	call   3f28 <unlink>

  if(open("lf1", 0) >= 0){
    1796:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    179d:	00 
    179e:	c7 04 24 fb 4b 00 00 	movl   $0x4bfb,(%esp)
    17a5:	e8 6e 27 00 00       	call   3f18 <open>
    17aa:	85 c0                	test   %eax,%eax
    17ac:	78 19                	js     17c7 <linktest+0x11a>
    printf(1, "unlinked lf1 but it is still there!\n");
    17ae:	c7 44 24 04 40 4c 00 	movl   $0x4c40,0x4(%esp)
    17b5:	00 
    17b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17bd:	e8 a6 28 00 00       	call   4068 <printf>
    exit();
    17c2:	e8 11 27 00 00       	call   3ed8 <exit>
  }

  fd = open("lf2", 0);
    17c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    17ce:	00 
    17cf:	c7 04 24 ff 4b 00 00 	movl   $0x4bff,(%esp)
    17d6:	e8 3d 27 00 00       	call   3f18 <open>
    17db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    17de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    17e2:	79 19                	jns    17fd <linktest+0x150>
    printf(1, "open lf2 failed\n");
    17e4:	c7 44 24 04 65 4c 00 	movl   $0x4c65,0x4(%esp)
    17eb:	00 
    17ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    17f3:	e8 70 28 00 00       	call   4068 <printf>
    exit();
    17f8:	e8 db 26 00 00       	call   3ed8 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    17fd:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    1804:	00 
    1805:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    180c:	00 
    180d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1810:	89 04 24             	mov    %eax,(%esp)
    1813:	e8 d8 26 00 00       	call   3ef0 <read>
    1818:	83 f8 05             	cmp    $0x5,%eax
    181b:	74 19                	je     1836 <linktest+0x189>
    printf(1, "read lf2 failed\n");
    181d:	c7 44 24 04 76 4c 00 	movl   $0x4c76,0x4(%esp)
    1824:	00 
    1825:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    182c:	e8 37 28 00 00       	call   4068 <printf>
    exit();
    1831:	e8 a2 26 00 00       	call   3ed8 <exit>
  }
  close(fd);
    1836:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1839:	89 04 24             	mov    %eax,(%esp)
    183c:	e8 bf 26 00 00       	call   3f00 <close>

  if(link("lf2", "lf2") >= 0){
    1841:	c7 44 24 04 ff 4b 00 	movl   $0x4bff,0x4(%esp)
    1848:	00 
    1849:	c7 04 24 ff 4b 00 00 	movl   $0x4bff,(%esp)
    1850:	e8 e3 26 00 00       	call   3f38 <link>
    1855:	85 c0                	test   %eax,%eax
    1857:	78 19                	js     1872 <linktest+0x1c5>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    1859:	c7 44 24 04 87 4c 00 	movl   $0x4c87,0x4(%esp)
    1860:	00 
    1861:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1868:	e8 fb 27 00 00       	call   4068 <printf>
    exit();
    186d:	e8 66 26 00 00       	call   3ed8 <exit>
  }

  unlink("lf2");
    1872:	c7 04 24 ff 4b 00 00 	movl   $0x4bff,(%esp)
    1879:	e8 aa 26 00 00       	call   3f28 <unlink>
  if(link("lf2", "lf1") >= 0){
    187e:	c7 44 24 04 fb 4b 00 	movl   $0x4bfb,0x4(%esp)
    1885:	00 
    1886:	c7 04 24 ff 4b 00 00 	movl   $0x4bff,(%esp)
    188d:	e8 a6 26 00 00       	call   3f38 <link>
    1892:	85 c0                	test   %eax,%eax
    1894:	78 19                	js     18af <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    1896:	c7 44 24 04 a8 4c 00 	movl   $0x4ca8,0x4(%esp)
    189d:	00 
    189e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18a5:	e8 be 27 00 00       	call   4068 <printf>
    exit();
    18aa:	e8 29 26 00 00       	call   3ed8 <exit>
  }

  if(link(".", "lf1") >= 0){
    18af:	c7 44 24 04 fb 4b 00 	movl   $0x4bfb,0x4(%esp)
    18b6:	00 
    18b7:	c7 04 24 cb 4c 00 00 	movl   $0x4ccb,(%esp)
    18be:	e8 75 26 00 00       	call   3f38 <link>
    18c3:	85 c0                	test   %eax,%eax
    18c5:	78 19                	js     18e0 <linktest+0x233>
    printf(1, "link . lf1 succeeded! oops\n");
    18c7:	c7 44 24 04 cd 4c 00 	movl   $0x4ccd,0x4(%esp)
    18ce:	00 
    18cf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18d6:	e8 8d 27 00 00       	call   4068 <printf>
    exit();
    18db:	e8 f8 25 00 00       	call   3ed8 <exit>
  }

  printf(1, "linktest ok\n");
    18e0:	c7 44 24 04 e9 4c 00 	movl   $0x4ce9,0x4(%esp)
    18e7:	00 
    18e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    18ef:	e8 74 27 00 00       	call   4068 <printf>
}
    18f4:	c9                   	leave  
    18f5:	c3                   	ret    

000018f6 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    18f6:	55                   	push   %ebp
    18f7:	89 e5                	mov    %esp,%ebp
    18f9:	83 ec 68             	sub    $0x68,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    18fc:	c7 44 24 04 f6 4c 00 	movl   $0x4cf6,0x4(%esp)
    1903:	00 
    1904:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    190b:	e8 58 27 00 00       	call   4068 <printf>
  file[0] = 'C';
    1910:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1914:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    1918:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    191f:	e9 d0 00 00 00       	jmp    19f4 <concreate+0xfe>
    file[1] = '0' + i;
    1924:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1927:	83 c0 30             	add    $0x30,%eax
    192a:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    192d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1930:	89 04 24             	mov    %eax,(%esp)
    1933:	e8 f0 25 00 00       	call   3f28 <unlink>
    pid = fork();
    1938:	e8 93 25 00 00       	call   3ed0 <fork>
    193d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid && (i % 3) == 1){
    1940:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1944:	74 27                	je     196d <concreate+0x77>
    1946:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1949:	b9 03 00 00 00       	mov    $0x3,%ecx
    194e:	99                   	cltd   
    194f:	f7 f9                	idiv   %ecx
    1951:	89 d0                	mov    %edx,%eax
    1953:	83 f8 01             	cmp    $0x1,%eax
    1956:	75 15                	jne    196d <concreate+0x77>
      link("C0", file);
    1958:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    195b:	89 44 24 04          	mov    %eax,0x4(%esp)
    195f:	c7 04 24 06 4d 00 00 	movl   $0x4d06,(%esp)
    1966:	e8 cd 25 00 00       	call   3f38 <link>
    196b:	eb 74                	jmp    19e1 <concreate+0xeb>
    } else if(pid == 0 && (i % 5) == 1){
    196d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1971:	75 27                	jne    199a <concreate+0xa4>
    1973:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1976:	b9 05 00 00 00       	mov    $0x5,%ecx
    197b:	99                   	cltd   
    197c:	f7 f9                	idiv   %ecx
    197e:	89 d0                	mov    %edx,%eax
    1980:	83 f8 01             	cmp    $0x1,%eax
    1983:	75 15                	jne    199a <concreate+0xa4>
      link("C0", file);
    1985:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1988:	89 44 24 04          	mov    %eax,0x4(%esp)
    198c:	c7 04 24 06 4d 00 00 	movl   $0x4d06,(%esp)
    1993:	e8 a0 25 00 00       	call   3f38 <link>
    1998:	eb 47                	jmp    19e1 <concreate+0xeb>
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    199a:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    19a1:	00 
    19a2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19a5:	89 04 24             	mov    %eax,(%esp)
    19a8:	e8 6b 25 00 00       	call   3f18 <open>
    19ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(fd < 0){
    19b0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    19b4:	79 20                	jns    19d6 <concreate+0xe0>
        printf(1, "concreate create %s failed\n", file);
    19b6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    19b9:	89 44 24 08          	mov    %eax,0x8(%esp)
    19bd:	c7 44 24 04 09 4d 00 	movl   $0x4d09,0x4(%esp)
    19c4:	00 
    19c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    19cc:	e8 97 26 00 00       	call   4068 <printf>
        exit();
    19d1:	e8 02 25 00 00       	call   3ed8 <exit>
      }
      close(fd);
    19d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    19d9:	89 04 24             	mov    %eax,(%esp)
    19dc:	e8 1f 25 00 00       	call   3f00 <close>
    }
    if(pid == 0)
    19e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    19e5:	75 05                	jne    19ec <concreate+0xf6>
      exit();
    19e7:	e8 ec 24 00 00       	call   3ed8 <exit>
    else
      wait();
    19ec:	e8 ef 24 00 00       	call   3ee0 <wait>
  } de;

  printf(1, "concreate test\n");
  file[0] = 'C';
  file[2] = '\0';
  for(i = 0; i < 40; i++){
    19f1:	ff 45 f4             	incl   -0xc(%ebp)
    19f4:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    19f8:	0f 8e 26 ff ff ff    	jle    1924 <concreate+0x2e>
      exit();
    else
      wait();
  }

  memset(fa, 0, sizeof(fa));
    19fe:	c7 44 24 08 28 00 00 	movl   $0x28,0x8(%esp)
    1a05:	00 
    1a06:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a0d:	00 
    1a0e:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1a11:	89 04 24             	mov    %eax,(%esp)
    1a14:	e8 f7 22 00 00       	call   3d10 <memset>
  fd = open(".", 0);
    1a19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1a20:	00 
    1a21:	c7 04 24 cb 4c 00 00 	movl   $0x4ccb,(%esp)
    1a28:	e8 eb 24 00 00       	call   3f18 <open>
    1a2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  n = 0;
    1a30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    1a37:	e9 9d 00 00 00       	jmp    1ad9 <concreate+0x1e3>
    if(de.inum == 0)
    1a3c:	8b 45 ac             	mov    -0x54(%ebp),%eax
    1a3f:	66 85 c0             	test   %ax,%ax
    1a42:	0f 84 90 00 00 00    	je     1ad8 <concreate+0x1e2>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1a48:	8a 45 ae             	mov    -0x52(%ebp),%al
    1a4b:	3c 43                	cmp    $0x43,%al
    1a4d:	0f 85 86 00 00 00    	jne    1ad9 <concreate+0x1e3>
    1a53:	8a 45 b0             	mov    -0x50(%ebp),%al
    1a56:	84 c0                	test   %al,%al
    1a58:	75 7f                	jne    1ad9 <concreate+0x1e3>
      i = de.name[1] - '0';
    1a5a:	8a 45 af             	mov    -0x51(%ebp),%al
    1a5d:	0f be c0             	movsbl %al,%eax
    1a60:	83 e8 30             	sub    $0x30,%eax
    1a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
      if(i < 0 || i >= sizeof(fa)){
    1a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a6a:	78 08                	js     1a74 <concreate+0x17e>
    1a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a6f:	83 f8 27             	cmp    $0x27,%eax
    1a72:	76 23                	jbe    1a97 <concreate+0x1a1>
        printf(1, "concreate weird file %s\n", de.name);
    1a74:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1a77:	83 c0 02             	add    $0x2,%eax
    1a7a:	89 44 24 08          	mov    %eax,0x8(%esp)
    1a7e:	c7 44 24 04 25 4d 00 	movl   $0x4d25,0x4(%esp)
    1a85:	00 
    1a86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1a8d:	e8 d6 25 00 00       	call   4068 <printf>
        exit();
    1a92:	e8 41 24 00 00       	call   3ed8 <exit>
      }
      if(fa[i]){
    1a97:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a9d:	01 d0                	add    %edx,%eax
    1a9f:	8a 00                	mov    (%eax),%al
    1aa1:	84 c0                	test   %al,%al
    1aa3:	74 23                	je     1ac8 <concreate+0x1d2>
        printf(1, "concreate duplicate file %s\n", de.name);
    1aa5:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1aa8:	83 c0 02             	add    $0x2,%eax
    1aab:	89 44 24 08          	mov    %eax,0x8(%esp)
    1aaf:	c7 44 24 04 3e 4d 00 	movl   $0x4d3e,0x4(%esp)
    1ab6:	00 
    1ab7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1abe:	e8 a5 25 00 00       	call   4068 <printf>
        exit();
    1ac3:	e8 10 24 00 00       	call   3ed8 <exit>
      }
      fa[i] = 1;
    1ac8:	8d 55 bd             	lea    -0x43(%ebp),%edx
    1acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ace:	01 d0                	add    %edx,%eax
    1ad0:	c6 00 01             	movb   $0x1,(%eax)
      n++;
    1ad3:	ff 45 f0             	incl   -0x10(%ebp)
    1ad6:	eb 01                	jmp    1ad9 <concreate+0x1e3>
  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    if(de.inum == 0)
      continue;
    1ad8:	90                   	nop
  }

  memset(fa, 0, sizeof(fa));
  fd = open(".", 0);
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    1ad9:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1ae0:	00 
    1ae1:	8d 45 ac             	lea    -0x54(%ebp),%eax
    1ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ae8:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1aeb:	89 04 24             	mov    %eax,(%esp)
    1aee:	e8 fd 23 00 00       	call   3ef0 <read>
    1af3:	85 c0                	test   %eax,%eax
    1af5:	0f 8f 41 ff ff ff    	jg     1a3c <concreate+0x146>
      }
      fa[i] = 1;
      n++;
    }
  }
  close(fd);
    1afb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1afe:	89 04 24             	mov    %eax,(%esp)
    1b01:	e8 fa 23 00 00       	call   3f00 <close>

  if(n != 40){
    1b06:	83 7d f0 28          	cmpl   $0x28,-0x10(%ebp)
    1b0a:	74 19                	je     1b25 <concreate+0x22f>
    printf(1, "concreate not enough files in directory listing\n");
    1b0c:	c7 44 24 04 5c 4d 00 	movl   $0x4d5c,0x4(%esp)
    1b13:	00 
    1b14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b1b:	e8 48 25 00 00       	call   4068 <printf>
    exit();
    1b20:	e8 b3 23 00 00       	call   3ed8 <exit>
  }

  for(i = 0; i < 40; i++){
    1b25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1b2c:	e9 0c 01 00 00       	jmp    1c3d <concreate+0x347>
    file[1] = '0' + i;
    1b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b34:	83 c0 30             	add    $0x30,%eax
    1b37:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1b3a:	e8 91 23 00 00       	call   3ed0 <fork>
    1b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(pid < 0){
    1b42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b46:	79 19                	jns    1b61 <concreate+0x26b>
      printf(1, "fork failed\n");
    1b48:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    1b4f:	00 
    1b50:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1b57:	e8 0c 25 00 00       	call   4068 <printf>
      exit();
    1b5c:	e8 77 23 00 00       	call   3ed8 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b64:	b9 03 00 00 00       	mov    $0x3,%ecx
    1b69:	99                   	cltd   
    1b6a:	f7 f9                	idiv   %ecx
    1b6c:	89 d0                	mov    %edx,%eax
    1b6e:	85 c0                	test   %eax,%eax
    1b70:	75 06                	jne    1b78 <concreate+0x282>
    1b72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b76:	74 18                	je     1b90 <concreate+0x29a>
       ((i % 3) == 1 && pid != 0)){
    1b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b7b:	b9 03 00 00 00       	mov    $0x3,%ecx
    1b80:	99                   	cltd   
    1b81:	f7 f9                	idiv   %ecx
    1b83:	89 d0                	mov    %edx,%eax
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(((i % 3) == 0 && pid == 0) ||
    1b85:	83 f8 01             	cmp    $0x1,%eax
    1b88:	75 74                	jne    1bfe <concreate+0x308>
       ((i % 3) == 1 && pid != 0)){
    1b8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1b8e:	74 6e                	je     1bfe <concreate+0x308>
      close(open(file, 0));
    1b90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1b97:	00 
    1b98:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1b9b:	89 04 24             	mov    %eax,(%esp)
    1b9e:	e8 75 23 00 00       	call   3f18 <open>
    1ba3:	89 04 24             	mov    %eax,(%esp)
    1ba6:	e8 55 23 00 00       	call   3f00 <close>
      close(open(file, 0));
    1bab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1bb2:	00 
    1bb3:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bb6:	89 04 24             	mov    %eax,(%esp)
    1bb9:	e8 5a 23 00 00       	call   3f18 <open>
    1bbe:	89 04 24             	mov    %eax,(%esp)
    1bc1:	e8 3a 23 00 00       	call   3f00 <close>
      close(open(file, 0));
    1bc6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1bcd:	00 
    1bce:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bd1:	89 04 24             	mov    %eax,(%esp)
    1bd4:	e8 3f 23 00 00       	call   3f18 <open>
    1bd9:	89 04 24             	mov    %eax,(%esp)
    1bdc:	e8 1f 23 00 00       	call   3f00 <close>
      close(open(file, 0));
    1be1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1be8:	00 
    1be9:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1bec:	89 04 24             	mov    %eax,(%esp)
    1bef:	e8 24 23 00 00       	call   3f18 <open>
    1bf4:	89 04 24             	mov    %eax,(%esp)
    1bf7:	e8 04 23 00 00       	call   3f00 <close>
    1bfc:	eb 2c                	jmp    1c2a <concreate+0x334>
    } else {
      unlink(file);
    1bfe:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c01:	89 04 24             	mov    %eax,(%esp)
    1c04:	e8 1f 23 00 00       	call   3f28 <unlink>
      unlink(file);
    1c09:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c0c:	89 04 24             	mov    %eax,(%esp)
    1c0f:	e8 14 23 00 00       	call   3f28 <unlink>
      unlink(file);
    1c14:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c17:	89 04 24             	mov    %eax,(%esp)
    1c1a:	e8 09 23 00 00       	call   3f28 <unlink>
      unlink(file);
    1c1f:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1c22:	89 04 24             	mov    %eax,(%esp)
    1c25:	e8 fe 22 00 00       	call   3f28 <unlink>
    }
    if(pid == 0)
    1c2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c2e:	75 05                	jne    1c35 <concreate+0x33f>
      exit();
    1c30:	e8 a3 22 00 00       	call   3ed8 <exit>
    else
      wait();
    1c35:	e8 a6 22 00 00       	call   3ee0 <wait>
  if(n != 40){
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    1c3a:	ff 45 f4             	incl   -0xc(%ebp)
    1c3d:	83 7d f4 27          	cmpl   $0x27,-0xc(%ebp)
    1c41:	0f 8e ea fe ff ff    	jle    1b31 <concreate+0x23b>
      exit();
    else
      wait();
  }

  printf(1, "concreate ok\n");
    1c47:	c7 44 24 04 8d 4d 00 	movl   $0x4d8d,0x4(%esp)
    1c4e:	00 
    1c4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c56:	e8 0d 24 00 00       	call   4068 <printf>
}
    1c5b:	c9                   	leave  
    1c5c:	c3                   	ret    

00001c5d <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    1c5d:	55                   	push   %ebp
    1c5e:	89 e5                	mov    %esp,%ebp
    1c60:	83 ec 28             	sub    $0x28,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1c63:	c7 44 24 04 9b 4d 00 	movl   $0x4d9b,0x4(%esp)
    1c6a:	00 
    1c6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1c72:	e8 f1 23 00 00       	call   4068 <printf>

  unlink("x");
    1c77:	c7 04 24 07 49 00 00 	movl   $0x4907,(%esp)
    1c7e:	e8 a5 22 00 00       	call   3f28 <unlink>
  pid = fork();
    1c83:	e8 48 22 00 00       	call   3ed0 <fork>
    1c88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(pid < 0){
    1c8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1c8f:	79 19                	jns    1caa <linkunlink+0x4d>
    printf(1, "fork failed\n");
    1c91:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    1c98:	00 
    1c99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ca0:	e8 c3 23 00 00       	call   4068 <printf>
    exit();
    1ca5:	e8 2e 22 00 00       	call   3ed8 <exit>
  }

  unsigned int x = (pid ? 1 : 97);
    1caa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1cae:	74 07                	je     1cb7 <linkunlink+0x5a>
    1cb0:	b8 01 00 00 00       	mov    $0x1,%eax
    1cb5:	eb 05                	jmp    1cbc <linkunlink+0x5f>
    1cb7:	b8 61 00 00 00       	mov    $0x61,%eax
    1cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 100; i++){
    1cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1cc6:	e9 a5 00 00 00       	jmp    1d70 <linkunlink+0x113>
    x = x * 1103515245 + 12345;
    1ccb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    1cce:	89 ca                	mov    %ecx,%edx
    1cd0:	89 d0                	mov    %edx,%eax
    1cd2:	c1 e0 09             	shl    $0x9,%eax
    1cd5:	89 c2                	mov    %eax,%edx
    1cd7:	29 ca                	sub    %ecx,%edx
    1cd9:	c1 e2 02             	shl    $0x2,%edx
    1cdc:	01 ca                	add    %ecx,%edx
    1cde:	89 d0                	mov    %edx,%eax
    1ce0:	c1 e0 09             	shl    $0x9,%eax
    1ce3:	29 d0                	sub    %edx,%eax
    1ce5:	d1 e0                	shl    %eax
    1ce7:	01 c8                	add    %ecx,%eax
    1ce9:	89 c2                	mov    %eax,%edx
    1ceb:	c1 e2 05             	shl    $0x5,%edx
    1cee:	01 d0                	add    %edx,%eax
    1cf0:	c1 e0 02             	shl    $0x2,%eax
    1cf3:	29 c8                	sub    %ecx,%eax
    1cf5:	c1 e0 02             	shl    $0x2,%eax
    1cf8:	01 c8                	add    %ecx,%eax
    1cfa:	05 39 30 00 00       	add    $0x3039,%eax
    1cff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((x % 3) == 0){
    1d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d05:	b9 03 00 00 00       	mov    $0x3,%ecx
    1d0a:	ba 00 00 00 00       	mov    $0x0,%edx
    1d0f:	f7 f1                	div    %ecx
    1d11:	89 d0                	mov    %edx,%eax
    1d13:	85 c0                	test   %eax,%eax
    1d15:	75 1e                	jne    1d35 <linkunlink+0xd8>
      close(open("x", O_RDWR | O_CREATE));
    1d17:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1d1e:	00 
    1d1f:	c7 04 24 07 49 00 00 	movl   $0x4907,(%esp)
    1d26:	e8 ed 21 00 00       	call   3f18 <open>
    1d2b:	89 04 24             	mov    %eax,(%esp)
    1d2e:	e8 cd 21 00 00       	call   3f00 <close>
    1d33:	eb 38                	jmp    1d6d <linkunlink+0x110>
    } else if((x % 3) == 1){
    1d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1d38:	b9 03 00 00 00       	mov    $0x3,%ecx
    1d3d:	ba 00 00 00 00       	mov    $0x0,%edx
    1d42:	f7 f1                	div    %ecx
    1d44:	89 d0                	mov    %edx,%eax
    1d46:	83 f8 01             	cmp    $0x1,%eax
    1d49:	75 16                	jne    1d61 <linkunlink+0x104>
      link("cat", "x");
    1d4b:	c7 44 24 04 07 49 00 	movl   $0x4907,0x4(%esp)
    1d52:	00 
    1d53:	c7 04 24 ac 4d 00 00 	movl   $0x4dac,(%esp)
    1d5a:	e8 d9 21 00 00       	call   3f38 <link>
    1d5f:	eb 0c                	jmp    1d6d <linkunlink+0x110>
    } else {
      unlink("x");
    1d61:	c7 04 24 07 49 00 00 	movl   $0x4907,(%esp)
    1d68:	e8 bb 21 00 00       	call   3f28 <unlink>
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
  for(i = 0; i < 100; i++){
    1d6d:	ff 45 f4             	incl   -0xc(%ebp)
    1d70:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
    1d74:	0f 8e 51 ff ff ff    	jle    1ccb <linkunlink+0x6e>
    } else {
      unlink("x");
    }
  }

  if(pid)
    1d7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1d7e:	74 1b                	je     1d9b <linkunlink+0x13e>
    wait();
    1d80:	e8 5b 21 00 00       	call   3ee0 <wait>
  else 
    exit();

  printf(1, "linkunlink ok\n");
    1d85:	c7 44 24 04 b0 4d 00 	movl   $0x4db0,0x4(%esp)
    1d8c:	00 
    1d8d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1d94:	e8 cf 22 00 00       	call   4068 <printf>
    1d99:	eb 05                	jmp    1da0 <linkunlink+0x143>
  }

  if(pid)
    wait();
  else 
    exit();
    1d9b:	e8 38 21 00 00       	call   3ed8 <exit>

  printf(1, "linkunlink ok\n");
}
    1da0:	c9                   	leave  
    1da1:	c3                   	ret    

00001da2 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    1da2:	55                   	push   %ebp
    1da3:	89 e5                	mov    %esp,%ebp
    1da5:	83 ec 38             	sub    $0x38,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    1da8:	c7 44 24 04 bf 4d 00 	movl   $0x4dbf,0x4(%esp)
    1daf:	00 
    1db0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1db7:	e8 ac 22 00 00       	call   4068 <printf>
  unlink("bd");
    1dbc:	c7 04 24 cc 4d 00 00 	movl   $0x4dcc,(%esp)
    1dc3:	e8 60 21 00 00       	call   3f28 <unlink>

  fd = open("bd", O_CREATE);
    1dc8:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    1dcf:	00 
    1dd0:	c7 04 24 cc 4d 00 00 	movl   $0x4dcc,(%esp)
    1dd7:	e8 3c 21 00 00       	call   3f18 <open>
    1ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0){
    1ddf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1de3:	79 19                	jns    1dfe <bigdir+0x5c>
    printf(1, "bigdir create failed\n");
    1de5:	c7 44 24 04 cf 4d 00 	movl   $0x4dcf,0x4(%esp)
    1dec:	00 
    1ded:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1df4:	e8 6f 22 00 00       	call   4068 <printf>
    exit();
    1df9:	e8 da 20 00 00       	call   3ed8 <exit>
  }
  close(fd);
    1dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1e01:	89 04 24             	mov    %eax,(%esp)
    1e04:	e8 f7 20 00 00       	call   3f00 <close>

  for(i = 0; i < 500; i++){
    1e09:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e10:	eb 65                	jmp    1e77 <bigdir+0xd5>
    name[0] = 'x';
    1e12:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e19:	85 c0                	test   %eax,%eax
    1e1b:	79 03                	jns    1e20 <bigdir+0x7e>
    1e1d:	83 c0 3f             	add    $0x3f,%eax
    1e20:	c1 f8 06             	sar    $0x6,%eax
    1e23:	83 c0 30             	add    $0x30,%eax
    1e26:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e2c:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1e31:	85 c0                	test   %eax,%eax
    1e33:	79 05                	jns    1e3a <bigdir+0x98>
    1e35:	48                   	dec    %eax
    1e36:	83 c8 c0             	or     $0xffffffc0,%eax
    1e39:	40                   	inc    %eax
    1e3a:	83 c0 30             	add    $0x30,%eax
    1e3d:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1e40:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(link("bd", name) != 0){
    1e44:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1e47:	89 44 24 04          	mov    %eax,0x4(%esp)
    1e4b:	c7 04 24 cc 4d 00 00 	movl   $0x4dcc,(%esp)
    1e52:	e8 e1 20 00 00       	call   3f38 <link>
    1e57:	85 c0                	test   %eax,%eax
    1e59:	74 19                	je     1e74 <bigdir+0xd2>
      printf(1, "bigdir link failed\n");
    1e5b:	c7 44 24 04 e5 4d 00 	movl   $0x4de5,0x4(%esp)
    1e62:	00 
    1e63:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1e6a:	e8 f9 21 00 00       	call   4068 <printf>
      exit();
    1e6f:	e8 64 20 00 00       	call   3ed8 <exit>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);

  for(i = 0; i < 500; i++){
    1e74:	ff 45 f4             	incl   -0xc(%ebp)
    1e77:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1e7e:	7e 92                	jle    1e12 <bigdir+0x70>
      printf(1, "bigdir link failed\n");
      exit();
    }
  }

  unlink("bd");
    1e80:	c7 04 24 cc 4d 00 00 	movl   $0x4dcc,(%esp)
    1e87:	e8 9c 20 00 00       	call   3f28 <unlink>
  for(i = 0; i < 500; i++){
    1e8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1e93:	eb 5d                	jmp    1ef2 <bigdir+0x150>
    name[0] = 'x';
    1e95:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
    name[1] = '0' + (i / 64);
    1e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1e9c:	85 c0                	test   %eax,%eax
    1e9e:	79 03                	jns    1ea3 <bigdir+0x101>
    1ea0:	83 c0 3f             	add    $0x3f,%eax
    1ea3:	c1 f8 06             	sar    $0x6,%eax
    1ea6:	83 c0 30             	add    $0x30,%eax
    1ea9:	88 45 e7             	mov    %al,-0x19(%ebp)
    name[2] = '0' + (i % 64);
    1eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1eaf:	25 3f 00 00 80       	and    $0x8000003f,%eax
    1eb4:	85 c0                	test   %eax,%eax
    1eb6:	79 05                	jns    1ebd <bigdir+0x11b>
    1eb8:	48                   	dec    %eax
    1eb9:	83 c8 c0             	or     $0xffffffc0,%eax
    1ebc:	40                   	inc    %eax
    1ebd:	83 c0 30             	add    $0x30,%eax
    1ec0:	88 45 e8             	mov    %al,-0x18(%ebp)
    name[3] = '\0';
    1ec3:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
    if(unlink(name) != 0){
    1ec7:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    1eca:	89 04 24             	mov    %eax,(%esp)
    1ecd:	e8 56 20 00 00       	call   3f28 <unlink>
    1ed2:	85 c0                	test   %eax,%eax
    1ed4:	74 19                	je     1eef <bigdir+0x14d>
      printf(1, "bigdir unlink failed");
    1ed6:	c7 44 24 04 f9 4d 00 	movl   $0x4df9,0x4(%esp)
    1edd:	00 
    1ede:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1ee5:	e8 7e 21 00 00       	call   4068 <printf>
      exit();
    1eea:	e8 e9 1f 00 00       	call   3ed8 <exit>
      exit();
    }
  }

  unlink("bd");
  for(i = 0; i < 500; i++){
    1eef:	ff 45 f4             	incl   -0xc(%ebp)
    1ef2:	81 7d f4 f3 01 00 00 	cmpl   $0x1f3,-0xc(%ebp)
    1ef9:	7e 9a                	jle    1e95 <bigdir+0xf3>
      printf(1, "bigdir unlink failed");
      exit();
    }
  }

  printf(1, "bigdir ok\n");
    1efb:	c7 44 24 04 0e 4e 00 	movl   $0x4e0e,0x4(%esp)
    1f02:	00 
    1f03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f0a:	e8 59 21 00 00       	call   4068 <printf>
}
    1f0f:	c9                   	leave  
    1f10:	c3                   	ret    

00001f11 <subdir>:

void
subdir(void)
{
    1f11:	55                   	push   %ebp
    1f12:	89 e5                	mov    %esp,%ebp
    1f14:	83 ec 28             	sub    $0x28,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1f17:	c7 44 24 04 19 4e 00 	movl   $0x4e19,0x4(%esp)
    1f1e:	00 
    1f1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f26:	e8 3d 21 00 00       	call   4068 <printf>

  unlink("ff");
    1f2b:	c7 04 24 26 4e 00 00 	movl   $0x4e26,(%esp)
    1f32:	e8 f1 1f 00 00       	call   3f28 <unlink>
  if(mkdir("dd") != 0){
    1f37:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    1f3e:	e8 fd 1f 00 00       	call   3f40 <mkdir>
    1f43:	85 c0                	test   %eax,%eax
    1f45:	74 19                	je     1f60 <subdir+0x4f>
    printf(1, "subdir mkdir dd failed\n");
    1f47:	c7 44 24 04 2c 4e 00 	movl   $0x4e2c,0x4(%esp)
    1f4e:	00 
    1f4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f56:	e8 0d 21 00 00       	call   4068 <printf>
    exit();
    1f5b:	e8 78 1f 00 00       	call   3ed8 <exit>
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1f60:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    1f67:	00 
    1f68:	c7 04 24 44 4e 00 00 	movl   $0x4e44,(%esp)
    1f6f:	e8 a4 1f 00 00       	call   3f18 <open>
    1f74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    1f77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1f7b:	79 19                	jns    1f96 <subdir+0x85>
    printf(1, "create dd/ff failed\n");
    1f7d:	c7 44 24 04 4a 4e 00 	movl   $0x4e4a,0x4(%esp)
    1f84:	00 
    1f85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1f8c:	e8 d7 20 00 00       	call   4068 <printf>
    exit();
    1f91:	e8 42 1f 00 00       	call   3ed8 <exit>
  }
  write(fd, "ff", 2);
    1f96:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    1f9d:	00 
    1f9e:	c7 44 24 04 26 4e 00 	movl   $0x4e26,0x4(%esp)
    1fa5:	00 
    1fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fa9:	89 04 24             	mov    %eax,(%esp)
    1fac:	e8 47 1f 00 00       	call   3ef8 <write>
  close(fd);
    1fb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1fb4:	89 04 24             	mov    %eax,(%esp)
    1fb7:	e8 44 1f 00 00       	call   3f00 <close>
  
  if(unlink("dd") >= 0){
    1fbc:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    1fc3:	e8 60 1f 00 00       	call   3f28 <unlink>
    1fc8:	85 c0                	test   %eax,%eax
    1fca:	78 19                	js     1fe5 <subdir+0xd4>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1fcc:	c7 44 24 04 60 4e 00 	movl   $0x4e60,0x4(%esp)
    1fd3:	00 
    1fd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1fdb:	e8 88 20 00 00       	call   4068 <printf>
    exit();
    1fe0:	e8 f3 1e 00 00       	call   3ed8 <exit>
  }

  if(mkdir("/dd/dd") != 0){
    1fe5:	c7 04 24 86 4e 00 00 	movl   $0x4e86,(%esp)
    1fec:	e8 4f 1f 00 00       	call   3f40 <mkdir>
    1ff1:	85 c0                	test   %eax,%eax
    1ff3:	74 19                	je     200e <subdir+0xfd>
    printf(1, "subdir mkdir dd/dd failed\n");
    1ff5:	c7 44 24 04 8d 4e 00 	movl   $0x4e8d,0x4(%esp)
    1ffc:	00 
    1ffd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2004:	e8 5f 20 00 00       	call   4068 <printf>
    exit();
    2009:	e8 ca 1e 00 00       	call   3ed8 <exit>
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    200e:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2015:	00 
    2016:	c7 04 24 a8 4e 00 00 	movl   $0x4ea8,(%esp)
    201d:	e8 f6 1e 00 00       	call   3f18 <open>
    2022:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2029:	79 19                	jns    2044 <subdir+0x133>
    printf(1, "create dd/dd/ff failed\n");
    202b:	c7 44 24 04 b1 4e 00 	movl   $0x4eb1,0x4(%esp)
    2032:	00 
    2033:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    203a:	e8 29 20 00 00       	call   4068 <printf>
    exit();
    203f:	e8 94 1e 00 00       	call   3ed8 <exit>
  }
  write(fd, "FF", 2);
    2044:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
    204b:	00 
    204c:	c7 44 24 04 c9 4e 00 	movl   $0x4ec9,0x4(%esp)
    2053:	00 
    2054:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2057:	89 04 24             	mov    %eax,(%esp)
    205a:	e8 99 1e 00 00       	call   3ef8 <write>
  close(fd);
    205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2062:	89 04 24             	mov    %eax,(%esp)
    2065:	e8 96 1e 00 00       	call   3f00 <close>

  fd = open("dd/dd/../ff", 0);
    206a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2071:	00 
    2072:	c7 04 24 cc 4e 00 00 	movl   $0x4ecc,(%esp)
    2079:	e8 9a 1e 00 00       	call   3f18 <open>
    207e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2085:	79 19                	jns    20a0 <subdir+0x18f>
    printf(1, "open dd/dd/../ff failed\n");
    2087:	c7 44 24 04 d8 4e 00 	movl   $0x4ed8,0x4(%esp)
    208e:	00 
    208f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2096:	e8 cd 1f 00 00       	call   4068 <printf>
    exit();
    209b:	e8 38 1e 00 00       	call   3ed8 <exit>
  }
  cc = read(fd, buf, sizeof(buf));
    20a0:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    20a7:	00 
    20a8:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    20af:	00 
    20b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20b3:	89 04 24             	mov    %eax,(%esp)
    20b6:	e8 35 1e 00 00       	call   3ef0 <read>
    20bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(cc != 2 || buf[0] != 'f'){
    20be:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
    20c2:	75 09                	jne    20cd <subdir+0x1bc>
    20c4:	a0 20 8b 00 00       	mov    0x8b20,%al
    20c9:	3c 66                	cmp    $0x66,%al
    20cb:	74 19                	je     20e6 <subdir+0x1d5>
    printf(1, "dd/dd/../ff wrong content\n");
    20cd:	c7 44 24 04 f1 4e 00 	movl   $0x4ef1,0x4(%esp)
    20d4:	00 
    20d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    20dc:	e8 87 1f 00 00       	call   4068 <printf>
    exit();
    20e1:	e8 f2 1d 00 00       	call   3ed8 <exit>
  }
  close(fd);
    20e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    20e9:	89 04 24             	mov    %eax,(%esp)
    20ec:	e8 0f 1e 00 00       	call   3f00 <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    20f1:	c7 44 24 04 0c 4f 00 	movl   $0x4f0c,0x4(%esp)
    20f8:	00 
    20f9:	c7 04 24 a8 4e 00 00 	movl   $0x4ea8,(%esp)
    2100:	e8 33 1e 00 00       	call   3f38 <link>
    2105:	85 c0                	test   %eax,%eax
    2107:	74 19                	je     2122 <subdir+0x211>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2109:	c7 44 24 04 18 4f 00 	movl   $0x4f18,0x4(%esp)
    2110:	00 
    2111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2118:	e8 4b 1f 00 00       	call   4068 <printf>
    exit();
    211d:	e8 b6 1d 00 00       	call   3ed8 <exit>
  }

  if(unlink("dd/dd/ff") != 0){
    2122:	c7 04 24 a8 4e 00 00 	movl   $0x4ea8,(%esp)
    2129:	e8 fa 1d 00 00       	call   3f28 <unlink>
    212e:	85 c0                	test   %eax,%eax
    2130:	74 19                	je     214b <subdir+0x23a>
    printf(1, "unlink dd/dd/ff failed\n");
    2132:	c7 44 24 04 39 4f 00 	movl   $0x4f39,0x4(%esp)
    2139:	00 
    213a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2141:	e8 22 1f 00 00       	call   4068 <printf>
    exit();
    2146:	e8 8d 1d 00 00       	call   3ed8 <exit>
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    214b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2152:	00 
    2153:	c7 04 24 a8 4e 00 00 	movl   $0x4ea8,(%esp)
    215a:	e8 b9 1d 00 00       	call   3f18 <open>
    215f:	85 c0                	test   %eax,%eax
    2161:	78 19                	js     217c <subdir+0x26b>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2163:	c7 44 24 04 54 4f 00 	movl   $0x4f54,0x4(%esp)
    216a:	00 
    216b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2172:	e8 f1 1e 00 00       	call   4068 <printf>
    exit();
    2177:	e8 5c 1d 00 00       	call   3ed8 <exit>
  }

  if(chdir("dd") != 0){
    217c:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    2183:	e8 c0 1d 00 00       	call   3f48 <chdir>
    2188:	85 c0                	test   %eax,%eax
    218a:	74 19                	je     21a5 <subdir+0x294>
    printf(1, "chdir dd failed\n");
    218c:	c7 44 24 04 78 4f 00 	movl   $0x4f78,0x4(%esp)
    2193:	00 
    2194:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    219b:	e8 c8 1e 00 00       	call   4068 <printf>
    exit();
    21a0:	e8 33 1d 00 00       	call   3ed8 <exit>
  }
  if(chdir("dd/../../dd") != 0){
    21a5:	c7 04 24 89 4f 00 00 	movl   $0x4f89,(%esp)
    21ac:	e8 97 1d 00 00       	call   3f48 <chdir>
    21b1:	85 c0                	test   %eax,%eax
    21b3:	74 19                	je     21ce <subdir+0x2bd>
    printf(1, "chdir dd/../../dd failed\n");
    21b5:	c7 44 24 04 95 4f 00 	movl   $0x4f95,0x4(%esp)
    21bc:	00 
    21bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21c4:	e8 9f 1e 00 00       	call   4068 <printf>
    exit();
    21c9:	e8 0a 1d 00 00       	call   3ed8 <exit>
  }
  if(chdir("dd/../../../dd") != 0){
    21ce:	c7 04 24 af 4f 00 00 	movl   $0x4faf,(%esp)
    21d5:	e8 6e 1d 00 00       	call   3f48 <chdir>
    21da:	85 c0                	test   %eax,%eax
    21dc:	74 19                	je     21f7 <subdir+0x2e6>
    printf(1, "chdir dd/../../dd failed\n");
    21de:	c7 44 24 04 95 4f 00 	movl   $0x4f95,0x4(%esp)
    21e5:	00 
    21e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    21ed:	e8 76 1e 00 00       	call   4068 <printf>
    exit();
    21f2:	e8 e1 1c 00 00       	call   3ed8 <exit>
  }
  if(chdir("./..") != 0){
    21f7:	c7 04 24 be 4f 00 00 	movl   $0x4fbe,(%esp)
    21fe:	e8 45 1d 00 00       	call   3f48 <chdir>
    2203:	85 c0                	test   %eax,%eax
    2205:	74 19                	je     2220 <subdir+0x30f>
    printf(1, "chdir ./.. failed\n");
    2207:	c7 44 24 04 c3 4f 00 	movl   $0x4fc3,0x4(%esp)
    220e:	00 
    220f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2216:	e8 4d 1e 00 00       	call   4068 <printf>
    exit();
    221b:	e8 b8 1c 00 00       	call   3ed8 <exit>
  }

  fd = open("dd/dd/ffff", 0);
    2220:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2227:	00 
    2228:	c7 04 24 0c 4f 00 00 	movl   $0x4f0c,(%esp)
    222f:	e8 e4 1c 00 00       	call   3f18 <open>
    2234:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2237:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    223b:	79 19                	jns    2256 <subdir+0x345>
    printf(1, "open dd/dd/ffff failed\n");
    223d:	c7 44 24 04 d6 4f 00 	movl   $0x4fd6,0x4(%esp)
    2244:	00 
    2245:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    224c:	e8 17 1e 00 00       	call   4068 <printf>
    exit();
    2251:	e8 82 1c 00 00       	call   3ed8 <exit>
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    2256:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
    225d:	00 
    225e:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    2265:	00 
    2266:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2269:	89 04 24             	mov    %eax,(%esp)
    226c:	e8 7f 1c 00 00       	call   3ef0 <read>
    2271:	83 f8 02             	cmp    $0x2,%eax
    2274:	74 19                	je     228f <subdir+0x37e>
    printf(1, "read dd/dd/ffff wrong len\n");
    2276:	c7 44 24 04 ee 4f 00 	movl   $0x4fee,0x4(%esp)
    227d:	00 
    227e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2285:	e8 de 1d 00 00       	call   4068 <printf>
    exit();
    228a:	e8 49 1c 00 00       	call   3ed8 <exit>
  }
  close(fd);
    228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2292:	89 04 24             	mov    %eax,(%esp)
    2295:	e8 66 1c 00 00       	call   3f00 <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    229a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    22a1:	00 
    22a2:	c7 04 24 a8 4e 00 00 	movl   $0x4ea8,(%esp)
    22a9:	e8 6a 1c 00 00       	call   3f18 <open>
    22ae:	85 c0                	test   %eax,%eax
    22b0:	78 19                	js     22cb <subdir+0x3ba>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    22b2:	c7 44 24 04 0c 50 00 	movl   $0x500c,0x4(%esp)
    22b9:	00 
    22ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22c1:	e8 a2 1d 00 00       	call   4068 <printf>
    exit();
    22c6:	e8 0d 1c 00 00       	call   3ed8 <exit>
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    22cb:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    22d2:	00 
    22d3:	c7 04 24 31 50 00 00 	movl   $0x5031,(%esp)
    22da:	e8 39 1c 00 00       	call   3f18 <open>
    22df:	85 c0                	test   %eax,%eax
    22e1:	78 19                	js     22fc <subdir+0x3eb>
    printf(1, "create dd/ff/ff succeeded!\n");
    22e3:	c7 44 24 04 3a 50 00 	movl   $0x503a,0x4(%esp)
    22ea:	00 
    22eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    22f2:	e8 71 1d 00 00       	call   4068 <printf>
    exit();
    22f7:	e8 dc 1b 00 00       	call   3ed8 <exit>
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    22fc:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2303:	00 
    2304:	c7 04 24 56 50 00 00 	movl   $0x5056,(%esp)
    230b:	e8 08 1c 00 00       	call   3f18 <open>
    2310:	85 c0                	test   %eax,%eax
    2312:	78 19                	js     232d <subdir+0x41c>
    printf(1, "create dd/xx/ff succeeded!\n");
    2314:	c7 44 24 04 5f 50 00 	movl   $0x505f,0x4(%esp)
    231b:	00 
    231c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2323:	e8 40 1d 00 00       	call   4068 <printf>
    exit();
    2328:	e8 ab 1b 00 00       	call   3ed8 <exit>
  }
  if(open("dd", O_CREATE) >= 0){
    232d:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2334:	00 
    2335:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    233c:	e8 d7 1b 00 00       	call   3f18 <open>
    2341:	85 c0                	test   %eax,%eax
    2343:	78 19                	js     235e <subdir+0x44d>
    printf(1, "create dd succeeded!\n");
    2345:	c7 44 24 04 7b 50 00 	movl   $0x507b,0x4(%esp)
    234c:	00 
    234d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2354:	e8 0f 1d 00 00       	call   4068 <printf>
    exit();
    2359:	e8 7a 1b 00 00       	call   3ed8 <exit>
  }
  if(open("dd", O_RDWR) >= 0){
    235e:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2365:	00 
    2366:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    236d:	e8 a6 1b 00 00       	call   3f18 <open>
    2372:	85 c0                	test   %eax,%eax
    2374:	78 19                	js     238f <subdir+0x47e>
    printf(1, "open dd rdwr succeeded!\n");
    2376:	c7 44 24 04 91 50 00 	movl   $0x5091,0x4(%esp)
    237d:	00 
    237e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2385:	e8 de 1c 00 00       	call   4068 <printf>
    exit();
    238a:	e8 49 1b 00 00       	call   3ed8 <exit>
  }
  if(open("dd", O_WRONLY) >= 0){
    238f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    2396:	00 
    2397:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    239e:	e8 75 1b 00 00       	call   3f18 <open>
    23a3:	85 c0                	test   %eax,%eax
    23a5:	78 19                	js     23c0 <subdir+0x4af>
    printf(1, "open dd wronly succeeded!\n");
    23a7:	c7 44 24 04 aa 50 00 	movl   $0x50aa,0x4(%esp)
    23ae:	00 
    23af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23b6:	e8 ad 1c 00 00       	call   4068 <printf>
    exit();
    23bb:	e8 18 1b 00 00       	call   3ed8 <exit>
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    23c0:	c7 44 24 04 c5 50 00 	movl   $0x50c5,0x4(%esp)
    23c7:	00 
    23c8:	c7 04 24 31 50 00 00 	movl   $0x5031,(%esp)
    23cf:	e8 64 1b 00 00       	call   3f38 <link>
    23d4:	85 c0                	test   %eax,%eax
    23d6:	75 19                	jne    23f1 <subdir+0x4e0>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    23d8:	c7 44 24 04 d0 50 00 	movl   $0x50d0,0x4(%esp)
    23df:	00 
    23e0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    23e7:	e8 7c 1c 00 00       	call   4068 <printf>
    exit();
    23ec:	e8 e7 1a 00 00       	call   3ed8 <exit>
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    23f1:	c7 44 24 04 c5 50 00 	movl   $0x50c5,0x4(%esp)
    23f8:	00 
    23f9:	c7 04 24 56 50 00 00 	movl   $0x5056,(%esp)
    2400:	e8 33 1b 00 00       	call   3f38 <link>
    2405:	85 c0                	test   %eax,%eax
    2407:	75 19                	jne    2422 <subdir+0x511>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2409:	c7 44 24 04 f4 50 00 	movl   $0x50f4,0x4(%esp)
    2410:	00 
    2411:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2418:	e8 4b 1c 00 00       	call   4068 <printf>
    exit();
    241d:	e8 b6 1a 00 00       	call   3ed8 <exit>
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2422:	c7 44 24 04 0c 4f 00 	movl   $0x4f0c,0x4(%esp)
    2429:	00 
    242a:	c7 04 24 44 4e 00 00 	movl   $0x4e44,(%esp)
    2431:	e8 02 1b 00 00       	call   3f38 <link>
    2436:	85 c0                	test   %eax,%eax
    2438:	75 19                	jne    2453 <subdir+0x542>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    243a:	c7 44 24 04 18 51 00 	movl   $0x5118,0x4(%esp)
    2441:	00 
    2442:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2449:	e8 1a 1c 00 00       	call   4068 <printf>
    exit();
    244e:	e8 85 1a 00 00       	call   3ed8 <exit>
  }
  if(mkdir("dd/ff/ff") == 0){
    2453:	c7 04 24 31 50 00 00 	movl   $0x5031,(%esp)
    245a:	e8 e1 1a 00 00       	call   3f40 <mkdir>
    245f:	85 c0                	test   %eax,%eax
    2461:	75 19                	jne    247c <subdir+0x56b>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2463:	c7 44 24 04 3a 51 00 	movl   $0x513a,0x4(%esp)
    246a:	00 
    246b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2472:	e8 f1 1b 00 00       	call   4068 <printf>
    exit();
    2477:	e8 5c 1a 00 00       	call   3ed8 <exit>
  }
  if(mkdir("dd/xx/ff") == 0){
    247c:	c7 04 24 56 50 00 00 	movl   $0x5056,(%esp)
    2483:	e8 b8 1a 00 00       	call   3f40 <mkdir>
    2488:	85 c0                	test   %eax,%eax
    248a:	75 19                	jne    24a5 <subdir+0x594>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    248c:	c7 44 24 04 55 51 00 	movl   $0x5155,0x4(%esp)
    2493:	00 
    2494:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    249b:	e8 c8 1b 00 00       	call   4068 <printf>
    exit();
    24a0:	e8 33 1a 00 00       	call   3ed8 <exit>
  }
  if(mkdir("dd/dd/ffff") == 0){
    24a5:	c7 04 24 0c 4f 00 00 	movl   $0x4f0c,(%esp)
    24ac:	e8 8f 1a 00 00       	call   3f40 <mkdir>
    24b1:	85 c0                	test   %eax,%eax
    24b3:	75 19                	jne    24ce <subdir+0x5bd>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    24b5:	c7 44 24 04 70 51 00 	movl   $0x5170,0x4(%esp)
    24bc:	00 
    24bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24c4:	e8 9f 1b 00 00       	call   4068 <printf>
    exit();
    24c9:	e8 0a 1a 00 00       	call   3ed8 <exit>
  }
  if(unlink("dd/xx/ff") == 0){
    24ce:	c7 04 24 56 50 00 00 	movl   $0x5056,(%esp)
    24d5:	e8 4e 1a 00 00       	call   3f28 <unlink>
    24da:	85 c0                	test   %eax,%eax
    24dc:	75 19                	jne    24f7 <subdir+0x5e6>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    24de:	c7 44 24 04 8d 51 00 	movl   $0x518d,0x4(%esp)
    24e5:	00 
    24e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    24ed:	e8 76 1b 00 00       	call   4068 <printf>
    exit();
    24f2:	e8 e1 19 00 00       	call   3ed8 <exit>
  }
  if(unlink("dd/ff/ff") == 0){
    24f7:	c7 04 24 31 50 00 00 	movl   $0x5031,(%esp)
    24fe:	e8 25 1a 00 00       	call   3f28 <unlink>
    2503:	85 c0                	test   %eax,%eax
    2505:	75 19                	jne    2520 <subdir+0x60f>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2507:	c7 44 24 04 a9 51 00 	movl   $0x51a9,0x4(%esp)
    250e:	00 
    250f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2516:	e8 4d 1b 00 00       	call   4068 <printf>
    exit();
    251b:	e8 b8 19 00 00       	call   3ed8 <exit>
  }
  if(chdir("dd/ff") == 0){
    2520:	c7 04 24 44 4e 00 00 	movl   $0x4e44,(%esp)
    2527:	e8 1c 1a 00 00       	call   3f48 <chdir>
    252c:	85 c0                	test   %eax,%eax
    252e:	75 19                	jne    2549 <subdir+0x638>
    printf(1, "chdir dd/ff succeeded!\n");
    2530:	c7 44 24 04 c5 51 00 	movl   $0x51c5,0x4(%esp)
    2537:	00 
    2538:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    253f:	e8 24 1b 00 00       	call   4068 <printf>
    exit();
    2544:	e8 8f 19 00 00       	call   3ed8 <exit>
  }
  if(chdir("dd/xx") == 0){
    2549:	c7 04 24 dd 51 00 00 	movl   $0x51dd,(%esp)
    2550:	e8 f3 19 00 00       	call   3f48 <chdir>
    2555:	85 c0                	test   %eax,%eax
    2557:	75 19                	jne    2572 <subdir+0x661>
    printf(1, "chdir dd/xx succeeded!\n");
    2559:	c7 44 24 04 e3 51 00 	movl   $0x51e3,0x4(%esp)
    2560:	00 
    2561:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2568:	e8 fb 1a 00 00       	call   4068 <printf>
    exit();
    256d:	e8 66 19 00 00       	call   3ed8 <exit>
  }

  if(unlink("dd/dd/ffff") != 0){
    2572:	c7 04 24 0c 4f 00 00 	movl   $0x4f0c,(%esp)
    2579:	e8 aa 19 00 00       	call   3f28 <unlink>
    257e:	85 c0                	test   %eax,%eax
    2580:	74 19                	je     259b <subdir+0x68a>
    printf(1, "unlink dd/dd/ff failed\n");
    2582:	c7 44 24 04 39 4f 00 	movl   $0x4f39,0x4(%esp)
    2589:	00 
    258a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2591:	e8 d2 1a 00 00       	call   4068 <printf>
    exit();
    2596:	e8 3d 19 00 00       	call   3ed8 <exit>
  }
  if(unlink("dd/ff") != 0){
    259b:	c7 04 24 44 4e 00 00 	movl   $0x4e44,(%esp)
    25a2:	e8 81 19 00 00       	call   3f28 <unlink>
    25a7:	85 c0                	test   %eax,%eax
    25a9:	74 19                	je     25c4 <subdir+0x6b3>
    printf(1, "unlink dd/ff failed\n");
    25ab:	c7 44 24 04 fb 51 00 	movl   $0x51fb,0x4(%esp)
    25b2:	00 
    25b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25ba:	e8 a9 1a 00 00       	call   4068 <printf>
    exit();
    25bf:	e8 14 19 00 00       	call   3ed8 <exit>
  }
  if(unlink("dd") == 0){
    25c4:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    25cb:	e8 58 19 00 00       	call   3f28 <unlink>
    25d0:	85 c0                	test   %eax,%eax
    25d2:	75 19                	jne    25ed <subdir+0x6dc>
    printf(1, "unlink non-empty dd succeeded!\n");
    25d4:	c7 44 24 04 10 52 00 	movl   $0x5210,0x4(%esp)
    25db:	00 
    25dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    25e3:	e8 80 1a 00 00       	call   4068 <printf>
    exit();
    25e8:	e8 eb 18 00 00       	call   3ed8 <exit>
  }
  if(unlink("dd/dd") < 0){
    25ed:	c7 04 24 30 52 00 00 	movl   $0x5230,(%esp)
    25f4:	e8 2f 19 00 00       	call   3f28 <unlink>
    25f9:	85 c0                	test   %eax,%eax
    25fb:	79 19                	jns    2616 <subdir+0x705>
    printf(1, "unlink dd/dd failed\n");
    25fd:	c7 44 24 04 36 52 00 	movl   $0x5236,0x4(%esp)
    2604:	00 
    2605:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    260c:	e8 57 1a 00 00       	call   4068 <printf>
    exit();
    2611:	e8 c2 18 00 00       	call   3ed8 <exit>
  }
  if(unlink("dd") < 0){
    2616:	c7 04 24 29 4e 00 00 	movl   $0x4e29,(%esp)
    261d:	e8 06 19 00 00       	call   3f28 <unlink>
    2622:	85 c0                	test   %eax,%eax
    2624:	79 19                	jns    263f <subdir+0x72e>
    printf(1, "unlink dd failed\n");
    2626:	c7 44 24 04 4b 52 00 	movl   $0x524b,0x4(%esp)
    262d:	00 
    262e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2635:	e8 2e 1a 00 00       	call   4068 <printf>
    exit();
    263a:	e8 99 18 00 00       	call   3ed8 <exit>
  }

  printf(1, "subdir ok\n");
    263f:	c7 44 24 04 5d 52 00 	movl   $0x525d,0x4(%esp)
    2646:	00 
    2647:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    264e:	e8 15 1a 00 00       	call   4068 <printf>
}
    2653:	c9                   	leave  
    2654:	c3                   	ret    

00002655 <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    2655:	55                   	push   %ebp
    2656:	89 e5                	mov    %esp,%ebp
    2658:	83 ec 28             	sub    $0x28,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    265b:	c7 44 24 04 68 52 00 	movl   $0x5268,0x4(%esp)
    2662:	00 
    2663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    266a:	e8 f9 19 00 00       	call   4068 <printf>

  unlink("bigwrite");
    266f:	c7 04 24 77 52 00 00 	movl   $0x5277,(%esp)
    2676:	e8 ad 18 00 00       	call   3f28 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    267b:	c7 45 f4 f3 01 00 00 	movl   $0x1f3,-0xc(%ebp)
    2682:	e9 b2 00 00 00       	jmp    2739 <bigwrite+0xe4>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2687:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    268e:	00 
    268f:	c7 04 24 77 52 00 00 	movl   $0x5277,(%esp)
    2696:	e8 7d 18 00 00       	call   3f18 <open>
    269b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fd < 0){
    269e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    26a2:	79 19                	jns    26bd <bigwrite+0x68>
      printf(1, "cannot create bigwrite\n");
    26a4:	c7 44 24 04 80 52 00 	movl   $0x5280,0x4(%esp)
    26ab:	00 
    26ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    26b3:	e8 b0 19 00 00       	call   4068 <printf>
      exit();
    26b8:	e8 1b 18 00 00       	call   3ed8 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
    26bd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    26c4:	eb 4f                	jmp    2715 <bigwrite+0xc0>
      int cc = write(fd, buf, sz);
    26c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26c9:	89 44 24 08          	mov    %eax,0x8(%esp)
    26cd:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    26d4:	00 
    26d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    26d8:	89 04 24             	mov    %eax,(%esp)
    26db:	e8 18 18 00 00       	call   3ef8 <write>
    26e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(cc != sz){
    26e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26e6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    26e9:	74 27                	je     2712 <bigwrite+0xbd>
        printf(1, "write(%d) ret %d\n", sz, cc);
    26eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
    26ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
    26f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    26f5:	89 44 24 08          	mov    %eax,0x8(%esp)
    26f9:	c7 44 24 04 98 52 00 	movl   $0x5298,0x4(%esp)
    2700:	00 
    2701:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2708:	e8 5b 19 00 00       	call   4068 <printf>
        exit();
    270d:	e8 c6 17 00 00       	call   3ed8 <exit>
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
      exit();
    }
    int i;
    for(i = 0; i < 2; i++){
    2712:	ff 45 f0             	incl   -0x10(%ebp)
    2715:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
    2719:	7e ab                	jle    26c6 <bigwrite+0x71>
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
        exit();
      }
    }
    close(fd);
    271b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    271e:	89 04 24             	mov    %eax,(%esp)
    2721:	e8 da 17 00 00       	call   3f00 <close>
    unlink("bigwrite");
    2726:	c7 04 24 77 52 00 00 	movl   $0x5277,(%esp)
    272d:	e8 f6 17 00 00       	call   3f28 <unlink>
  int fd, sz;

  printf(1, "bigwrite test\n");

  unlink("bigwrite");
  for(sz = 499; sz < 12*512; sz += 471){
    2732:	81 45 f4 d7 01 00 00 	addl   $0x1d7,-0xc(%ebp)
    2739:	81 7d f4 ff 17 00 00 	cmpl   $0x17ff,-0xc(%ebp)
    2740:	0f 8e 41 ff ff ff    	jle    2687 <bigwrite+0x32>
    }
    close(fd);
    unlink("bigwrite");
  }

  printf(1, "bigwrite ok\n");
    2746:	c7 44 24 04 aa 52 00 	movl   $0x52aa,0x4(%esp)
    274d:	00 
    274e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2755:	e8 0e 19 00 00       	call   4068 <printf>
}
    275a:	c9                   	leave  
    275b:	c3                   	ret    

0000275c <bigfile>:

void
bigfile(void)
{
    275c:	55                   	push   %ebp
    275d:	89 e5                	mov    %esp,%ebp
    275f:	83 ec 28             	sub    $0x28,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2762:	c7 44 24 04 b7 52 00 	movl   $0x52b7,0x4(%esp)
    2769:	00 
    276a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2771:	e8 f2 18 00 00       	call   4068 <printf>

  unlink("bigfile");
    2776:	c7 04 24 c5 52 00 00 	movl   $0x52c5,(%esp)
    277d:	e8 a6 17 00 00       	call   3f28 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2782:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    2789:	00 
    278a:	c7 04 24 c5 52 00 00 	movl   $0x52c5,(%esp)
    2791:	e8 82 17 00 00       	call   3f18 <open>
    2796:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2799:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    279d:	79 19                	jns    27b8 <bigfile+0x5c>
    printf(1, "cannot create bigfile");
    279f:	c7 44 24 04 cd 52 00 	movl   $0x52cd,0x4(%esp)
    27a6:	00 
    27a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    27ae:	e8 b5 18 00 00       	call   4068 <printf>
    exit();
    27b3:	e8 20 17 00 00       	call   3ed8 <exit>
  }
  for(i = 0; i < 20; i++){
    27b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    27bf:	eb 59                	jmp    281a <bigfile+0xbe>
    memset(buf, i, 600);
    27c1:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    27c8:	00 
    27c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    27cc:	89 44 24 04          	mov    %eax,0x4(%esp)
    27d0:	c7 04 24 20 8b 00 00 	movl   $0x8b20,(%esp)
    27d7:	e8 34 15 00 00       	call   3d10 <memset>
    if(write(fd, buf, 600) != 600){
    27dc:	c7 44 24 08 58 02 00 	movl   $0x258,0x8(%esp)
    27e3:	00 
    27e4:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    27eb:	00 
    27ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
    27ef:	89 04 24             	mov    %eax,(%esp)
    27f2:	e8 01 17 00 00       	call   3ef8 <write>
    27f7:	3d 58 02 00 00       	cmp    $0x258,%eax
    27fc:	74 19                	je     2817 <bigfile+0xbb>
      printf(1, "write bigfile failed\n");
    27fe:	c7 44 24 04 e3 52 00 	movl   $0x52e3,0x4(%esp)
    2805:	00 
    2806:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    280d:	e8 56 18 00 00       	call   4068 <printf>
      exit();
    2812:	e8 c1 16 00 00       	call   3ed8 <exit>
  fd = open("bigfile", O_CREATE | O_RDWR);
  if(fd < 0){
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2817:	ff 45 f4             	incl   -0xc(%ebp)
    281a:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
    281e:	7e a1                	jle    27c1 <bigfile+0x65>
    if(write(fd, buf, 600) != 600){
      printf(1, "write bigfile failed\n");
      exit();
    }
  }
  close(fd);
    2820:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2823:	89 04 24             	mov    %eax,(%esp)
    2826:	e8 d5 16 00 00       	call   3f00 <close>

  fd = open("bigfile", 0);
    282b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2832:	00 
    2833:	c7 04 24 c5 52 00 00 	movl   $0x52c5,(%esp)
    283a:	e8 d9 16 00 00       	call   3f18 <open>
    283f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    2842:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    2846:	79 19                	jns    2861 <bigfile+0x105>
    printf(1, "cannot open bigfile\n");
    2848:	c7 44 24 04 f9 52 00 	movl   $0x52f9,0x4(%esp)
    284f:	00 
    2850:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2857:	e8 0c 18 00 00       	call   4068 <printf>
    exit();
    285c:	e8 77 16 00 00       	call   3ed8 <exit>
  }
  total = 0;
    2861:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(i = 0; ; i++){
    2868:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    cc = read(fd, buf, 300);
    286f:	c7 44 24 08 2c 01 00 	movl   $0x12c,0x8(%esp)
    2876:	00 
    2877:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    287e:	00 
    287f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    2882:	89 04 24             	mov    %eax,(%esp)
    2885:	e8 66 16 00 00       	call   3ef0 <read>
    288a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(cc < 0){
    288d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    2891:	79 19                	jns    28ac <bigfile+0x150>
      printf(1, "read bigfile failed\n");
    2893:	c7 44 24 04 0e 53 00 	movl   $0x530e,0x4(%esp)
    289a:	00 
    289b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28a2:	e8 c1 17 00 00       	call   4068 <printf>
      exit();
    28a7:	e8 2c 16 00 00       	call   3ed8 <exit>
    }
    if(cc == 0)
    28ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    28b0:	74 79                	je     292b <bigfile+0x1cf>
      break;
    if(cc != 300){
    28b2:	81 7d e8 2c 01 00 00 	cmpl   $0x12c,-0x18(%ebp)
    28b9:	74 19                	je     28d4 <bigfile+0x178>
      printf(1, "short read bigfile\n");
    28bb:	c7 44 24 04 23 53 00 	movl   $0x5323,0x4(%esp)
    28c2:	00 
    28c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    28ca:	e8 99 17 00 00       	call   4068 <printf>
      exit();
    28cf:	e8 04 16 00 00       	call   3ed8 <exit>
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    28d4:	a0 20 8b 00 00       	mov    0x8b20,%al
    28d9:	0f be d0             	movsbl %al,%edx
    28dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28df:	89 c1                	mov    %eax,%ecx
    28e1:	c1 e9 1f             	shr    $0x1f,%ecx
    28e4:	01 c8                	add    %ecx,%eax
    28e6:	d1 f8                	sar    %eax
    28e8:	39 c2                	cmp    %eax,%edx
    28ea:	75 18                	jne    2904 <bigfile+0x1a8>
    28ec:	a0 4b 8c 00 00       	mov    0x8c4b,%al
    28f1:	0f be d0             	movsbl %al,%edx
    28f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    28f7:	89 c1                	mov    %eax,%ecx
    28f9:	c1 e9 1f             	shr    $0x1f,%ecx
    28fc:	01 c8                	add    %ecx,%eax
    28fe:	d1 f8                	sar    %eax
    2900:	39 c2                	cmp    %eax,%edx
    2902:	74 19                	je     291d <bigfile+0x1c1>
      printf(1, "read bigfile wrong data\n");
    2904:	c7 44 24 04 37 53 00 	movl   $0x5337,0x4(%esp)
    290b:	00 
    290c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2913:	e8 50 17 00 00       	call   4068 <printf>
      exit();
    2918:	e8 bb 15 00 00       	call   3ed8 <exit>
    }
    total += cc;
    291d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    2920:	01 45 f0             	add    %eax,-0x10(%ebp)
  if(fd < 0){
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
  for(i = 0; ; i++){
    2923:	ff 45 f4             	incl   -0xc(%ebp)
    if(buf[0] != i/2 || buf[299] != i/2){
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
    2926:	e9 44 ff ff ff       	jmp    286f <bigfile+0x113>
    if(cc < 0){
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
      break;
    292b:	90                   	nop
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
  }
  close(fd);
    292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    292f:	89 04 24             	mov    %eax,(%esp)
    2932:	e8 c9 15 00 00       	call   3f00 <close>
  if(total != 20*600){
    2937:	81 7d f0 e0 2e 00 00 	cmpl   $0x2ee0,-0x10(%ebp)
    293e:	74 19                	je     2959 <bigfile+0x1fd>
    printf(1, "read bigfile wrong total\n");
    2940:	c7 44 24 04 50 53 00 	movl   $0x5350,0x4(%esp)
    2947:	00 
    2948:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    294f:	e8 14 17 00 00       	call   4068 <printf>
    exit();
    2954:	e8 7f 15 00 00       	call   3ed8 <exit>
  }
  unlink("bigfile");
    2959:	c7 04 24 c5 52 00 00 	movl   $0x52c5,(%esp)
    2960:	e8 c3 15 00 00       	call   3f28 <unlink>

  printf(1, "bigfile test ok\n");
    2965:	c7 44 24 04 6a 53 00 	movl   $0x536a,0x4(%esp)
    296c:	00 
    296d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2974:	e8 ef 16 00 00       	call   4068 <printf>
}
    2979:	c9                   	leave  
    297a:	c3                   	ret    

0000297b <fourteen>:

void
fourteen(void)
{
    297b:	55                   	push   %ebp
    297c:	89 e5                	mov    %esp,%ebp
    297e:	83 ec 28             	sub    $0x28,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2981:	c7 44 24 04 7b 53 00 	movl   $0x537b,0x4(%esp)
    2988:	00 
    2989:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2990:	e8 d3 16 00 00       	call   4068 <printf>

  if(mkdir("12345678901234") != 0){
    2995:	c7 04 24 8a 53 00 00 	movl   $0x538a,(%esp)
    299c:	e8 9f 15 00 00       	call   3f40 <mkdir>
    29a1:	85 c0                	test   %eax,%eax
    29a3:	74 19                	je     29be <fourteen+0x43>
    printf(1, "mkdir 12345678901234 failed\n");
    29a5:	c7 44 24 04 99 53 00 	movl   $0x5399,0x4(%esp)
    29ac:	00 
    29ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29b4:	e8 af 16 00 00       	call   4068 <printf>
    exit();
    29b9:	e8 1a 15 00 00       	call   3ed8 <exit>
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    29be:	c7 04 24 b8 53 00 00 	movl   $0x53b8,(%esp)
    29c5:	e8 76 15 00 00       	call   3f40 <mkdir>
    29ca:	85 c0                	test   %eax,%eax
    29cc:	74 19                	je     29e7 <fourteen+0x6c>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    29ce:	c7 44 24 04 d8 53 00 	movl   $0x53d8,0x4(%esp)
    29d5:	00 
    29d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    29dd:	e8 86 16 00 00       	call   4068 <printf>
    exit();
    29e2:	e8 f1 14 00 00       	call   3ed8 <exit>
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29e7:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    29ee:	00 
    29ef:	c7 04 24 08 54 00 00 	movl   $0x5408,(%esp)
    29f6:	e8 1d 15 00 00       	call   3f18 <open>
    29fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    29fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a02:	79 19                	jns    2a1d <fourteen+0xa2>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2a04:	c7 44 24 04 38 54 00 	movl   $0x5438,0x4(%esp)
    2a0b:	00 
    2a0c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a13:	e8 50 16 00 00       	call   4068 <printf>
    exit();
    2a18:	e8 bb 14 00 00       	call   3ed8 <exit>
  }
  close(fd);
    2a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a20:	89 04 24             	mov    %eax,(%esp)
    2a23:	e8 d8 14 00 00       	call   3f00 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2a2f:	00 
    2a30:	c7 04 24 78 54 00 00 	movl   $0x5478,(%esp)
    2a37:	e8 dc 14 00 00       	call   3f18 <open>
    2a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2a3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2a43:	79 19                	jns    2a5e <fourteen+0xe3>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2a45:	c7 44 24 04 a8 54 00 	movl   $0x54a8,0x4(%esp)
    2a4c:	00 
    2a4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a54:	e8 0f 16 00 00       	call   4068 <printf>
    exit();
    2a59:	e8 7a 14 00 00       	call   3ed8 <exit>
  }
  close(fd);
    2a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2a61:	89 04 24             	mov    %eax,(%esp)
    2a64:	e8 97 14 00 00       	call   3f00 <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    2a69:	c7 04 24 e2 54 00 00 	movl   $0x54e2,(%esp)
    2a70:	e8 cb 14 00 00       	call   3f40 <mkdir>
    2a75:	85 c0                	test   %eax,%eax
    2a77:	75 19                	jne    2a92 <fourteen+0x117>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2a79:	c7 44 24 04 00 55 00 	movl   $0x5500,0x4(%esp)
    2a80:	00 
    2a81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2a88:	e8 db 15 00 00       	call   4068 <printf>
    exit();
    2a8d:	e8 46 14 00 00       	call   3ed8 <exit>
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    2a92:	c7 04 24 30 55 00 00 	movl   $0x5530,(%esp)
    2a99:	e8 a2 14 00 00       	call   3f40 <mkdir>
    2a9e:	85 c0                	test   %eax,%eax
    2aa0:	75 19                	jne    2abb <fourteen+0x140>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2aa2:	c7 44 24 04 50 55 00 	movl   $0x5550,0x4(%esp)
    2aa9:	00 
    2aaa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ab1:	e8 b2 15 00 00       	call   4068 <printf>
    exit();
    2ab6:	e8 1d 14 00 00       	call   3ed8 <exit>
  }

  printf(1, "fourteen ok\n");
    2abb:	c7 44 24 04 81 55 00 	movl   $0x5581,0x4(%esp)
    2ac2:	00 
    2ac3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2aca:	e8 99 15 00 00       	call   4068 <printf>
}
    2acf:	c9                   	leave  
    2ad0:	c3                   	ret    

00002ad1 <rmdot>:

void
rmdot(void)
{
    2ad1:	55                   	push   %ebp
    2ad2:	89 e5                	mov    %esp,%ebp
    2ad4:	83 ec 18             	sub    $0x18,%esp
  printf(1, "rmdot test\n");
    2ad7:	c7 44 24 04 8e 55 00 	movl   $0x558e,0x4(%esp)
    2ade:	00 
    2adf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ae6:	e8 7d 15 00 00       	call   4068 <printf>
  if(mkdir("dots") != 0){
    2aeb:	c7 04 24 9a 55 00 00 	movl   $0x559a,(%esp)
    2af2:	e8 49 14 00 00       	call   3f40 <mkdir>
    2af7:	85 c0                	test   %eax,%eax
    2af9:	74 19                	je     2b14 <rmdot+0x43>
    printf(1, "mkdir dots failed\n");
    2afb:	c7 44 24 04 9f 55 00 	movl   $0x559f,0x4(%esp)
    2b02:	00 
    2b03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b0a:	e8 59 15 00 00       	call   4068 <printf>
    exit();
    2b0f:	e8 c4 13 00 00       	call   3ed8 <exit>
  }
  if(chdir("dots") != 0){
    2b14:	c7 04 24 9a 55 00 00 	movl   $0x559a,(%esp)
    2b1b:	e8 28 14 00 00       	call   3f48 <chdir>
    2b20:	85 c0                	test   %eax,%eax
    2b22:	74 19                	je     2b3d <rmdot+0x6c>
    printf(1, "chdir dots failed\n");
    2b24:	c7 44 24 04 b2 55 00 	movl   $0x55b2,0x4(%esp)
    2b2b:	00 
    2b2c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b33:	e8 30 15 00 00       	call   4068 <printf>
    exit();
    2b38:	e8 9b 13 00 00       	call   3ed8 <exit>
  }
  if(unlink(".") == 0){
    2b3d:	c7 04 24 cb 4c 00 00 	movl   $0x4ccb,(%esp)
    2b44:	e8 df 13 00 00       	call   3f28 <unlink>
    2b49:	85 c0                	test   %eax,%eax
    2b4b:	75 19                	jne    2b66 <rmdot+0x95>
    printf(1, "rm . worked!\n");
    2b4d:	c7 44 24 04 c5 55 00 	movl   $0x55c5,0x4(%esp)
    2b54:	00 
    2b55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b5c:	e8 07 15 00 00       	call   4068 <printf>
    exit();
    2b61:	e8 72 13 00 00       	call   3ed8 <exit>
  }
  if(unlink("..") == 0){
    2b66:	c7 04 24 4e 48 00 00 	movl   $0x484e,(%esp)
    2b6d:	e8 b6 13 00 00       	call   3f28 <unlink>
    2b72:	85 c0                	test   %eax,%eax
    2b74:	75 19                	jne    2b8f <rmdot+0xbe>
    printf(1, "rm .. worked!\n");
    2b76:	c7 44 24 04 d3 55 00 	movl   $0x55d3,0x4(%esp)
    2b7d:	00 
    2b7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2b85:	e8 de 14 00 00       	call   4068 <printf>
    exit();
    2b8a:	e8 49 13 00 00       	call   3ed8 <exit>
  }
  if(chdir("/") != 0){
    2b8f:	c7 04 24 a2 44 00 00 	movl   $0x44a2,(%esp)
    2b96:	e8 ad 13 00 00       	call   3f48 <chdir>
    2b9b:	85 c0                	test   %eax,%eax
    2b9d:	74 19                	je     2bb8 <rmdot+0xe7>
    printf(1, "chdir / failed\n");
    2b9f:	c7 44 24 04 a4 44 00 	movl   $0x44a4,0x4(%esp)
    2ba6:	00 
    2ba7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bae:	e8 b5 14 00 00       	call   4068 <printf>
    exit();
    2bb3:	e8 20 13 00 00       	call   3ed8 <exit>
  }
  if(unlink("dots/.") == 0){
    2bb8:	c7 04 24 e2 55 00 00 	movl   $0x55e2,(%esp)
    2bbf:	e8 64 13 00 00       	call   3f28 <unlink>
    2bc4:	85 c0                	test   %eax,%eax
    2bc6:	75 19                	jne    2be1 <rmdot+0x110>
    printf(1, "unlink dots/. worked!\n");
    2bc8:	c7 44 24 04 e9 55 00 	movl   $0x55e9,0x4(%esp)
    2bcf:	00 
    2bd0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2bd7:	e8 8c 14 00 00       	call   4068 <printf>
    exit();
    2bdc:	e8 f7 12 00 00       	call   3ed8 <exit>
  }
  if(unlink("dots/..") == 0){
    2be1:	c7 04 24 00 56 00 00 	movl   $0x5600,(%esp)
    2be8:	e8 3b 13 00 00       	call   3f28 <unlink>
    2bed:	85 c0                	test   %eax,%eax
    2bef:	75 19                	jne    2c0a <rmdot+0x139>
    printf(1, "unlink dots/.. worked!\n");
    2bf1:	c7 44 24 04 08 56 00 	movl   $0x5608,0x4(%esp)
    2bf8:	00 
    2bf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c00:	e8 63 14 00 00       	call   4068 <printf>
    exit();
    2c05:	e8 ce 12 00 00       	call   3ed8 <exit>
  }
  if(unlink("dots") != 0){
    2c0a:	c7 04 24 9a 55 00 00 	movl   $0x559a,(%esp)
    2c11:	e8 12 13 00 00       	call   3f28 <unlink>
    2c16:	85 c0                	test   %eax,%eax
    2c18:	74 19                	je     2c33 <rmdot+0x162>
    printf(1, "unlink dots failed!\n");
    2c1a:	c7 44 24 04 20 56 00 	movl   $0x5620,0x4(%esp)
    2c21:	00 
    2c22:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c29:	e8 3a 14 00 00       	call   4068 <printf>
    exit();
    2c2e:	e8 a5 12 00 00       	call   3ed8 <exit>
  }
  printf(1, "rmdot ok\n");
    2c33:	c7 44 24 04 35 56 00 	movl   $0x5635,0x4(%esp)
    2c3a:	00 
    2c3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c42:	e8 21 14 00 00       	call   4068 <printf>
}
    2c47:	c9                   	leave  
    2c48:	c3                   	ret    

00002c49 <dirfile>:

void
dirfile(void)
{
    2c49:	55                   	push   %ebp
    2c4a:	89 e5                	mov    %esp,%ebp
    2c4c:	83 ec 28             	sub    $0x28,%esp
  int fd;

  printf(1, "dir vs file\n");
    2c4f:	c7 44 24 04 3f 56 00 	movl   $0x563f,0x4(%esp)
    2c56:	00 
    2c57:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c5e:	e8 05 14 00 00       	call   4068 <printf>

  fd = open("dirfile", O_CREATE);
    2c63:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2c6a:	00 
    2c6b:	c7 04 24 4c 56 00 00 	movl   $0x564c,(%esp)
    2c72:	e8 a1 12 00 00       	call   3f18 <open>
    2c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0){
    2c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2c7e:	79 19                	jns    2c99 <dirfile+0x50>
    printf(1, "create dirfile failed\n");
    2c80:	c7 44 24 04 54 56 00 	movl   $0x5654,0x4(%esp)
    2c87:	00 
    2c88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c8f:	e8 d4 13 00 00       	call   4068 <printf>
    exit();
    2c94:	e8 3f 12 00 00       	call   3ed8 <exit>
  }
  close(fd);
    2c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2c9c:	89 04 24             	mov    %eax,(%esp)
    2c9f:	e8 5c 12 00 00       	call   3f00 <close>
  if(chdir("dirfile") == 0){
    2ca4:	c7 04 24 4c 56 00 00 	movl   $0x564c,(%esp)
    2cab:	e8 98 12 00 00       	call   3f48 <chdir>
    2cb0:	85 c0                	test   %eax,%eax
    2cb2:	75 19                	jne    2ccd <dirfile+0x84>
    printf(1, "chdir dirfile succeeded!\n");
    2cb4:	c7 44 24 04 6b 56 00 	movl   $0x566b,0x4(%esp)
    2cbb:	00 
    2cbc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cc3:	e8 a0 13 00 00       	call   4068 <printf>
    exit();
    2cc8:	e8 0b 12 00 00       	call   3ed8 <exit>
  }
  fd = open("dirfile/xx", 0);
    2ccd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2cd4:	00 
    2cd5:	c7 04 24 85 56 00 00 	movl   $0x5685,(%esp)
    2cdc:	e8 37 12 00 00       	call   3f18 <open>
    2ce1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2ce4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2ce8:	78 19                	js     2d03 <dirfile+0xba>
    printf(1, "create dirfile/xx succeeded!\n");
    2cea:	c7 44 24 04 90 56 00 	movl   $0x5690,0x4(%esp)
    2cf1:	00 
    2cf2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2cf9:	e8 6a 13 00 00       	call   4068 <printf>
    exit();
    2cfe:	e8 d5 11 00 00       	call   3ed8 <exit>
  }
  fd = open("dirfile/xx", O_CREATE);
    2d03:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2d0a:	00 
    2d0b:	c7 04 24 85 56 00 00 	movl   $0x5685,(%esp)
    2d12:	e8 01 12 00 00       	call   3f18 <open>
    2d17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2d1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2d1e:	78 19                	js     2d39 <dirfile+0xf0>
    printf(1, "create dirfile/xx succeeded!\n");
    2d20:	c7 44 24 04 90 56 00 	movl   $0x5690,0x4(%esp)
    2d27:	00 
    2d28:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d2f:	e8 34 13 00 00       	call   4068 <printf>
    exit();
    2d34:	e8 9f 11 00 00       	call   3ed8 <exit>
  }
  if(mkdir("dirfile/xx") == 0){
    2d39:	c7 04 24 85 56 00 00 	movl   $0x5685,(%esp)
    2d40:	e8 fb 11 00 00       	call   3f40 <mkdir>
    2d45:	85 c0                	test   %eax,%eax
    2d47:	75 19                	jne    2d62 <dirfile+0x119>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2d49:	c7 44 24 04 ae 56 00 	movl   $0x56ae,0x4(%esp)
    2d50:	00 
    2d51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d58:	e8 0b 13 00 00       	call   4068 <printf>
    exit();
    2d5d:	e8 76 11 00 00       	call   3ed8 <exit>
  }
  if(unlink("dirfile/xx") == 0){
    2d62:	c7 04 24 85 56 00 00 	movl   $0x5685,(%esp)
    2d69:	e8 ba 11 00 00       	call   3f28 <unlink>
    2d6e:	85 c0                	test   %eax,%eax
    2d70:	75 19                	jne    2d8b <dirfile+0x142>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2d72:	c7 44 24 04 cb 56 00 	movl   $0x56cb,0x4(%esp)
    2d79:	00 
    2d7a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d81:	e8 e2 12 00 00       	call   4068 <printf>
    exit();
    2d86:	e8 4d 11 00 00       	call   3ed8 <exit>
  }
  if(link("README", "dirfile/xx") == 0){
    2d8b:	c7 44 24 04 85 56 00 	movl   $0x5685,0x4(%esp)
    2d92:	00 
    2d93:	c7 04 24 e9 56 00 00 	movl   $0x56e9,(%esp)
    2d9a:	e8 99 11 00 00       	call   3f38 <link>
    2d9f:	85 c0                	test   %eax,%eax
    2da1:	75 19                	jne    2dbc <dirfile+0x173>
    printf(1, "link to dirfile/xx succeeded!\n");
    2da3:	c7 44 24 04 f0 56 00 	movl   $0x56f0,0x4(%esp)
    2daa:	00 
    2dab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2db2:	e8 b1 12 00 00       	call   4068 <printf>
    exit();
    2db7:	e8 1c 11 00 00       	call   3ed8 <exit>
  }
  if(unlink("dirfile") != 0){
    2dbc:	c7 04 24 4c 56 00 00 	movl   $0x564c,(%esp)
    2dc3:	e8 60 11 00 00       	call   3f28 <unlink>
    2dc8:	85 c0                	test   %eax,%eax
    2dca:	74 19                	je     2de5 <dirfile+0x19c>
    printf(1, "unlink dirfile failed!\n");
    2dcc:	c7 44 24 04 0f 57 00 	movl   $0x570f,0x4(%esp)
    2dd3:	00 
    2dd4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ddb:	e8 88 12 00 00       	call   4068 <printf>
    exit();
    2de0:	e8 f3 10 00 00       	call   3ed8 <exit>
  }

  fd = open(".", O_RDWR);
    2de5:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
    2dec:	00 
    2ded:	c7 04 24 cb 4c 00 00 	movl   $0x4ccb,(%esp)
    2df4:	e8 1f 11 00 00       	call   3f18 <open>
    2df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd >= 0){
    2dfc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    2e00:	78 19                	js     2e1b <dirfile+0x1d2>
    printf(1, "open . for writing succeeded!\n");
    2e02:	c7 44 24 04 28 57 00 	movl   $0x5728,0x4(%esp)
    2e09:	00 
    2e0a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e11:	e8 52 12 00 00       	call   4068 <printf>
    exit();
    2e16:	e8 bd 10 00 00       	call   3ed8 <exit>
  }
  fd = open(".", 0);
    2e1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    2e22:	00 
    2e23:	c7 04 24 cb 4c 00 00 	movl   $0x4ccb,(%esp)
    2e2a:	e8 e9 10 00 00       	call   3f18 <open>
    2e2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(write(fd, "x", 1) > 0){
    2e32:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    2e39:	00 
    2e3a:	c7 44 24 04 07 49 00 	movl   $0x4907,0x4(%esp)
    2e41:	00 
    2e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e45:	89 04 24             	mov    %eax,(%esp)
    2e48:	e8 ab 10 00 00       	call   3ef8 <write>
    2e4d:	85 c0                	test   %eax,%eax
    2e4f:	7e 19                	jle    2e6a <dirfile+0x221>
    printf(1, "write . succeeded!\n");
    2e51:	c7 44 24 04 47 57 00 	movl   $0x5747,0x4(%esp)
    2e58:	00 
    2e59:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e60:	e8 03 12 00 00       	call   4068 <printf>
    exit();
    2e65:	e8 6e 10 00 00       	call   3ed8 <exit>
  }
  close(fd);
    2e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    2e6d:	89 04 24             	mov    %eax,(%esp)
    2e70:	e8 8b 10 00 00       	call   3f00 <close>

  printf(1, "dir vs file OK\n");
    2e75:	c7 44 24 04 5b 57 00 	movl   $0x575b,0x4(%esp)
    2e7c:	00 
    2e7d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e84:	e8 df 11 00 00       	call   4068 <printf>
}
    2e89:	c9                   	leave  
    2e8a:	c3                   	ret    

00002e8b <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    2e8b:	55                   	push   %ebp
    2e8c:	89 e5                	mov    %esp,%ebp
    2e8e:	83 ec 28             	sub    $0x28,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2e91:	c7 44 24 04 6b 57 00 	movl   $0x576b,0x4(%esp)
    2e98:	00 
    2e99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ea0:	e8 c3 11 00 00       	call   4068 <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2ea5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2eac:	e9 d1 00 00 00       	jmp    2f82 <iref+0xf7>
    if(mkdir("irefd") != 0){
    2eb1:	c7 04 24 7c 57 00 00 	movl   $0x577c,(%esp)
    2eb8:	e8 83 10 00 00       	call   3f40 <mkdir>
    2ebd:	85 c0                	test   %eax,%eax
    2ebf:	74 19                	je     2eda <iref+0x4f>
      printf(1, "mkdir irefd failed\n");
    2ec1:	c7 44 24 04 82 57 00 	movl   $0x5782,0x4(%esp)
    2ec8:	00 
    2ec9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ed0:	e8 93 11 00 00       	call   4068 <printf>
      exit();
    2ed5:	e8 fe 0f 00 00       	call   3ed8 <exit>
    }
    if(chdir("irefd") != 0){
    2eda:	c7 04 24 7c 57 00 00 	movl   $0x577c,(%esp)
    2ee1:	e8 62 10 00 00       	call   3f48 <chdir>
    2ee6:	85 c0                	test   %eax,%eax
    2ee8:	74 19                	je     2f03 <iref+0x78>
      printf(1, "chdir irefd failed\n");
    2eea:	c7 44 24 04 96 57 00 	movl   $0x5796,0x4(%esp)
    2ef1:	00 
    2ef2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2ef9:	e8 6a 11 00 00       	call   4068 <printf>
      exit();
    2efe:	e8 d5 0f 00 00       	call   3ed8 <exit>
    }

    mkdir("");
    2f03:	c7 04 24 aa 57 00 00 	movl   $0x57aa,(%esp)
    2f0a:	e8 31 10 00 00       	call   3f40 <mkdir>
    link("README", "");
    2f0f:	c7 44 24 04 aa 57 00 	movl   $0x57aa,0x4(%esp)
    2f16:	00 
    2f17:	c7 04 24 e9 56 00 00 	movl   $0x56e9,(%esp)
    2f1e:	e8 15 10 00 00       	call   3f38 <link>
    fd = open("", O_CREATE);
    2f23:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2f2a:	00 
    2f2b:	c7 04 24 aa 57 00 00 	movl   $0x57aa,(%esp)
    2f32:	e8 e1 0f 00 00       	call   3f18 <open>
    2f37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f3e:	78 0b                	js     2f4b <iref+0xc0>
      close(fd);
    2f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2f43:	89 04 24             	mov    %eax,(%esp)
    2f46:	e8 b5 0f 00 00       	call   3f00 <close>
    fd = open("xx", O_CREATE);
    2f4b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    2f52:	00 
    2f53:	c7 04 24 ab 57 00 00 	movl   $0x57ab,(%esp)
    2f5a:	e8 b9 0f 00 00       	call   3f18 <open>
    2f5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(fd >= 0)
    2f62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2f66:	78 0b                	js     2f73 <iref+0xe8>
      close(fd);
    2f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
    2f6b:	89 04 24             	mov    %eax,(%esp)
    2f6e:	e8 8d 0f 00 00       	call   3f00 <close>
    unlink("xx");
    2f73:	c7 04 24 ab 57 00 00 	movl   $0x57ab,(%esp)
    2f7a:	e8 a9 0f 00 00       	call   3f28 <unlink>
  int i, fd;

  printf(1, "empty file name\n");

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2f7f:	ff 45 f4             	incl   -0xc(%ebp)
    2f82:	83 7d f4 32          	cmpl   $0x32,-0xc(%ebp)
    2f86:	0f 8e 25 ff ff ff    	jle    2eb1 <iref+0x26>
    if(fd >= 0)
      close(fd);
    unlink("xx");
  }

  chdir("/");
    2f8c:	c7 04 24 a2 44 00 00 	movl   $0x44a2,(%esp)
    2f93:	e8 b0 0f 00 00       	call   3f48 <chdir>
  printf(1, "empty file name OK\n");
    2f98:	c7 44 24 04 ae 57 00 	movl   $0x57ae,0x4(%esp)
    2f9f:	00 
    2fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fa7:	e8 bc 10 00 00       	call   4068 <printf>
}
    2fac:	c9                   	leave  
    2fad:	c3                   	ret    

00002fae <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2fae:	55                   	push   %ebp
    2faf:	89 e5                	mov    %esp,%ebp
    2fb1:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
    2fb4:	c7 44 24 04 c2 57 00 	movl   $0x57c2,0x4(%esp)
    2fbb:	00 
    2fbc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2fc3:	e8 a0 10 00 00       	call   4068 <printf>

  for(n=0; n<1000; n++){
    2fc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    2fcf:	eb 1c                	jmp    2fed <forktest+0x3f>
    pid = fork();
    2fd1:	e8 fa 0e 00 00       	call   3ed0 <fork>
    2fd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
    2fd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fdd:	78 19                	js     2ff8 <forktest+0x4a>
      break;
    if(pid == 0)
    2fdf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    2fe3:	75 05                	jne    2fea <forktest+0x3c>
      exit();
    2fe5:	e8 ee 0e 00 00       	call   3ed8 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<1000; n++){
    2fea:	ff 45 f4             	incl   -0xc(%ebp)
    2fed:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
    2ff4:	7e db                	jle    2fd1 <forktest+0x23>
    2ff6:	eb 01                	jmp    2ff9 <forktest+0x4b>
    pid = fork();
    if(pid < 0)
      break;
    2ff8:	90                   	nop
    if(pid == 0)
      exit();
  }
  
  if(n == 1000){
    2ff9:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
    3000:	75 3e                	jne    3040 <forktest+0x92>
    printf(1, "fork claimed to work 1000 times!\n");
    3002:	c7 44 24 04 d0 57 00 	movl   $0x57d0,0x4(%esp)
    3009:	00 
    300a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3011:	e8 52 10 00 00       	call   4068 <printf>
    exit();
    3016:	e8 bd 0e 00 00       	call   3ed8 <exit>
  }
  
  for(; n > 0; n--){
    if(wait() < 0){
    301b:	e8 c0 0e 00 00       	call   3ee0 <wait>
    3020:	85 c0                	test   %eax,%eax
    3022:	79 19                	jns    303d <forktest+0x8f>
      printf(1, "wait stopped early\n");
    3024:	c7 44 24 04 f2 57 00 	movl   $0x57f2,0x4(%esp)
    302b:	00 
    302c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3033:	e8 30 10 00 00       	call   4068 <printf>
      exit();
    3038:	e8 9b 0e 00 00       	call   3ed8 <exit>
  if(n == 1000){
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }
  
  for(; n > 0; n--){
    303d:	ff 4d f4             	decl   -0xc(%ebp)
    3040:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3044:	7f d5                	jg     301b <forktest+0x6d>
      printf(1, "wait stopped early\n");
      exit();
    }
  }
  
  if(wait() != -1){
    3046:	e8 95 0e 00 00       	call   3ee0 <wait>
    304b:	83 f8 ff             	cmp    $0xffffffff,%eax
    304e:	74 19                	je     3069 <forktest+0xbb>
    printf(1, "wait got too many\n");
    3050:	c7 44 24 04 06 58 00 	movl   $0x5806,0x4(%esp)
    3057:	00 
    3058:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    305f:	e8 04 10 00 00       	call   4068 <printf>
    exit();
    3064:	e8 6f 0e 00 00       	call   3ed8 <exit>
  }
  
  printf(1, "fork test OK\n");
    3069:	c7 44 24 04 19 58 00 	movl   $0x5819,0x4(%esp)
    3070:	00 
    3071:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3078:	e8 eb 0f 00 00       	call   4068 <printf>
}
    307d:	c9                   	leave  
    307e:	c3                   	ret    

0000307f <sbrktest>:

void
sbrktest(void)
{
    307f:	55                   	push   %ebp
    3080:	89 e5                	mov    %esp,%ebp
    3082:	53                   	push   %ebx
    3083:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    3089:	a1 2c 63 00 00       	mov    0x632c,%eax
    308e:	c7 44 24 04 27 58 00 	movl   $0x5827,0x4(%esp)
    3095:	00 
    3096:	89 04 24             	mov    %eax,(%esp)
    3099:	e8 ca 0f 00 00       	call   4068 <printf>
  oldbrk = sbrk(0);
    309e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30a5:	e8 b6 0e 00 00       	call   3f60 <sbrk>
    30aa:	89 45 ec             	mov    %eax,-0x14(%ebp)

  // can one sbrk() less than a page?
  a = sbrk(0);
    30ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30b4:	e8 a7 0e 00 00       	call   3f60 <sbrk>
    30b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int i;
  for(i = 0; i < 5000; i++){ 
    30bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    30c3:	eb 56                	jmp    311b <sbrktest+0x9c>
    b = sbrk(1);
    30c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    30cc:	e8 8f 0e 00 00       	call   3f60 <sbrk>
    30d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(b != a){
    30d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
    30d7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    30da:	74 2f                	je     310b <sbrktest+0x8c>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    30dc:	a1 2c 63 00 00       	mov    0x632c,%eax
    30e1:	8b 55 e8             	mov    -0x18(%ebp),%edx
    30e4:	89 54 24 10          	mov    %edx,0x10(%esp)
    30e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
    30eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
    30ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
    30f2:	89 54 24 08          	mov    %edx,0x8(%esp)
    30f6:	c7 44 24 04 32 58 00 	movl   $0x5832,0x4(%esp)
    30fd:	00 
    30fe:	89 04 24             	mov    %eax,(%esp)
    3101:	e8 62 0f 00 00       	call   4068 <printf>
      exit();
    3106:	e8 cd 0d 00 00       	call   3ed8 <exit>
    }
    *b = 1;
    310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    310e:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    3111:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3114:	40                   	inc    %eax
    3115:	89 45 f4             	mov    %eax,-0xc(%ebp)
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  int i;
  for(i = 0; i < 5000; i++){ 
    3118:	ff 45 f0             	incl   -0x10(%ebp)
    311b:	81 7d f0 87 13 00 00 	cmpl   $0x1387,-0x10(%ebp)
    3122:	7e a1                	jle    30c5 <sbrktest+0x46>
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  pid = fork();
    3124:	e8 a7 0d 00 00       	call   3ed0 <fork>
    3129:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    312c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3130:	79 1a                	jns    314c <sbrktest+0xcd>
    printf(stdout, "sbrk test fork failed\n");
    3132:	a1 2c 63 00 00       	mov    0x632c,%eax
    3137:	c7 44 24 04 4d 58 00 	movl   $0x584d,0x4(%esp)
    313e:	00 
    313f:	89 04 24             	mov    %eax,(%esp)
    3142:	e8 21 0f 00 00       	call   4068 <printf>
    exit();
    3147:	e8 8c 0d 00 00       	call   3ed8 <exit>
  }
  c = sbrk(1);
    314c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3153:	e8 08 0e 00 00       	call   3f60 <sbrk>
    3158:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c = sbrk(1);
    315b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3162:	e8 f9 0d 00 00       	call   3f60 <sbrk>
    3167:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a + 1){
    316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    316d:	40                   	inc    %eax
    316e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3171:	74 1a                	je     318d <sbrktest+0x10e>
    printf(stdout, "sbrk test failed post-fork\n");
    3173:	a1 2c 63 00 00       	mov    0x632c,%eax
    3178:	c7 44 24 04 64 58 00 	movl   $0x5864,0x4(%esp)
    317f:	00 
    3180:	89 04 24             	mov    %eax,(%esp)
    3183:	e8 e0 0e 00 00       	call   4068 <printf>
    exit();
    3188:	e8 4b 0d 00 00       	call   3ed8 <exit>
  }
  if(pid == 0)
    318d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3191:	75 05                	jne    3198 <sbrktest+0x119>
    exit();
    3193:	e8 40 0d 00 00       	call   3ed8 <exit>
  wait();
    3198:	e8 43 0d 00 00       	call   3ee0 <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    319d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    31a4:	e8 b7 0d 00 00       	call   3f60 <sbrk>
    31a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  amt = (BIG) - (uint)a;
    31ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    31af:	ba 00 00 40 06       	mov    $0x6400000,%edx
    31b4:	89 d1                	mov    %edx,%ecx
    31b6:	29 c1                	sub    %eax,%ecx
    31b8:	89 c8                	mov    %ecx,%eax
    31ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
  p = sbrk(amt);
    31bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
    31c0:	89 04 24             	mov    %eax,(%esp)
    31c3:	e8 98 0d 00 00       	call   3f60 <sbrk>
    31c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  if (p != a) { 
    31cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
    31ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    31d1:	74 1a                	je     31ed <sbrktest+0x16e>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    31d3:	a1 2c 63 00 00       	mov    0x632c,%eax
    31d8:	c7 44 24 04 80 58 00 	movl   $0x5880,0x4(%esp)
    31df:	00 
    31e0:	89 04 24             	mov    %eax,(%esp)
    31e3:	e8 80 0e 00 00       	call   4068 <printf>
    exit();
    31e8:	e8 eb 0c 00 00       	call   3ed8 <exit>
  }
  lastaddr = (char*) (BIG-1);
    31ed:	c7 45 d4 ff ff 3f 06 	movl   $0x63fffff,-0x2c(%ebp)
  *lastaddr = 99;
    31f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    31f7:	c6 00 63             	movb   $0x63,(%eax)

  // can one de-allocate?
  a = sbrk(0);
    31fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3201:	e8 5a 0d 00 00       	call   3f60 <sbrk>
    3206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-4096);
    3209:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    3210:	e8 4b 0d 00 00       	call   3f60 <sbrk>
    3215:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c == (char*)0xffffffff){
    3218:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    321c:	75 1a                	jne    3238 <sbrktest+0x1b9>
    printf(stdout, "sbrk could not deallocate\n");
    321e:	a1 2c 63 00 00       	mov    0x632c,%eax
    3223:	c7 44 24 04 be 58 00 	movl   $0x58be,0x4(%esp)
    322a:	00 
    322b:	89 04 24             	mov    %eax,(%esp)
    322e:	e8 35 0e 00 00       	call   4068 <printf>
    exit();
    3233:	e8 a0 0c 00 00       	call   3ed8 <exit>
  }
  c = sbrk(0);
    3238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    323f:	e8 1c 0d 00 00       	call   3f60 <sbrk>
    3244:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a - 4096){
    3247:	8b 45 f4             	mov    -0xc(%ebp),%eax
    324a:	2d 00 10 00 00       	sub    $0x1000,%eax
    324f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
    3252:	74 28                	je     327c <sbrktest+0x1fd>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3254:	a1 2c 63 00 00       	mov    0x632c,%eax
    3259:	8b 55 e0             	mov    -0x20(%ebp),%edx
    325c:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3260:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3263:	89 54 24 08          	mov    %edx,0x8(%esp)
    3267:	c7 44 24 04 dc 58 00 	movl   $0x58dc,0x4(%esp)
    326e:	00 
    326f:	89 04 24             	mov    %eax,(%esp)
    3272:	e8 f1 0d 00 00       	call   4068 <printf>
    exit();
    3277:	e8 5c 0c 00 00       	call   3ed8 <exit>
  }

  // can one re-allocate that page?
  a = sbrk(0);
    327c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3283:	e8 d8 0c 00 00       	call   3f60 <sbrk>
    3288:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(4096);
    328b:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    3292:	e8 c9 0c 00 00       	call   3f60 <sbrk>
    3297:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a || sbrk(0) != a + 4096){
    329a:	8b 45 e0             	mov    -0x20(%ebp),%eax
    329d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    32a0:	75 19                	jne    32bb <sbrktest+0x23c>
    32a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    32a9:	e8 b2 0c 00 00       	call   3f60 <sbrk>
    32ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32b1:	81 c2 00 10 00 00    	add    $0x1000,%edx
    32b7:	39 d0                	cmp    %edx,%eax
    32b9:	74 28                	je     32e3 <sbrktest+0x264>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    32bb:	a1 2c 63 00 00       	mov    0x632c,%eax
    32c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
    32c3:	89 54 24 0c          	mov    %edx,0xc(%esp)
    32c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
    32ca:	89 54 24 08          	mov    %edx,0x8(%esp)
    32ce:	c7 44 24 04 14 59 00 	movl   $0x5914,0x4(%esp)
    32d5:	00 
    32d6:	89 04 24             	mov    %eax,(%esp)
    32d9:	e8 8a 0d 00 00       	call   4068 <printf>
    exit();
    32de:	e8 f5 0b 00 00       	call   3ed8 <exit>
  }
  if(*lastaddr == 99){
    32e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    32e6:	8a 00                	mov    (%eax),%al
    32e8:	3c 63                	cmp    $0x63,%al
    32ea:	75 1a                	jne    3306 <sbrktest+0x287>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    32ec:	a1 2c 63 00 00       	mov    0x632c,%eax
    32f1:	c7 44 24 04 3c 59 00 	movl   $0x593c,0x4(%esp)
    32f8:	00 
    32f9:	89 04 24             	mov    %eax,(%esp)
    32fc:	e8 67 0d 00 00       	call   4068 <printf>
    exit();
    3301:	e8 d2 0b 00 00       	call   3ed8 <exit>
  }

  a = sbrk(0);
    3306:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    330d:	e8 4e 0c 00 00       	call   3f60 <sbrk>
    3312:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c = sbrk(-(sbrk(0) - oldbrk));
    3315:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3318:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    331f:	e8 3c 0c 00 00       	call   3f60 <sbrk>
    3324:	89 da                	mov    %ebx,%edx
    3326:	29 c2                	sub    %eax,%edx
    3328:	89 d0                	mov    %edx,%eax
    332a:	89 04 24             	mov    %eax,(%esp)
    332d:	e8 2e 0c 00 00       	call   3f60 <sbrk>
    3332:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(c != a){
    3335:	8b 45 e0             	mov    -0x20(%ebp),%eax
    3338:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    333b:	74 28                	je     3365 <sbrktest+0x2e6>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    333d:	a1 2c 63 00 00       	mov    0x632c,%eax
    3342:	8b 55 e0             	mov    -0x20(%ebp),%edx
    3345:	89 54 24 0c          	mov    %edx,0xc(%esp)
    3349:	8b 55 f4             	mov    -0xc(%ebp),%edx
    334c:	89 54 24 08          	mov    %edx,0x8(%esp)
    3350:	c7 44 24 04 6c 59 00 	movl   $0x596c,0x4(%esp)
    3357:	00 
    3358:	89 04 24             	mov    %eax,(%esp)
    335b:	e8 08 0d 00 00       	call   4068 <printf>
    exit();
    3360:	e8 73 0b 00 00       	call   3ed8 <exit>
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    3365:	c7 45 f4 00 00 00 80 	movl   $0x80000000,-0xc(%ebp)
    336c:	eb 7a                	jmp    33e8 <sbrktest+0x369>
    ppid = getpid();
    336e:	e8 e5 0b 00 00       	call   3f58 <getpid>
    3373:	89 45 d0             	mov    %eax,-0x30(%ebp)
    pid = fork();
    3376:	e8 55 0b 00 00       	call   3ed0 <fork>
    337b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(pid < 0){
    337e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    3382:	79 1a                	jns    339e <sbrktest+0x31f>
      printf(stdout, "fork failed\n");
    3384:	a1 2c 63 00 00       	mov    0x632c,%eax
    3389:	c7 44 24 04 d1 44 00 	movl   $0x44d1,0x4(%esp)
    3390:	00 
    3391:	89 04 24             	mov    %eax,(%esp)
    3394:	e8 cf 0c 00 00       	call   4068 <printf>
      exit();
    3399:	e8 3a 0b 00 00       	call   3ed8 <exit>
    }
    if(pid == 0){
    339e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
    33a2:	75 38                	jne    33dc <sbrktest+0x35d>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    33a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    33a7:	8a 00                	mov    (%eax),%al
    33a9:	0f be d0             	movsbl %al,%edx
    33ac:	a1 2c 63 00 00       	mov    0x632c,%eax
    33b1:	89 54 24 0c          	mov    %edx,0xc(%esp)
    33b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    33b8:	89 54 24 08          	mov    %edx,0x8(%esp)
    33bc:	c7 44 24 04 8d 59 00 	movl   $0x598d,0x4(%esp)
    33c3:	00 
    33c4:	89 04 24             	mov    %eax,(%esp)
    33c7:	e8 9c 0c 00 00       	call   4068 <printf>
      kill(ppid);
    33cc:	8b 45 d0             	mov    -0x30(%ebp),%eax
    33cf:	89 04 24             	mov    %eax,(%esp)
    33d2:	e8 31 0b 00 00       	call   3f08 <kill>
      exit();
    33d7:	e8 fc 0a 00 00       	call   3ed8 <exit>
    }
    wait();
    33dc:	e8 ff 0a 00 00       	call   3ee0 <wait>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }
  
  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    33e1:	81 45 f4 50 c3 00 00 	addl   $0xc350,-0xc(%ebp)
    33e8:	81 7d f4 7f 84 1e 80 	cmpl   $0x801e847f,-0xc(%ebp)
    33ef:	0f 86 79 ff ff ff    	jbe    336e <sbrktest+0x2ef>
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    33f5:	8d 45 c8             	lea    -0x38(%ebp),%eax
    33f8:	89 04 24             	mov    %eax,(%esp)
    33fb:	e8 e8 0a 00 00       	call   3ee8 <pipe>
    3400:	85 c0                	test   %eax,%eax
    3402:	74 19                	je     341d <sbrktest+0x39e>
    printf(1, "pipe() failed\n");
    3404:	c7 44 24 04 a2 48 00 	movl   $0x48a2,0x4(%esp)
    340b:	00 
    340c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3413:	e8 50 0c 00 00       	call   4068 <printf>
    exit();
    3418:	e8 bb 0a 00 00       	call   3ed8 <exit>
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    341d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    3424:	e9 88 00 00 00       	jmp    34b1 <sbrktest+0x432>
    if((pids[i] = fork()) == 0){
    3429:	e8 a2 0a 00 00       	call   3ed0 <fork>
    342e:	8b 55 f0             	mov    -0x10(%ebp),%edx
    3431:	89 44 95 a0          	mov    %eax,-0x60(%ebp,%edx,4)
    3435:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3438:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    343c:	85 c0                	test   %eax,%eax
    343e:	75 48                	jne    3488 <sbrktest+0x409>
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    3440:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3447:	e8 14 0b 00 00       	call   3f60 <sbrk>
    344c:	ba 00 00 40 06       	mov    $0x6400000,%edx
    3451:	89 d1                	mov    %edx,%ecx
    3453:	29 c1                	sub    %eax,%ecx
    3455:	89 c8                	mov    %ecx,%eax
    3457:	89 04 24             	mov    %eax,(%esp)
    345a:	e8 01 0b 00 00       	call   3f60 <sbrk>
      write(fds[1], "x", 1);
    345f:	8b 45 cc             	mov    -0x34(%ebp),%eax
    3462:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3469:	00 
    346a:	c7 44 24 04 07 49 00 	movl   $0x4907,0x4(%esp)
    3471:	00 
    3472:	89 04 24             	mov    %eax,(%esp)
    3475:	e8 7e 0a 00 00       	call   3ef8 <write>
      // sit around until killed
      for(;;) sleep(1000);
    347a:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
    3481:	e8 e2 0a 00 00       	call   3f68 <sleep>
    3486:	eb f2                	jmp    347a <sbrktest+0x3fb>
    }
    if(pids[i] != -1)
    3488:	8b 45 f0             	mov    -0x10(%ebp),%eax
    348b:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    348f:	83 f8 ff             	cmp    $0xffffffff,%eax
    3492:	74 1a                	je     34ae <sbrktest+0x42f>
      read(fds[0], &scratch, 1);
    3494:	8b 45 c8             	mov    -0x38(%ebp),%eax
    3497:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    349e:	00 
    349f:	8d 55 9f             	lea    -0x61(%ebp),%edx
    34a2:	89 54 24 04          	mov    %edx,0x4(%esp)
    34a6:	89 04 24             	mov    %eax,(%esp)
    34a9:	e8 42 0a 00 00       	call   3ef0 <read>
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34ae:	ff 45 f0             	incl   -0x10(%ebp)
    34b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34b4:	83 f8 09             	cmp    $0x9,%eax
    34b7:	0f 86 6c ff ff ff    	jbe    3429 <sbrktest+0x3aa>
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    34bd:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    34c4:	e8 97 0a 00 00       	call   3f60 <sbrk>
    34c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    34d3:	eb 26                	jmp    34fb <sbrktest+0x47c>
    if(pids[i] == -1)
    34d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34d8:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34dc:	83 f8 ff             	cmp    $0xffffffff,%eax
    34df:	74 16                	je     34f7 <sbrktest+0x478>
      continue;
    kill(pids[i]);
    34e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34e4:	8b 44 85 a0          	mov    -0x60(%ebp,%eax,4),%eax
    34e8:	89 04 24             	mov    %eax,(%esp)
    34eb:	e8 18 0a 00 00       	call   3f08 <kill>
    wait();
    34f0:	e8 eb 09 00 00       	call   3ee0 <wait>
    34f5:	eb 01                	jmp    34f8 <sbrktest+0x479>
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    34f7:	90                   	nop
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    34f8:	ff 45 f0             	incl   -0x10(%ebp)
    34fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    34fe:	83 f8 09             	cmp    $0x9,%eax
    3501:	76 d2                	jbe    34d5 <sbrktest+0x456>
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    3503:	83 7d e0 ff          	cmpl   $0xffffffff,-0x20(%ebp)
    3507:	75 1a                	jne    3523 <sbrktest+0x4a4>
    printf(stdout, "failed sbrk leaked memory\n");
    3509:	a1 2c 63 00 00       	mov    0x632c,%eax
    350e:	c7 44 24 04 a6 59 00 	movl   $0x59a6,0x4(%esp)
    3515:	00 
    3516:	89 04 24             	mov    %eax,(%esp)
    3519:	e8 4a 0b 00 00       	call   4068 <printf>
    exit();
    351e:	e8 b5 09 00 00       	call   3ed8 <exit>
  }

  if(sbrk(0) > oldbrk)
    3523:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    352a:	e8 31 0a 00 00       	call   3f60 <sbrk>
    352f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    3532:	76 1d                	jbe    3551 <sbrktest+0x4d2>
    sbrk(-(sbrk(0) - oldbrk));
    3534:	8b 5d ec             	mov    -0x14(%ebp),%ebx
    3537:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    353e:	e8 1d 0a 00 00       	call   3f60 <sbrk>
    3543:	89 da                	mov    %ebx,%edx
    3545:	29 c2                	sub    %eax,%edx
    3547:	89 d0                	mov    %edx,%eax
    3549:	89 04 24             	mov    %eax,(%esp)
    354c:	e8 0f 0a 00 00       	call   3f60 <sbrk>

  printf(stdout, "sbrk test OK\n");
    3551:	a1 2c 63 00 00       	mov    0x632c,%eax
    3556:	c7 44 24 04 c1 59 00 	movl   $0x59c1,0x4(%esp)
    355d:	00 
    355e:	89 04 24             	mov    %eax,(%esp)
    3561:	e8 02 0b 00 00       	call   4068 <printf>
}
    3566:	81 c4 84 00 00 00    	add    $0x84,%esp
    356c:	5b                   	pop    %ebx
    356d:	5d                   	pop    %ebp
    356e:	c3                   	ret    

0000356f <validateint>:

void
validateint(int *p)
{
    356f:	55                   	push   %ebp
    3570:	89 e5                	mov    %esp,%ebp
    3572:	56                   	push   %esi
    3573:	53                   	push   %ebx
    3574:	83 ec 14             	sub    $0x14,%esp
  int res;
  asm("mov %%esp, %%ebx\n\t"
    3577:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
    357e:	8b 55 08             	mov    0x8(%ebp),%edx
    3581:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3584:	89 d1                	mov    %edx,%ecx
    3586:	89 e3                	mov    %esp,%ebx
    3588:	89 cc                	mov    %ecx,%esp
    358a:	cd 40                	int    $0x40
    358c:	89 dc                	mov    %ebx,%esp
    358e:	89 c6                	mov    %eax,%esi
    3590:	89 75 f4             	mov    %esi,-0xc(%ebp)
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    3593:	83 c4 14             	add    $0x14,%esp
    3596:	5b                   	pop    %ebx
    3597:	5e                   	pop    %esi
    3598:	5d                   	pop    %ebp
    3599:	c3                   	ret    

0000359a <validatetest>:

void
validatetest(void)
{
    359a:	55                   	push   %ebp
    359b:	89 e5                	mov    %esp,%ebp
    359d:	83 ec 28             	sub    $0x28,%esp
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    35a0:	a1 2c 63 00 00       	mov    0x632c,%eax
    35a5:	c7 44 24 04 cf 59 00 	movl   $0x59cf,0x4(%esp)
    35ac:	00 
    35ad:	89 04 24             	mov    %eax,(%esp)
    35b0:	e8 b3 0a 00 00       	call   4068 <printf>
  hi = 1100*1024;
    35b5:	c7 45 f0 00 30 11 00 	movl   $0x113000,-0x10(%ebp)

  for(p = 0; p <= (uint)hi; p += 4096){
    35bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    35c3:	eb 7f                	jmp    3644 <validatetest+0xaa>
    if((pid = fork()) == 0){
    35c5:	e8 06 09 00 00       	call   3ed0 <fork>
    35ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
    35cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    35d1:	75 10                	jne    35e3 <validatetest+0x49>
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
    35d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    35d6:	89 04 24             	mov    %eax,(%esp)
    35d9:	e8 91 ff ff ff       	call   356f <validateint>
      exit();
    35de:	e8 f5 08 00 00       	call   3ed8 <exit>
    }
    sleep(0);
    35e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35ea:	e8 79 09 00 00       	call   3f68 <sleep>
    sleep(0);
    35ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    35f6:	e8 6d 09 00 00       	call   3f68 <sleep>
    kill(pid);
    35fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
    35fe:	89 04 24             	mov    %eax,(%esp)
    3601:	e8 02 09 00 00       	call   3f08 <kill>
    wait();
    3606:	e8 d5 08 00 00       	call   3ee0 <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    360b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    360e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3612:	c7 04 24 de 59 00 00 	movl   $0x59de,(%esp)
    3619:	e8 1a 09 00 00       	call   3f38 <link>
    361e:	83 f8 ff             	cmp    $0xffffffff,%eax
    3621:	74 1a                	je     363d <validatetest+0xa3>
      printf(stdout, "link should not succeed\n");
    3623:	a1 2c 63 00 00       	mov    0x632c,%eax
    3628:	c7 44 24 04 e9 59 00 	movl   $0x59e9,0x4(%esp)
    362f:	00 
    3630:	89 04 24             	mov    %eax,(%esp)
    3633:	e8 30 0a 00 00       	call   4068 <printf>
      exit();
    3638:	e8 9b 08 00 00       	call   3ed8 <exit>
  uint p;

  printf(stdout, "validate test\n");
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    363d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    3644:	8b 45 f0             	mov    -0x10(%ebp),%eax
    3647:	3b 45 f4             	cmp    -0xc(%ebp),%eax
    364a:	0f 83 75 ff ff ff    	jae    35c5 <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
      exit();
    }
  }

  printf(stdout, "validate ok\n");
    3650:	a1 2c 63 00 00       	mov    0x632c,%eax
    3655:	c7 44 24 04 02 5a 00 	movl   $0x5a02,0x4(%esp)
    365c:	00 
    365d:	89 04 24             	mov    %eax,(%esp)
    3660:	e8 03 0a 00 00       	call   4068 <printf>
}
    3665:	c9                   	leave  
    3666:	c3                   	ret    

00003667 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    3667:	55                   	push   %ebp
    3668:	89 e5                	mov    %esp,%ebp
    366a:	83 ec 28             	sub    $0x28,%esp
  int i;

  printf(stdout, "bss test\n");
    366d:	a1 2c 63 00 00       	mov    0x632c,%eax
    3672:	c7 44 24 04 0f 5a 00 	movl   $0x5a0f,0x4(%esp)
    3679:	00 
    367a:	89 04 24             	mov    %eax,(%esp)
    367d:	e8 e6 09 00 00       	call   4068 <printf>
  for(i = 0; i < sizeof(uninit); i++){
    3682:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3689:	eb 2b                	jmp    36b6 <bsstest+0x4f>
    if(uninit[i] != '\0'){
    368b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    368e:	05 00 64 00 00       	add    $0x6400,%eax
    3693:	8a 00                	mov    (%eax),%al
    3695:	84 c0                	test   %al,%al
    3697:	74 1a                	je     36b3 <bsstest+0x4c>
      printf(stdout, "bss test failed\n");
    3699:	a1 2c 63 00 00       	mov    0x632c,%eax
    369e:	c7 44 24 04 19 5a 00 	movl   $0x5a19,0x4(%esp)
    36a5:	00 
    36a6:	89 04 24             	mov    %eax,(%esp)
    36a9:	e8 ba 09 00 00       	call   4068 <printf>
      exit();
    36ae:	e8 25 08 00 00       	call   3ed8 <exit>
bsstest(void)
{
  int i;

  printf(stdout, "bss test\n");
  for(i = 0; i < sizeof(uninit); i++){
    36b3:	ff 45 f4             	incl   -0xc(%ebp)
    36b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    36b9:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    36be:	76 cb                	jbe    368b <bsstest+0x24>
    if(uninit[i] != '\0'){
      printf(stdout, "bss test failed\n");
      exit();
    }
  }
  printf(stdout, "bss test ok\n");
    36c0:	a1 2c 63 00 00       	mov    0x632c,%eax
    36c5:	c7 44 24 04 2a 5a 00 	movl   $0x5a2a,0x4(%esp)
    36cc:	00 
    36cd:	89 04 24             	mov    %eax,(%esp)
    36d0:	e8 93 09 00 00       	call   4068 <printf>
}
    36d5:	c9                   	leave  
    36d6:	c3                   	ret    

000036d7 <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    36d7:	55                   	push   %ebp
    36d8:	89 e5                	mov    %esp,%ebp
    36da:	83 ec 28             	sub    $0x28,%esp
  int pid, fd;

  unlink("bigarg-ok");
    36dd:	c7 04 24 37 5a 00 00 	movl   $0x5a37,(%esp)
    36e4:	e8 3f 08 00 00       	call   3f28 <unlink>
  pid = fork();
    36e9:	e8 e2 07 00 00       	call   3ed0 <fork>
    36ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(pid == 0){
    36f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    36f5:	0f 85 8f 00 00 00    	jne    378a <bigargtest+0xb3>
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    36fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3702:	eb 11                	jmp    3715 <bigargtest+0x3e>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3704:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3707:	c7 04 85 60 63 00 00 	movl   $0x5a44,0x6360(,%eax,4)
    370e:	44 5a 00 00 
  unlink("bigarg-ok");
  pid = fork();
  if(pid == 0){
    static char *args[MAXARG];
    int i;
    for(i = 0; i < MAXARG-1; i++)
    3712:	ff 45 f4             	incl   -0xc(%ebp)
    3715:	83 7d f4 1e          	cmpl   $0x1e,-0xc(%ebp)
    3719:	7e e9                	jle    3704 <bigargtest+0x2d>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    args[MAXARG-1] = 0;
    371b:	c7 05 dc 63 00 00 00 	movl   $0x0,0x63dc
    3722:	00 00 00 
    printf(stdout, "bigarg test\n");
    3725:	a1 2c 63 00 00       	mov    0x632c,%eax
    372a:	c7 44 24 04 21 5b 00 	movl   $0x5b21,0x4(%esp)
    3731:	00 
    3732:	89 04 24             	mov    %eax,(%esp)
    3735:	e8 2e 09 00 00       	call   4068 <printf>
    exec("echo", args);
    373a:	c7 44 24 04 60 63 00 	movl   $0x6360,0x4(%esp)
    3741:	00 
    3742:	c7 04 24 30 44 00 00 	movl   $0x4430,(%esp)
    3749:	e8 c2 07 00 00       	call   3f10 <exec>
    printf(stdout, "bigarg test ok\n");
    374e:	a1 2c 63 00 00       	mov    0x632c,%eax
    3753:	c7 44 24 04 2e 5b 00 	movl   $0x5b2e,0x4(%esp)
    375a:	00 
    375b:	89 04 24             	mov    %eax,(%esp)
    375e:	e8 05 09 00 00       	call   4068 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3763:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    376a:	00 
    376b:	c7 04 24 37 5a 00 00 	movl   $0x5a37,(%esp)
    3772:	e8 a1 07 00 00       	call   3f18 <open>
    3777:	89 45 ec             	mov    %eax,-0x14(%ebp)
    close(fd);
    377a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    377d:	89 04 24             	mov    %eax,(%esp)
    3780:	e8 7b 07 00 00       	call   3f00 <close>
    exit();
    3785:	e8 4e 07 00 00       	call   3ed8 <exit>
  } else if(pid < 0){
    378a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    378e:	79 1a                	jns    37aa <bigargtest+0xd3>
    printf(stdout, "bigargtest: fork failed\n");
    3790:	a1 2c 63 00 00       	mov    0x632c,%eax
    3795:	c7 44 24 04 3e 5b 00 	movl   $0x5b3e,0x4(%esp)
    379c:	00 
    379d:	89 04 24             	mov    %eax,(%esp)
    37a0:	e8 c3 08 00 00       	call   4068 <printf>
    exit();
    37a5:	e8 2e 07 00 00       	call   3ed8 <exit>
  }
  wait();
    37aa:	e8 31 07 00 00       	call   3ee0 <wait>
  fd = open("bigarg-ok", 0);
    37af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    37b6:	00 
    37b7:	c7 04 24 37 5a 00 00 	movl   $0x5a37,(%esp)
    37be:	e8 55 07 00 00       	call   3f18 <open>
    37c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
    37c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    37ca:	79 1a                	jns    37e6 <bigargtest+0x10f>
    printf(stdout, "bigarg test failed!\n");
    37cc:	a1 2c 63 00 00       	mov    0x632c,%eax
    37d1:	c7 44 24 04 57 5b 00 	movl   $0x5b57,0x4(%esp)
    37d8:	00 
    37d9:	89 04 24             	mov    %eax,(%esp)
    37dc:	e8 87 08 00 00       	call   4068 <printf>
    exit();
    37e1:	e8 f2 06 00 00       	call   3ed8 <exit>
  }
  close(fd);
    37e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    37e9:	89 04 24             	mov    %eax,(%esp)
    37ec:	e8 0f 07 00 00       	call   3f00 <close>
  unlink("bigarg-ok");
    37f1:	c7 04 24 37 5a 00 00 	movl   $0x5a37,(%esp)
    37f8:	e8 2b 07 00 00       	call   3f28 <unlink>
}
    37fd:	c9                   	leave  
    37fe:	c3                   	ret    

000037ff <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    37ff:	55                   	push   %ebp
    3800:	89 e5                	mov    %esp,%ebp
    3802:	53                   	push   %ebx
    3803:	83 ec 74             	sub    $0x74,%esp
  int nfiles;
  int fsblocks = 0;
    3806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  printf(1, "fsfull test\n");
    380d:	c7 44 24 04 6c 5b 00 	movl   $0x5b6c,0x4(%esp)
    3814:	00 
    3815:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    381c:	e8 47 08 00 00       	call   4068 <printf>

  for(nfiles = 0; ; nfiles++){
    3821:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char name[64];
    name[0] = 'f';
    3828:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    382c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    382f:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3834:	f7 e9                	imul   %ecx
    3836:	c1 fa 06             	sar    $0x6,%edx
    3839:	89 c8                	mov    %ecx,%eax
    383b:	c1 f8 1f             	sar    $0x1f,%eax
    383e:	89 d1                	mov    %edx,%ecx
    3840:	29 c1                	sub    %eax,%ecx
    3842:	89 c8                	mov    %ecx,%eax
    3844:	83 c0 30             	add    $0x30,%eax
    3847:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    384a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    384d:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3852:	f7 eb                	imul   %ebx
    3854:	c1 fa 06             	sar    $0x6,%edx
    3857:	89 d8                	mov    %ebx,%eax
    3859:	c1 f8 1f             	sar    $0x1f,%eax
    385c:	89 d1                	mov    %edx,%ecx
    385e:	29 c1                	sub    %eax,%ecx
    3860:	89 c8                	mov    %ecx,%eax
    3862:	c1 e0 02             	shl    $0x2,%eax
    3865:	01 c8                	add    %ecx,%eax
    3867:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    386e:	01 d0                	add    %edx,%eax
    3870:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3877:	01 d0                	add    %edx,%eax
    3879:	c1 e0 03             	shl    $0x3,%eax
    387c:	89 d9                	mov    %ebx,%ecx
    387e:	29 c1                	sub    %eax,%ecx
    3880:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3885:	f7 e9                	imul   %ecx
    3887:	c1 fa 05             	sar    $0x5,%edx
    388a:	89 c8                	mov    %ecx,%eax
    388c:	c1 f8 1f             	sar    $0x1f,%eax
    388f:	89 d1                	mov    %edx,%ecx
    3891:	29 c1                	sub    %eax,%ecx
    3893:	89 c8                	mov    %ecx,%eax
    3895:	83 c0 30             	add    $0x30,%eax
    3898:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    389b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    389e:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    38a3:	f7 eb                	imul   %ebx
    38a5:	c1 fa 05             	sar    $0x5,%edx
    38a8:	89 d8                	mov    %ebx,%eax
    38aa:	c1 f8 1f             	sar    $0x1f,%eax
    38ad:	89 d1                	mov    %edx,%ecx
    38af:	29 c1                	sub    %eax,%ecx
    38b1:	89 c8                	mov    %ecx,%eax
    38b3:	c1 e0 02             	shl    $0x2,%eax
    38b6:	01 c8                	add    %ecx,%eax
    38b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    38bf:	01 d0                	add    %edx,%eax
    38c1:	c1 e0 02             	shl    $0x2,%eax
    38c4:	89 d9                	mov    %ebx,%ecx
    38c6:	29 c1                	sub    %eax,%ecx
    38c8:	ba 67 66 66 66       	mov    $0x66666667,%edx
    38cd:	89 c8                	mov    %ecx,%eax
    38cf:	f7 ea                	imul   %edx
    38d1:	c1 fa 02             	sar    $0x2,%edx
    38d4:	89 c8                	mov    %ecx,%eax
    38d6:	c1 f8 1f             	sar    $0x1f,%eax
    38d9:	89 d1                	mov    %edx,%ecx
    38db:	29 c1                	sub    %eax,%ecx
    38dd:	89 c8                	mov    %ecx,%eax
    38df:	83 c0 30             	add    $0x30,%eax
    38e2:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    38e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    38e8:	ba 67 66 66 66       	mov    $0x66666667,%edx
    38ed:	89 c8                	mov    %ecx,%eax
    38ef:	f7 ea                	imul   %edx
    38f1:	c1 fa 02             	sar    $0x2,%edx
    38f4:	89 c8                	mov    %ecx,%eax
    38f6:	c1 f8 1f             	sar    $0x1f,%eax
    38f9:	29 c2                	sub    %eax,%edx
    38fb:	89 d0                	mov    %edx,%eax
    38fd:	c1 e0 02             	shl    $0x2,%eax
    3900:	01 d0                	add    %edx,%eax
    3902:	d1 e0                	shl    %eax
    3904:	89 ca                	mov    %ecx,%edx
    3906:	29 c2                	sub    %eax,%edx
    3908:	88 d0                	mov    %dl,%al
    390a:	83 c0 30             	add    $0x30,%eax
    390d:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3910:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    printf(1, "writing %s\n", name);
    3914:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3917:	89 44 24 08          	mov    %eax,0x8(%esp)
    391b:	c7 44 24 04 79 5b 00 	movl   $0x5b79,0x4(%esp)
    3922:	00 
    3923:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    392a:	e8 39 07 00 00       	call   4068 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    392f:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
    3936:	00 
    3937:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    393a:	89 04 24             	mov    %eax,(%esp)
    393d:	e8 d6 05 00 00       	call   3f18 <open>
    3942:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(fd < 0){
    3945:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    3949:	79 20                	jns    396b <fsfull+0x16c>
      printf(1, "open %s failed\n", name);
    394b:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    394e:	89 44 24 08          	mov    %eax,0x8(%esp)
    3952:	c7 44 24 04 85 5b 00 	movl   $0x5b85,0x4(%esp)
    3959:	00 
    395a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3961:	e8 02 07 00 00       	call   4068 <printf>
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3966:	e9 6c 01 00 00       	jmp    3ad7 <fsfull+0x2d8>
    int fd = open(name, O_CREATE|O_RDWR);
    if(fd < 0){
      printf(1, "open %s failed\n", name);
      break;
    }
    int total = 0;
    396b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    while(1){
      int cc = write(fd, buf, 512);
    3972:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
    3979:	00 
    397a:	c7 44 24 04 20 8b 00 	movl   $0x8b20,0x4(%esp)
    3981:	00 
    3982:	8b 45 e8             	mov    -0x18(%ebp),%eax
    3985:	89 04 24             	mov    %eax,(%esp)
    3988:	e8 6b 05 00 00       	call   3ef8 <write>
    398d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(cc < 512)
    3990:	81 7d e4 ff 01 00 00 	cmpl   $0x1ff,-0x1c(%ebp)
    3997:	7e 0b                	jle    39a4 <fsfull+0x1a5>
        break;
      total += cc;
    3999:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    399c:	01 45 ec             	add    %eax,-0x14(%ebp)
      fsblocks++;
    399f:	ff 45 f0             	incl   -0x10(%ebp)
    }
    39a2:	eb ce                	jmp    3972 <fsfull+0x173>
    }
    int total = 0;
    while(1){
      int cc = write(fd, buf, 512);
      if(cc < 512)
        break;
    39a4:	90                   	nop
      total += cc;
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    39a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    39a8:	89 44 24 08          	mov    %eax,0x8(%esp)
    39ac:	c7 44 24 04 95 5b 00 	movl   $0x5b95,0x4(%esp)
    39b3:	00 
    39b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    39bb:	e8 a8 06 00 00       	call   4068 <printf>
    close(fd);
    39c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
    39c3:	89 04 24             	mov    %eax,(%esp)
    39c6:	e8 35 05 00 00       	call   3f00 <close>
    if(total == 0)
    39cb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    39cf:	0f 84 02 01 00 00    	je     3ad7 <fsfull+0x2d8>
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");

  for(nfiles = 0; ; nfiles++){
    39d5:	ff 45 f4             	incl   -0xc(%ebp)
    }
    printf(1, "wrote %d bytes\n", total);
    close(fd);
    if(total == 0)
      break;
  }
    39d8:	e9 4b fe ff ff       	jmp    3828 <fsfull+0x29>

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    39dd:	c6 45 a4 66          	movb   $0x66,-0x5c(%ebp)
    name[1] = '0' + nfiles / 1000;
    39e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    39e4:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    39e9:	f7 e9                	imul   %ecx
    39eb:	c1 fa 06             	sar    $0x6,%edx
    39ee:	89 c8                	mov    %ecx,%eax
    39f0:	c1 f8 1f             	sar    $0x1f,%eax
    39f3:	89 d1                	mov    %edx,%ecx
    39f5:	29 c1                	sub    %eax,%ecx
    39f7:	89 c8                	mov    %ecx,%eax
    39f9:	83 c0 30             	add    $0x30,%eax
    39fc:	88 45 a5             	mov    %al,-0x5b(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    39ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a02:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    3a07:	f7 eb                	imul   %ebx
    3a09:	c1 fa 06             	sar    $0x6,%edx
    3a0c:	89 d8                	mov    %ebx,%eax
    3a0e:	c1 f8 1f             	sar    $0x1f,%eax
    3a11:	89 d1                	mov    %edx,%ecx
    3a13:	29 c1                	sub    %eax,%ecx
    3a15:	89 c8                	mov    %ecx,%eax
    3a17:	c1 e0 02             	shl    $0x2,%eax
    3a1a:	01 c8                	add    %ecx,%eax
    3a1c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a23:	01 d0                	add    %edx,%eax
    3a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a2c:	01 d0                	add    %edx,%eax
    3a2e:	c1 e0 03             	shl    $0x3,%eax
    3a31:	89 d9                	mov    %ebx,%ecx
    3a33:	29 c1                	sub    %eax,%ecx
    3a35:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3a3a:	f7 e9                	imul   %ecx
    3a3c:	c1 fa 05             	sar    $0x5,%edx
    3a3f:	89 c8                	mov    %ecx,%eax
    3a41:	c1 f8 1f             	sar    $0x1f,%eax
    3a44:	89 d1                	mov    %edx,%ecx
    3a46:	29 c1                	sub    %eax,%ecx
    3a48:	89 c8                	mov    %ecx,%eax
    3a4a:	83 c0 30             	add    $0x30,%eax
    3a4d:	88 45 a6             	mov    %al,-0x5a(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3a50:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    3a53:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3a58:	f7 eb                	imul   %ebx
    3a5a:	c1 fa 05             	sar    $0x5,%edx
    3a5d:	89 d8                	mov    %ebx,%eax
    3a5f:	c1 f8 1f             	sar    $0x1f,%eax
    3a62:	89 d1                	mov    %edx,%ecx
    3a64:	29 c1                	sub    %eax,%ecx
    3a66:	89 c8                	mov    %ecx,%eax
    3a68:	c1 e0 02             	shl    $0x2,%eax
    3a6b:	01 c8                	add    %ecx,%eax
    3a6d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3a74:	01 d0                	add    %edx,%eax
    3a76:	c1 e0 02             	shl    $0x2,%eax
    3a79:	89 d9                	mov    %ebx,%ecx
    3a7b:	29 c1                	sub    %eax,%ecx
    3a7d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3a82:	89 c8                	mov    %ecx,%eax
    3a84:	f7 ea                	imul   %edx
    3a86:	c1 fa 02             	sar    $0x2,%edx
    3a89:	89 c8                	mov    %ecx,%eax
    3a8b:	c1 f8 1f             	sar    $0x1f,%eax
    3a8e:	89 d1                	mov    %edx,%ecx
    3a90:	29 c1                	sub    %eax,%ecx
    3a92:	89 c8                	mov    %ecx,%eax
    3a94:	83 c0 30             	add    $0x30,%eax
    3a97:	88 45 a7             	mov    %al,-0x59(%ebp)
    name[4] = '0' + (nfiles % 10);
    3a9a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    3a9d:	ba 67 66 66 66       	mov    $0x66666667,%edx
    3aa2:	89 c8                	mov    %ecx,%eax
    3aa4:	f7 ea                	imul   %edx
    3aa6:	c1 fa 02             	sar    $0x2,%edx
    3aa9:	89 c8                	mov    %ecx,%eax
    3aab:	c1 f8 1f             	sar    $0x1f,%eax
    3aae:	29 c2                	sub    %eax,%edx
    3ab0:	89 d0                	mov    %edx,%eax
    3ab2:	c1 e0 02             	shl    $0x2,%eax
    3ab5:	01 d0                	add    %edx,%eax
    3ab7:	d1 e0                	shl    %eax
    3ab9:	89 ca                	mov    %ecx,%edx
    3abb:	29 c2                	sub    %eax,%edx
    3abd:	88 d0                	mov    %dl,%al
    3abf:	83 c0 30             	add    $0x30,%eax
    3ac2:	88 45 a8             	mov    %al,-0x58(%ebp)
    name[5] = '\0';
    3ac5:	c6 45 a9 00          	movb   $0x0,-0x57(%ebp)
    unlink(name);
    3ac9:	8d 45 a4             	lea    -0x5c(%ebp),%eax
    3acc:	89 04 24             	mov    %eax,(%esp)
    3acf:	e8 54 04 00 00       	call   3f28 <unlink>
    nfiles--;
    3ad4:	ff 4d f4             	decl   -0xc(%ebp)
    close(fd);
    if(total == 0)
      break;
  }

  while(nfiles >= 0){
    3ad7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3adb:	0f 89 fc fe ff ff    	jns    39dd <fsfull+0x1de>
    name[5] = '\0';
    unlink(name);
    nfiles--;
  }

  printf(1, "fsfull test finished\n");
    3ae1:	c7 44 24 04 a5 5b 00 	movl   $0x5ba5,0x4(%esp)
    3ae8:	00 
    3ae9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3af0:	e8 73 05 00 00       	call   4068 <printf>
}
    3af5:	83 c4 74             	add    $0x74,%esp
    3af8:	5b                   	pop    %ebx
    3af9:	5d                   	pop    %ebp
    3afa:	c3                   	ret    

00003afb <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    3afb:	55                   	push   %ebp
    3afc:	89 e5                	mov    %esp,%ebp
  randstate = randstate * 1664525 + 1013904223;
    3afe:	8b 15 30 63 00 00    	mov    0x6330,%edx
    3b04:	89 d0                	mov    %edx,%eax
    3b06:	d1 e0                	shl    %eax
    3b08:	01 d0                	add    %edx,%eax
    3b0a:	c1 e0 02             	shl    $0x2,%eax
    3b0d:	01 d0                	add    %edx,%eax
    3b0f:	c1 e0 08             	shl    $0x8,%eax
    3b12:	01 d0                	add    %edx,%eax
    3b14:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
    3b1b:	01 c8                	add    %ecx,%eax
    3b1d:	c1 e0 02             	shl    $0x2,%eax
    3b20:	01 d0                	add    %edx,%eax
    3b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b29:	01 d0                	add    %edx,%eax
    3b2b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    3b32:	01 d0                	add    %edx,%eax
    3b34:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3b39:	a3 30 63 00 00       	mov    %eax,0x6330
  return randstate;
    3b3e:	a1 30 63 00 00       	mov    0x6330,%eax
}
    3b43:	5d                   	pop    %ebp
    3b44:	c3                   	ret    

00003b45 <main>:

int
main(int argc, char *argv[])
{
    3b45:	55                   	push   %ebp
    3b46:	89 e5                	mov    %esp,%ebp
    3b48:	83 e4 f0             	and    $0xfffffff0,%esp
    3b4b:	83 ec 10             	sub    $0x10,%esp
  printf(1, "usertests starting\n");
    3b4e:	c7 44 24 04 bb 5b 00 	movl   $0x5bbb,0x4(%esp)
    3b55:	00 
    3b56:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b5d:	e8 06 05 00 00       	call   4068 <printf>

  if(open("usertests.ran", 0) >= 0){
    3b62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3b69:	00 
    3b6a:	c7 04 24 cf 5b 00 00 	movl   $0x5bcf,(%esp)
    3b71:	e8 a2 03 00 00       	call   3f18 <open>
    3b76:	85 c0                	test   %eax,%eax
    3b78:	78 19                	js     3b93 <main+0x4e>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3b7a:	c7 44 24 04 e0 5b 00 	movl   $0x5be0,0x4(%esp)
    3b81:	00 
    3b82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    3b89:	e8 da 04 00 00       	call   4068 <printf>
    exit();
    3b8e:	e8 45 03 00 00       	call   3ed8 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3b93:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
    3b9a:	00 
    3b9b:	c7 04 24 cf 5b 00 00 	movl   $0x5bcf,(%esp)
    3ba2:	e8 71 03 00 00       	call   3f18 <open>
    3ba7:	89 04 24             	mov    %eax,(%esp)
    3baa:	e8 51 03 00 00       	call   3f00 <close>

  createdelete();
    3baf:	e8 b7 d6 ff ff       	call   126b <createdelete>
  linkunlink();
    3bb4:	e8 a4 e0 ff ff       	call   1c5d <linkunlink>
  concreate();
    3bb9:	e8 38 dd ff ff       	call   18f6 <concreate>
  fourfiles();
    3bbe:	e8 44 d4 ff ff       	call   1007 <fourfiles>
  sharedfd();
    3bc3:	e8 47 d2 ff ff       	call   e0f <sharedfd>

  bigargtest();
    3bc8:	e8 0a fb ff ff       	call   36d7 <bigargtest>
  bigwrite();
    3bcd:	e8 83 ea ff ff       	call   2655 <bigwrite>
  bigargtest();
    3bd2:	e8 00 fb ff ff       	call   36d7 <bigargtest>
  bsstest();
    3bd7:	e8 8b fa ff ff       	call   3667 <bsstest>
  sbrktest();
    3bdc:	e8 9e f4 ff ff       	call   307f <sbrktest>
  validatetest();
    3be1:	e8 b4 f9 ff ff       	call   359a <validatetest>

  opentest();
    3be6:	e8 dc c6 ff ff       	call   2c7 <opentest>
  writetest();
    3beb:	e8 82 c7 ff ff       	call   372 <writetest>
  writetest1();
    3bf0:	e8 91 c9 ff ff       	call   586 <writetest1>
  createtest();
    3bf5:	e8 93 cb ff ff       	call   78d <createtest>

  openiputtest();
    3bfa:	e8 c7 c5 ff ff       	call   1c6 <openiputtest>
  exitiputtest();
    3bff:	e8 d6 c4 ff ff       	call   da <exitiputtest>
  iputtest();
    3c04:	e8 f7 c3 ff ff       	call   0 <iputtest>

  mem();
    3c09:	e8 1c d1 ff ff       	call   d2a <mem>
  pipe1();
    3c0e:	e8 59 cd ff ff       	call   96c <pipe1>
  preempt();
    3c13:	e8 3c cf ff ff       	call   b54 <preempt>
  exitwait();
    3c18:	e8 90 d0 ff ff       	call   cad <exitwait>

  rmdot();
    3c1d:	e8 af ee ff ff       	call   2ad1 <rmdot>
  fourteen();
    3c22:	e8 54 ed ff ff       	call   297b <fourteen>
  bigfile();
    3c27:	e8 30 eb ff ff       	call   275c <bigfile>
  subdir();
    3c2c:	e8 e0 e2 ff ff       	call   1f11 <subdir>
  linktest();
    3c31:	e8 77 da ff ff       	call   16ad <linktest>
  unlinkread();
    3c36:	e8 9f d8 ff ff       	call   14da <unlinkread>
  dirfile();
    3c3b:	e8 09 f0 ff ff       	call   2c49 <dirfile>
  iref();
    3c40:	e8 46 f2 ff ff       	call   2e8b <iref>
  forktest();
    3c45:	e8 64 f3 ff ff       	call   2fae <forktest>
  bigdir(); // slow
    3c4a:	e8 53 e1 ff ff       	call   1da2 <bigdir>
  exectest();
    3c4f:	e8 c9 cc ff ff       	call   91d <exectest>

  exit();
    3c54:	e8 7f 02 00 00       	call   3ed8 <exit>
    3c59:	66 90                	xchg   %ax,%ax
    3c5b:	90                   	nop

00003c5c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    3c5c:	55                   	push   %ebp
    3c5d:	89 e5                	mov    %esp,%ebp
    3c5f:	57                   	push   %edi
    3c60:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    3c61:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3c64:	8b 55 10             	mov    0x10(%ebp),%edx
    3c67:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c6a:	89 cb                	mov    %ecx,%ebx
    3c6c:	89 df                	mov    %ebx,%edi
    3c6e:	89 d1                	mov    %edx,%ecx
    3c70:	fc                   	cld    
    3c71:	f3 aa                	rep stos %al,%es:(%edi)
    3c73:	89 ca                	mov    %ecx,%edx
    3c75:	89 fb                	mov    %edi,%ebx
    3c77:	89 5d 08             	mov    %ebx,0x8(%ebp)
    3c7a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    3c7d:	5b                   	pop    %ebx
    3c7e:	5f                   	pop    %edi
    3c7f:	5d                   	pop    %ebp
    3c80:	c3                   	ret    

00003c81 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
    3c81:	55                   	push   %ebp
    3c82:	89 e5                	mov    %esp,%ebp
    3c84:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    3c87:	8b 45 08             	mov    0x8(%ebp),%eax
    3c8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    3c8d:	90                   	nop
    3c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3c91:	8a 10                	mov    (%eax),%dl
    3c93:	8b 45 08             	mov    0x8(%ebp),%eax
    3c96:	88 10                	mov    %dl,(%eax)
    3c98:	8b 45 08             	mov    0x8(%ebp),%eax
    3c9b:	8a 00                	mov    (%eax),%al
    3c9d:	84 c0                	test   %al,%al
    3c9f:	0f 95 c0             	setne  %al
    3ca2:	ff 45 08             	incl   0x8(%ebp)
    3ca5:	ff 45 0c             	incl   0xc(%ebp)
    3ca8:	84 c0                	test   %al,%al
    3caa:	75 e2                	jne    3c8e <strcpy+0xd>
    ;
  return os;
    3cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3caf:	c9                   	leave  
    3cb0:	c3                   	ret    

00003cb1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3cb1:	55                   	push   %ebp
    3cb2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    3cb4:	eb 06                	jmp    3cbc <strcmp+0xb>
    p++, q++;
    3cb6:	ff 45 08             	incl   0x8(%ebp)
    3cb9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    3cbc:	8b 45 08             	mov    0x8(%ebp),%eax
    3cbf:	8a 00                	mov    (%eax),%al
    3cc1:	84 c0                	test   %al,%al
    3cc3:	74 0e                	je     3cd3 <strcmp+0x22>
    3cc5:	8b 45 08             	mov    0x8(%ebp),%eax
    3cc8:	8a 10                	mov    (%eax),%dl
    3cca:	8b 45 0c             	mov    0xc(%ebp),%eax
    3ccd:	8a 00                	mov    (%eax),%al
    3ccf:	38 c2                	cmp    %al,%dl
    3cd1:	74 e3                	je     3cb6 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    3cd3:	8b 45 08             	mov    0x8(%ebp),%eax
    3cd6:	8a 00                	mov    (%eax),%al
    3cd8:	0f b6 d0             	movzbl %al,%edx
    3cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
    3cde:	8a 00                	mov    (%eax),%al
    3ce0:	0f b6 c0             	movzbl %al,%eax
    3ce3:	89 d1                	mov    %edx,%ecx
    3ce5:	29 c1                	sub    %eax,%ecx
    3ce7:	89 c8                	mov    %ecx,%eax
}
    3ce9:	5d                   	pop    %ebp
    3cea:	c3                   	ret    

00003ceb <strlen>:

uint
strlen(char *s)
{
    3ceb:	55                   	push   %ebp
    3cec:	89 e5                	mov    %esp,%ebp
    3cee:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    3cf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    3cf8:	eb 03                	jmp    3cfd <strlen+0x12>
    3cfa:	ff 45 fc             	incl   -0x4(%ebp)
    3cfd:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3d00:	8b 45 08             	mov    0x8(%ebp),%eax
    3d03:	01 d0                	add    %edx,%eax
    3d05:	8a 00                	mov    (%eax),%al
    3d07:	84 c0                	test   %al,%al
    3d09:	75 ef                	jne    3cfa <strlen+0xf>
    ;
  return n;
    3d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3d0e:	c9                   	leave  
    3d0f:	c3                   	ret    

00003d10 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3d10:	55                   	push   %ebp
    3d11:	89 e5                	mov    %esp,%ebp
    3d13:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    3d16:	8b 45 10             	mov    0x10(%ebp),%eax
    3d19:	89 44 24 08          	mov    %eax,0x8(%esp)
    3d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d20:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d24:	8b 45 08             	mov    0x8(%ebp),%eax
    3d27:	89 04 24             	mov    %eax,(%esp)
    3d2a:	e8 2d ff ff ff       	call   3c5c <stosb>
  return dst;
    3d2f:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3d32:	c9                   	leave  
    3d33:	c3                   	ret    

00003d34 <strchr>:

char*
strchr(const char *s, char c)
{
    3d34:	55                   	push   %ebp
    3d35:	89 e5                	mov    %esp,%ebp
    3d37:	83 ec 04             	sub    $0x4,%esp
    3d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
    3d3d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    3d40:	eb 12                	jmp    3d54 <strchr+0x20>
    if(*s == c)
    3d42:	8b 45 08             	mov    0x8(%ebp),%eax
    3d45:	8a 00                	mov    (%eax),%al
    3d47:	3a 45 fc             	cmp    -0x4(%ebp),%al
    3d4a:	75 05                	jne    3d51 <strchr+0x1d>
      return (char*)s;
    3d4c:	8b 45 08             	mov    0x8(%ebp),%eax
    3d4f:	eb 11                	jmp    3d62 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    3d51:	ff 45 08             	incl   0x8(%ebp)
    3d54:	8b 45 08             	mov    0x8(%ebp),%eax
    3d57:	8a 00                	mov    (%eax),%al
    3d59:	84 c0                	test   %al,%al
    3d5b:	75 e5                	jne    3d42 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    3d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3d62:	c9                   	leave  
    3d63:	c3                   	ret    

00003d64 <gets>:

char*
gets(char *buf, int max)
{
    3d64:	55                   	push   %ebp
    3d65:	89 e5                	mov    %esp,%ebp
    3d67:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3d6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    3d71:	eb 42                	jmp    3db5 <gets+0x51>
    cc = read(0, &c, 1);
    3d73:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3d7a:	00 
    3d7b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    3d7e:	89 44 24 04          	mov    %eax,0x4(%esp)
    3d82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3d89:	e8 62 01 00 00       	call   3ef0 <read>
    3d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    3d91:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    3d95:	7e 29                	jle    3dc0 <gets+0x5c>
      break;
    buf[i++] = c;
    3d97:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3d9a:	8b 45 08             	mov    0x8(%ebp),%eax
    3d9d:	01 c2                	add    %eax,%edx
    3d9f:	8a 45 ef             	mov    -0x11(%ebp),%al
    3da2:	88 02                	mov    %al,(%edx)
    3da4:	ff 45 f4             	incl   -0xc(%ebp)
    if(c == '\n' || c == '\r')
    3da7:	8a 45 ef             	mov    -0x11(%ebp),%al
    3daa:	3c 0a                	cmp    $0xa,%al
    3dac:	74 13                	je     3dc1 <gets+0x5d>
    3dae:	8a 45 ef             	mov    -0x11(%ebp),%al
    3db1:	3c 0d                	cmp    $0xd,%al
    3db3:	74 0c                	je     3dc1 <gets+0x5d>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3db8:	40                   	inc    %eax
    3db9:	3b 45 0c             	cmp    0xc(%ebp),%eax
    3dbc:	7c b5                	jl     3d73 <gets+0xf>
    3dbe:	eb 01                	jmp    3dc1 <gets+0x5d>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    3dc0:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    3dc1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    3dc4:	8b 45 08             	mov    0x8(%ebp),%eax
    3dc7:	01 d0                	add    %edx,%eax
    3dc9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    3dcc:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3dcf:	c9                   	leave  
    3dd0:	c3                   	ret    

00003dd1 <stat>:

int
stat(char *n, struct stat *st)
{
    3dd1:	55                   	push   %ebp
    3dd2:	89 e5                	mov    %esp,%ebp
    3dd4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3dd7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    3dde:	00 
    3ddf:	8b 45 08             	mov    0x8(%ebp),%eax
    3de2:	89 04 24             	mov    %eax,(%esp)
    3de5:	e8 2e 01 00 00       	call   3f18 <open>
    3dea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    3ded:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    3df1:	79 07                	jns    3dfa <stat+0x29>
    return -1;
    3df3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    3df8:	eb 23                	jmp    3e1d <stat+0x4c>
  r = fstat(fd, st);
    3dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
    3dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
    3e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e04:	89 04 24             	mov    %eax,(%esp)
    3e07:	e8 24 01 00 00       	call   3f30 <fstat>
    3e0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    3e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    3e12:	89 04 24             	mov    %eax,(%esp)
    3e15:	e8 e6 00 00 00       	call   3f00 <close>
  return r;
    3e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    3e1d:	c9                   	leave  
    3e1e:	c3                   	ret    

00003e1f <atoi>:

int
atoi(const char *s)
{
    3e1f:	55                   	push   %ebp
    3e20:	89 e5                	mov    %esp,%ebp
    3e22:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    3e25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    3e2c:	eb 21                	jmp    3e4f <atoi+0x30>
    n = n*10 + *s++ - '0';
    3e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    3e31:	89 d0                	mov    %edx,%eax
    3e33:	c1 e0 02             	shl    $0x2,%eax
    3e36:	01 d0                	add    %edx,%eax
    3e38:	d1 e0                	shl    %eax
    3e3a:	89 c2                	mov    %eax,%edx
    3e3c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e3f:	8a 00                	mov    (%eax),%al
    3e41:	0f be c0             	movsbl %al,%eax
    3e44:	01 d0                	add    %edx,%eax
    3e46:	83 e8 30             	sub    $0x30,%eax
    3e49:	89 45 fc             	mov    %eax,-0x4(%ebp)
    3e4c:	ff 45 08             	incl   0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3e4f:	8b 45 08             	mov    0x8(%ebp),%eax
    3e52:	8a 00                	mov    (%eax),%al
    3e54:	3c 2f                	cmp    $0x2f,%al
    3e56:	7e 09                	jle    3e61 <atoi+0x42>
    3e58:	8b 45 08             	mov    0x8(%ebp),%eax
    3e5b:	8a 00                	mov    (%eax),%al
    3e5d:	3c 39                	cmp    $0x39,%al
    3e5f:	7e cd                	jle    3e2e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    3e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    3e64:	c9                   	leave  
    3e65:	c3                   	ret    

00003e66 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    3e66:	55                   	push   %ebp
    3e67:	89 e5                	mov    %esp,%ebp
    3e69:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    3e6c:	8b 45 08             	mov    0x8(%ebp),%eax
    3e6f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    3e72:	8b 45 0c             	mov    0xc(%ebp),%eax
    3e75:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    3e78:	eb 10                	jmp    3e8a <memmove+0x24>
    *dst++ = *src++;
    3e7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    3e7d:	8a 10                	mov    (%eax),%dl
    3e7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    3e82:	88 10                	mov    %dl,(%eax)
    3e84:	ff 45 fc             	incl   -0x4(%ebp)
    3e87:	ff 45 f8             	incl   -0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3e8a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    3e8e:	0f 9f c0             	setg   %al
    3e91:	ff 4d 10             	decl   0x10(%ebp)
    3e94:	84 c0                	test   %al,%al
    3e96:	75 e2                	jne    3e7a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    3e98:	8b 45 08             	mov    0x8(%ebp),%eax
}
    3e9b:	c9                   	leave  
    3e9c:	c3                   	ret    

00003e9d <trampoline>:
    3e9d:	5a                   	pop    %edx
    3e9e:	59                   	pop    %ecx
    3e9f:	58                   	pop    %eax
    3ea0:	03 25 04 00 00 00    	add    0x4,%esp
    3ea6:	c9                   	leave  
    3ea7:	c3                   	ret    

00003ea8 <signal>:
	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
    3ea8:	55                   	push   %ebp
    3ea9:	89 e5                	mov    %esp,%ebp
    3eab:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
    3eae:	c7 44 24 08 9d 3e 00 	movl   $0x3e9d,0x8(%esp)
    3eb5:	00 
    3eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
    3eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
    3ebd:	8b 45 08             	mov    0x8(%ebp),%eax
    3ec0:	89 04 24             	mov    %eax,(%esp)
    3ec3:	e8 b8 00 00 00       	call   3f80 <register_signal_handler>
	return 0;
    3ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
    3ecd:	c9                   	leave  
    3ece:	c3                   	ret    
    3ecf:	90                   	nop

00003ed0 <fork>:
    3ed0:	b8 01 00 00 00       	mov    $0x1,%eax
    3ed5:	cd 40                	int    $0x40
    3ed7:	c3                   	ret    

00003ed8 <exit>:
    3ed8:	b8 02 00 00 00       	mov    $0x2,%eax
    3edd:	cd 40                	int    $0x40
    3edf:	c3                   	ret    

00003ee0 <wait>:
    3ee0:	b8 03 00 00 00       	mov    $0x3,%eax
    3ee5:	cd 40                	int    $0x40
    3ee7:	c3                   	ret    

00003ee8 <pipe>:
    3ee8:	b8 04 00 00 00       	mov    $0x4,%eax
    3eed:	cd 40                	int    $0x40
    3eef:	c3                   	ret    

00003ef0 <read>:
    3ef0:	b8 05 00 00 00       	mov    $0x5,%eax
    3ef5:	cd 40                	int    $0x40
    3ef7:	c3                   	ret    

00003ef8 <write>:
    3ef8:	b8 10 00 00 00       	mov    $0x10,%eax
    3efd:	cd 40                	int    $0x40
    3eff:	c3                   	ret    

00003f00 <close>:
    3f00:	b8 15 00 00 00       	mov    $0x15,%eax
    3f05:	cd 40                	int    $0x40
    3f07:	c3                   	ret    

00003f08 <kill>:
    3f08:	b8 06 00 00 00       	mov    $0x6,%eax
    3f0d:	cd 40                	int    $0x40
    3f0f:	c3                   	ret    

00003f10 <exec>:
    3f10:	b8 07 00 00 00       	mov    $0x7,%eax
    3f15:	cd 40                	int    $0x40
    3f17:	c3                   	ret    

00003f18 <open>:
    3f18:	b8 0f 00 00 00       	mov    $0xf,%eax
    3f1d:	cd 40                	int    $0x40
    3f1f:	c3                   	ret    

00003f20 <mknod>:
    3f20:	b8 11 00 00 00       	mov    $0x11,%eax
    3f25:	cd 40                	int    $0x40
    3f27:	c3                   	ret    

00003f28 <unlink>:
    3f28:	b8 12 00 00 00       	mov    $0x12,%eax
    3f2d:	cd 40                	int    $0x40
    3f2f:	c3                   	ret    

00003f30 <fstat>:
    3f30:	b8 08 00 00 00       	mov    $0x8,%eax
    3f35:	cd 40                	int    $0x40
    3f37:	c3                   	ret    

00003f38 <link>:
    3f38:	b8 13 00 00 00       	mov    $0x13,%eax
    3f3d:	cd 40                	int    $0x40
    3f3f:	c3                   	ret    

00003f40 <mkdir>:
    3f40:	b8 14 00 00 00       	mov    $0x14,%eax
    3f45:	cd 40                	int    $0x40
    3f47:	c3                   	ret    

00003f48 <chdir>:
    3f48:	b8 09 00 00 00       	mov    $0x9,%eax
    3f4d:	cd 40                	int    $0x40
    3f4f:	c3                   	ret    

00003f50 <dup>:
    3f50:	b8 0a 00 00 00       	mov    $0xa,%eax
    3f55:	cd 40                	int    $0x40
    3f57:	c3                   	ret    

00003f58 <getpid>:
    3f58:	b8 0b 00 00 00       	mov    $0xb,%eax
    3f5d:	cd 40                	int    $0x40
    3f5f:	c3                   	ret    

00003f60 <sbrk>:
    3f60:	b8 0c 00 00 00       	mov    $0xc,%eax
    3f65:	cd 40                	int    $0x40
    3f67:	c3                   	ret    

00003f68 <sleep>:
    3f68:	b8 0d 00 00 00       	mov    $0xd,%eax
    3f6d:	cd 40                	int    $0x40
    3f6f:	c3                   	ret    

00003f70 <uptime>:
    3f70:	b8 0e 00 00 00       	mov    $0xe,%eax
    3f75:	cd 40                	int    $0x40
    3f77:	c3                   	ret    

00003f78 <halt>:
    3f78:	b8 16 00 00 00       	mov    $0x16,%eax
    3f7d:	cd 40                	int    $0x40
    3f7f:	c3                   	ret    

00003f80 <register_signal_handler>:
    3f80:	b8 17 00 00 00       	mov    $0x17,%eax
    3f85:	cd 40                	int    $0x40
    3f87:	c3                   	ret    

00003f88 <alarm>:
    3f88:	b8 18 00 00 00       	mov    $0x18,%eax
    3f8d:	cd 40                	int    $0x40
    3f8f:	c3                   	ret    

00003f90 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    3f90:	55                   	push   %ebp
    3f91:	89 e5                	mov    %esp,%ebp
    3f93:	83 ec 28             	sub    $0x28,%esp
    3f96:	8b 45 0c             	mov    0xc(%ebp),%eax
    3f99:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    3f9c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    3fa3:	00 
    3fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    3fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
    3fab:	8b 45 08             	mov    0x8(%ebp),%eax
    3fae:	89 04 24             	mov    %eax,(%esp)
    3fb1:	e8 42 ff ff ff       	call   3ef8 <write>
}
    3fb6:	c9                   	leave  
    3fb7:	c3                   	ret    

00003fb8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3fb8:	55                   	push   %ebp
    3fb9:	89 e5                	mov    %esp,%ebp
    3fbb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    3fbe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    3fc5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    3fc9:	74 17                	je     3fe2 <printint+0x2a>
    3fcb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    3fcf:	79 11                	jns    3fe2 <printint+0x2a>
    neg = 1;
    3fd1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    3fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fdb:	f7 d8                	neg    %eax
    3fdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    3fe0:	eb 06                	jmp    3fe8 <printint+0x30>
  } else {
    x = xx;
    3fe2:	8b 45 0c             	mov    0xc(%ebp),%eax
    3fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    3fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    3fef:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    3ff5:	ba 00 00 00 00       	mov    $0x0,%edx
    3ffa:	f7 f1                	div    %ecx
    3ffc:	89 d0                	mov    %edx,%eax
    3ffe:	8a 80 34 63 00 00    	mov    0x6334(%eax),%al
    4004:	8d 4d dc             	lea    -0x24(%ebp),%ecx
    4007:	8b 55 f4             	mov    -0xc(%ebp),%edx
    400a:	01 ca                	add    %ecx,%edx
    400c:	88 02                	mov    %al,(%edx)
    400e:	ff 45 f4             	incl   -0xc(%ebp)
  }while((x /= base) != 0);
    4011:	8b 55 10             	mov    0x10(%ebp),%edx
    4014:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    4017:	8b 45 ec             	mov    -0x14(%ebp),%eax
    401a:	ba 00 00 00 00       	mov    $0x0,%edx
    401f:	f7 75 d4             	divl   -0x2c(%ebp)
    4022:	89 45 ec             	mov    %eax,-0x14(%ebp)
    4025:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    4029:	75 c4                	jne    3fef <printint+0x37>
  if(neg)
    402b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    402f:	74 2c                	je     405d <printint+0xa5>
    buf[i++] = '-';
    4031:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4034:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4037:	01 d0                	add    %edx,%eax
    4039:	c6 00 2d             	movb   $0x2d,(%eax)
    403c:	ff 45 f4             	incl   -0xc(%ebp)

  while(--i >= 0)
    403f:	eb 1c                	jmp    405d <printint+0xa5>
    putc(fd, buf[i]);
    4041:	8d 55 dc             	lea    -0x24(%ebp),%edx
    4044:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4047:	01 d0                	add    %edx,%eax
    4049:	8a 00                	mov    (%eax),%al
    404b:	0f be c0             	movsbl %al,%eax
    404e:	89 44 24 04          	mov    %eax,0x4(%esp)
    4052:	8b 45 08             	mov    0x8(%ebp),%eax
    4055:	89 04 24             	mov    %eax,(%esp)
    4058:	e8 33 ff ff ff       	call   3f90 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    405d:	ff 4d f4             	decl   -0xc(%ebp)
    4060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4064:	79 db                	jns    4041 <printint+0x89>
    putc(fd, buf[i]);
}
    4066:	c9                   	leave  
    4067:	c3                   	ret    

00004068 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    4068:	55                   	push   %ebp
    4069:	89 e5                	mov    %esp,%ebp
    406b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    406e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    4075:	8d 45 0c             	lea    0xc(%ebp),%eax
    4078:	83 c0 04             	add    $0x4,%eax
    407b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    407e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    4085:	e9 78 01 00 00       	jmp    4202 <printf+0x19a>
    c = fmt[i] & 0xff;
    408a:	8b 55 0c             	mov    0xc(%ebp),%edx
    408d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4090:	01 d0                	add    %edx,%eax
    4092:	8a 00                	mov    (%eax),%al
    4094:	0f be c0             	movsbl %al,%eax
    4097:	25 ff 00 00 00       	and    $0xff,%eax
    409c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    409f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    40a3:	75 2c                	jne    40d1 <printf+0x69>
      if(c == '%'){
    40a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    40a9:	75 0c                	jne    40b7 <printf+0x4f>
        state = '%';
    40ab:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    40b2:	e9 48 01 00 00       	jmp    41ff <printf+0x197>
      } else {
        putc(fd, c);
    40b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    40ba:	0f be c0             	movsbl %al,%eax
    40bd:	89 44 24 04          	mov    %eax,0x4(%esp)
    40c1:	8b 45 08             	mov    0x8(%ebp),%eax
    40c4:	89 04 24             	mov    %eax,(%esp)
    40c7:	e8 c4 fe ff ff       	call   3f90 <putc>
    40cc:	e9 2e 01 00 00       	jmp    41ff <printf+0x197>
      }
    } else if(state == '%'){
    40d1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    40d5:	0f 85 24 01 00 00    	jne    41ff <printf+0x197>
      if(c == 'd'){
    40db:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    40df:	75 2d                	jne    410e <printf+0xa6>
        printint(fd, *ap, 10, 1);
    40e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
    40e4:	8b 00                	mov    (%eax),%eax
    40e6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    40ed:	00 
    40ee:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    40f5:	00 
    40f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    40fa:	8b 45 08             	mov    0x8(%ebp),%eax
    40fd:	89 04 24             	mov    %eax,(%esp)
    4100:	e8 b3 fe ff ff       	call   3fb8 <printint>
        ap++;
    4105:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4109:	e9 ea 00 00 00       	jmp    41f8 <printf+0x190>
      } else if(c == 'x' || c == 'p'){
    410e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    4112:	74 06                	je     411a <printf+0xb2>
    4114:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    4118:	75 2d                	jne    4147 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    411a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    411d:	8b 00                	mov    (%eax),%eax
    411f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    4126:	00 
    4127:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    412e:	00 
    412f:	89 44 24 04          	mov    %eax,0x4(%esp)
    4133:	8b 45 08             	mov    0x8(%ebp),%eax
    4136:	89 04 24             	mov    %eax,(%esp)
    4139:	e8 7a fe ff ff       	call   3fb8 <printint>
        ap++;
    413e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    4142:	e9 b1 00 00 00       	jmp    41f8 <printf+0x190>
      } else if(c == 's'){
    4147:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    414b:	75 43                	jne    4190 <printf+0x128>
        s = (char*)*ap;
    414d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4150:	8b 00                	mov    (%eax),%eax
    4152:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    4155:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    4159:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    415d:	75 25                	jne    4184 <printf+0x11c>
          s = "(null)";
    415f:	c7 45 f4 0a 5c 00 00 	movl   $0x5c0a,-0xc(%ebp)
        while(*s != 0){
    4166:	eb 1c                	jmp    4184 <printf+0x11c>
          putc(fd, *s);
    4168:	8b 45 f4             	mov    -0xc(%ebp),%eax
    416b:	8a 00                	mov    (%eax),%al
    416d:	0f be c0             	movsbl %al,%eax
    4170:	89 44 24 04          	mov    %eax,0x4(%esp)
    4174:	8b 45 08             	mov    0x8(%ebp),%eax
    4177:	89 04 24             	mov    %eax,(%esp)
    417a:	e8 11 fe ff ff       	call   3f90 <putc>
          s++;
    417f:	ff 45 f4             	incl   -0xc(%ebp)
    4182:	eb 01                	jmp    4185 <printf+0x11d>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    4184:	90                   	nop
    4185:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4188:	8a 00                	mov    (%eax),%al
    418a:	84 c0                	test   %al,%al
    418c:	75 da                	jne    4168 <printf+0x100>
    418e:	eb 68                	jmp    41f8 <printf+0x190>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4190:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    4194:	75 1d                	jne    41b3 <printf+0x14b>
        putc(fd, *ap);
    4196:	8b 45 e8             	mov    -0x18(%ebp),%eax
    4199:	8b 00                	mov    (%eax),%eax
    419b:	0f be c0             	movsbl %al,%eax
    419e:	89 44 24 04          	mov    %eax,0x4(%esp)
    41a2:	8b 45 08             	mov    0x8(%ebp),%eax
    41a5:	89 04 24             	mov    %eax,(%esp)
    41a8:	e8 e3 fd ff ff       	call   3f90 <putc>
        ap++;
    41ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    41b1:	eb 45                	jmp    41f8 <printf+0x190>
      } else if(c == '%'){
    41b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    41b7:	75 17                	jne    41d0 <printf+0x168>
        putc(fd, c);
    41b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41bc:	0f be c0             	movsbl %al,%eax
    41bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    41c3:	8b 45 08             	mov    0x8(%ebp),%eax
    41c6:	89 04 24             	mov    %eax,(%esp)
    41c9:	e8 c2 fd ff ff       	call   3f90 <putc>
    41ce:	eb 28                	jmp    41f8 <printf+0x190>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    41d0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    41d7:	00 
    41d8:	8b 45 08             	mov    0x8(%ebp),%eax
    41db:	89 04 24             	mov    %eax,(%esp)
    41de:	e8 ad fd ff ff       	call   3f90 <putc>
        putc(fd, c);
    41e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    41e6:	0f be c0             	movsbl %al,%eax
    41e9:	89 44 24 04          	mov    %eax,0x4(%esp)
    41ed:	8b 45 08             	mov    0x8(%ebp),%eax
    41f0:	89 04 24             	mov    %eax,(%esp)
    41f3:	e8 98 fd ff ff       	call   3f90 <putc>
      }
      state = 0;
    41f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    41ff:	ff 45 f0             	incl   -0x10(%ebp)
    4202:	8b 55 0c             	mov    0xc(%ebp),%edx
    4205:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4208:	01 d0                	add    %edx,%eax
    420a:	8a 00                	mov    (%eax),%al
    420c:	84 c0                	test   %al,%al
    420e:	0f 85 76 fe ff ff    	jne    408a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    4214:	c9                   	leave  
    4215:	c3                   	ret    
    4216:	66 90                	xchg   %ax,%ax

00004218 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4218:	55                   	push   %ebp
    4219:	89 e5                	mov    %esp,%ebp
    421b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    421e:	8b 45 08             	mov    0x8(%ebp),%eax
    4221:	83 e8 08             	sub    $0x8,%eax
    4224:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4227:	a1 e8 63 00 00       	mov    0x63e8,%eax
    422c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    422f:	eb 24                	jmp    4255 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4231:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4234:	8b 00                	mov    (%eax),%eax
    4236:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4239:	77 12                	ja     424d <free+0x35>
    423b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    423e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    4241:	77 24                	ja     4267 <free+0x4f>
    4243:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4246:	8b 00                	mov    (%eax),%eax
    4248:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    424b:	77 1a                	ja     4267 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    424d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4250:	8b 00                	mov    (%eax),%eax
    4252:	89 45 fc             	mov    %eax,-0x4(%ebp)
    4255:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4258:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    425b:	76 d4                	jbe    4231 <free+0x19>
    425d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    4260:	8b 00                	mov    (%eax),%eax
    4262:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    4265:	76 ca                	jbe    4231 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    4267:	8b 45 f8             	mov    -0x8(%ebp),%eax
    426a:	8b 40 04             	mov    0x4(%eax),%eax
    426d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    4274:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4277:	01 c2                	add    %eax,%edx
    4279:	8b 45 fc             	mov    -0x4(%ebp),%eax
    427c:	8b 00                	mov    (%eax),%eax
    427e:	39 c2                	cmp    %eax,%edx
    4280:	75 24                	jne    42a6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    4282:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4285:	8b 50 04             	mov    0x4(%eax),%edx
    4288:	8b 45 fc             	mov    -0x4(%ebp),%eax
    428b:	8b 00                	mov    (%eax),%eax
    428d:	8b 40 04             	mov    0x4(%eax),%eax
    4290:	01 c2                	add    %eax,%edx
    4292:	8b 45 f8             	mov    -0x8(%ebp),%eax
    4295:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    4298:	8b 45 fc             	mov    -0x4(%ebp),%eax
    429b:	8b 00                	mov    (%eax),%eax
    429d:	8b 10                	mov    (%eax),%edx
    429f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42a2:	89 10                	mov    %edx,(%eax)
    42a4:	eb 0a                	jmp    42b0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    42a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42a9:	8b 10                	mov    (%eax),%edx
    42ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    42b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42b3:	8b 40 04             	mov    0x4(%eax),%eax
    42b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    42bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42c0:	01 d0                	add    %edx,%eax
    42c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    42c5:	75 20                	jne    42e7 <free+0xcf>
    p->s.size += bp->s.size;
    42c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42ca:	8b 50 04             	mov    0x4(%eax),%edx
    42cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42d0:	8b 40 04             	mov    0x4(%eax),%eax
    42d3:	01 c2                	add    %eax,%edx
    42d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42d8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    42db:	8b 45 f8             	mov    -0x8(%ebp),%eax
    42de:	8b 10                	mov    (%eax),%edx
    42e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42e3:	89 10                	mov    %edx,(%eax)
    42e5:	eb 08                	jmp    42ef <free+0xd7>
  } else
    p->s.ptr = bp;
    42e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
    42ed:	89 10                	mov    %edx,(%eax)
  freep = p;
    42ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    42f2:	a3 e8 63 00 00       	mov    %eax,0x63e8
}
    42f7:	c9                   	leave  
    42f8:	c3                   	ret    

000042f9 <morecore>:

static Header*
morecore(uint nu)
{
    42f9:	55                   	push   %ebp
    42fa:	89 e5                	mov    %esp,%ebp
    42fc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    42ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    4306:	77 07                	ja     430f <morecore+0x16>
    nu = 4096;
    4308:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    430f:	8b 45 08             	mov    0x8(%ebp),%eax
    4312:	c1 e0 03             	shl    $0x3,%eax
    4315:	89 04 24             	mov    %eax,(%esp)
    4318:	e8 43 fc ff ff       	call   3f60 <sbrk>
    431d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    4320:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    4324:	75 07                	jne    432d <morecore+0x34>
    return 0;
    4326:	b8 00 00 00 00       	mov    $0x0,%eax
    432b:	eb 22                	jmp    434f <morecore+0x56>
  hp = (Header*)p;
    432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4330:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    4333:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4336:	8b 55 08             	mov    0x8(%ebp),%edx
    4339:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    433c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    433f:	83 c0 08             	add    $0x8,%eax
    4342:	89 04 24             	mov    %eax,(%esp)
    4345:	e8 ce fe ff ff       	call   4218 <free>
  return freep;
    434a:	a1 e8 63 00 00       	mov    0x63e8,%eax
}
    434f:	c9                   	leave  
    4350:	c3                   	ret    

00004351 <malloc>:

void*
malloc(uint nbytes)
{
    4351:	55                   	push   %ebp
    4352:	89 e5                	mov    %esp,%ebp
    4354:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4357:	8b 45 08             	mov    0x8(%ebp),%eax
    435a:	83 c0 07             	add    $0x7,%eax
    435d:	c1 e8 03             	shr    $0x3,%eax
    4360:	40                   	inc    %eax
    4361:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    4364:	a1 e8 63 00 00       	mov    0x63e8,%eax
    4369:	89 45 f0             	mov    %eax,-0x10(%ebp)
    436c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    4370:	75 23                	jne    4395 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    4372:	c7 45 f0 e0 63 00 00 	movl   $0x63e0,-0x10(%ebp)
    4379:	8b 45 f0             	mov    -0x10(%ebp),%eax
    437c:	a3 e8 63 00 00       	mov    %eax,0x63e8
    4381:	a1 e8 63 00 00       	mov    0x63e8,%eax
    4386:	a3 e0 63 00 00       	mov    %eax,0x63e0
    base.s.size = 0;
    438b:	c7 05 e4 63 00 00 00 	movl   $0x0,0x63e4
    4392:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4395:	8b 45 f0             	mov    -0x10(%ebp),%eax
    4398:	8b 00                	mov    (%eax),%eax
    439a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43a0:	8b 40 04             	mov    0x4(%eax),%eax
    43a3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43a6:	72 4d                	jb     43f5 <malloc+0xa4>
      if(p->s.size == nunits)
    43a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43ab:	8b 40 04             	mov    0x4(%eax),%eax
    43ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    43b1:	75 0c                	jne    43bf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    43b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43b6:	8b 10                	mov    (%eax),%edx
    43b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43bb:	89 10                	mov    %edx,(%eax)
    43bd:	eb 26                	jmp    43e5 <malloc+0x94>
      else {
        p->s.size -= nunits;
    43bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43c2:	8b 40 04             	mov    0x4(%eax),%eax
    43c5:	89 c2                	mov    %eax,%edx
    43c7:	2b 55 ec             	sub    -0x14(%ebp),%edx
    43ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43cd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    43d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43d3:	8b 40 04             	mov    0x4(%eax),%eax
    43d6:	c1 e0 03             	shl    $0x3,%eax
    43d9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    43dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43df:	8b 55 ec             	mov    -0x14(%ebp),%edx
    43e2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    43e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    43e8:	a3 e8 63 00 00       	mov    %eax,0x63e8
      return (void*)(p + 1);
    43ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    43f0:	83 c0 08             	add    $0x8,%eax
    43f3:	eb 38                	jmp    442d <malloc+0xdc>
    }
    if(p == freep)
    43f5:	a1 e8 63 00 00       	mov    0x63e8,%eax
    43fa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    43fd:	75 1b                	jne    441a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    43ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
    4402:	89 04 24             	mov    %eax,(%esp)
    4405:	e8 ef fe ff ff       	call   42f9 <morecore>
    440a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    440d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    4411:	75 07                	jne    441a <malloc+0xc9>
        return 0;
    4413:	b8 00 00 00 00       	mov    $0x0,%eax
    4418:	eb 13                	jmp    442d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    441a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    441d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    4420:	8b 45 f4             	mov    -0xc(%ebp),%eax
    4423:	8b 00                	mov    (%eax),%eax
    4425:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    4428:	e9 70 ff ff ff       	jmp    439d <malloc+0x4c>
}
    442d:	c9                   	leave  
    442e:	c3                   	ret    
