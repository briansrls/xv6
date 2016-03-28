
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 06 09 00 00 	movl   $0x906,(%esp)
  18:	e8 cb 03 00 00       	call   3e8 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 06 09 00 00 	movl   $0x906,(%esp)
  38:	e8 b3 03 00 00       	call   3f0 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 06 09 00 00 	movl   $0x906,(%esp)
  4c:	e8 97 03 00 00       	call   3e8 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 c3 03 00 00       	call   420 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 b7 03 00 00       	call   420 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 0e 09 00 	movl   $0x90e,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 bc 04 00 00       	call   53c <printf>
    pid = fork();
  80:	e8 1b 03 00 00       	call   3a0 <fork>
  85:	89 44 24 18          	mov    %eax,0x18(%esp)
    if(pid < 0){
  89:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 21 09 00 	movl   $0x921,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 98 04 00 00       	call   53c <printf>
      exit();
  a4:	e8 ff 02 00 00       	call   3a8 <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ae:	75 43                	jne    f3 <main+0xf3>
      exec("sh", argv);
  b0:	c7 44 24 04 5c 09 00 	movl   $0x95c,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 03 09 00 00 	movl   $0x903,(%esp)
  bf:	e8 1c 03 00 00       	call   3e0 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 34 09 00 	movl   $0x934,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 64 04 00 00       	call   53c <printf>
      exit();
  d8:	e8 cb 02 00 00       	call   3a8 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 4a 09 00 	movl   $0x94a,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 4b 04 00 00       	call   53c <printf>
  f1:	eb 01                	jmp    f4 <main+0xf4>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f3:	90                   	nop
  f4:	e8 b7 02 00 00       	call   3b0 <wait>
  f9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  fd:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 102:	0f 88 63 ff ff ff    	js     6b <main+0x6b>
 108:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 10c:	3b 44 24 18          	cmp    0x18(%esp),%eax
 110:	75 cb                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 112:	e9 55 ff ff ff       	jmp    6c <main+0x6c>
 117:	90                   	nop

00000118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 149:	8b 45 0c             	mov    0xc(%ebp),%eax
 14c:	0f b6 10             	movzbl (%eax),%edx
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	88 10                	mov    %dl,(%eax)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	0f 95 c0             	setne  %al
 15f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 163:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 167:	84 c0                	test   %al,%al
 169:	75 de                	jne    149 <strcpy+0xc>
    ;
  return os;
 16b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16e:	c9                   	leave  
 16f:	c3                   	ret    

00000170 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 170:	55                   	push   %ebp
 171:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 173:	eb 08                	jmp    17d <strcmp+0xd>
    p++, q++;
 175:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 179:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17d:	8b 45 08             	mov    0x8(%ebp),%eax
 180:	0f b6 00             	movzbl (%eax),%eax
 183:	84 c0                	test   %al,%al
 185:	74 10                	je     197 <strcmp+0x27>
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 10             	movzbl (%eax),%edx
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	38 c2                	cmp    %al,%dl
 195:	74 de                	je     175 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	0f b6 00             	movzbl (%eax),%eax
 19d:	0f b6 d0             	movzbl %al,%edx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	0f b6 00             	movzbl (%eax),%eax
 1a6:	0f b6 c0             	movzbl %al,%eax
 1a9:	89 d1                	mov    %edx,%ecx
 1ab:	29 c1                	sub    %eax,%ecx
 1ad:	89 c8                	mov    %ecx,%eax
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strlen>:

uint
strlen(char *s)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1be:	eb 04                	jmp    1c4 <strlen+0x13>
 1c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c7:	03 45 08             	add    0x8(%ebp),%eax
 1ca:	0f b6 00             	movzbl (%eax),%eax
 1cd:	84 c0                	test   %al,%al
 1cf:	75 ef                	jne    1c0 <strlen+0xf>
    ;
  return n;
 1d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d4:	c9                   	leave  
 1d5:	c3                   	ret    

000001d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1dc:	8b 45 10             	mov    0x10(%ebp),%eax
 1df:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 23 ff ff ff       	call   118 <stosb>
  return dst;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strchr>:

char*
strchr(const char *s, char c)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 04             	sub    $0x4,%esp
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 206:	eb 14                	jmp    21c <strchr+0x22>
    if(*s == c)
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	0f b6 00             	movzbl (%eax),%eax
 20e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 211:	75 05                	jne    218 <strchr+0x1e>
      return (char*)s;
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	eb 13                	jmp    22b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	84 c0                	test   %al,%al
 224:	75 e2                	jne    208 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 226:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22b:	c9                   	leave  
 22c:	c3                   	ret    

0000022d <gets>:

char*
gets(char *buf, int max)
{
 22d:	55                   	push   %ebp
 22e:	89 e5                	mov    %esp,%ebp
 230:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 233:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 23a:	eb 44                	jmp    280 <gets+0x53>
    cc = read(0, &c, 1);
 23c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 243:	00 
 244:	8d 45 ef             	lea    -0x11(%ebp),%eax
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 252:	e8 69 01 00 00       	call   3c0 <read>
 257:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 25a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25e:	7e 2d                	jle    28d <gets+0x60>
      break;
    buf[i++] = c;
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	03 45 08             	add    0x8(%ebp),%eax
 266:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26a:	88 10                	mov    %dl,(%eax)
 26c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 270:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 274:	3c 0a                	cmp    $0xa,%al
 276:	74 16                	je     28e <gets+0x61>
 278:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27c:	3c 0d                	cmp    $0xd,%al
 27e:	74 0e                	je     28e <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 280:	8b 45 f0             	mov    -0x10(%ebp),%eax
 283:	83 c0 01             	add    $0x1,%eax
 286:	3b 45 0c             	cmp    0xc(%ebp),%eax
 289:	7c b1                	jl     23c <gets+0xf>
 28b:	eb 01                	jmp    28e <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 291:	03 45 08             	add    0x8(%ebp),%eax
 294:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <stat>:

int
stat(char *n, struct stat *st)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a9:	00 
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 33 01 00 00       	call   3e8 <open>
 2b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 2b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2bc:	79 07                	jns    2c5 <stat+0x29>
    return -1;
 2be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c3:	eb 23                	jmp    2e8 <stat+0x4c>
  r = fstat(fd, st);
 2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2cf:	89 04 24             	mov    %eax,(%esp)
 2d2:	e8 29 01 00 00       	call   400 <fstat>
 2d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 2da:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2dd:	89 04 24             	mov    %eax,(%esp)
 2e0:	e8 eb 00 00 00       	call   3d0 <close>
  return r;
 2e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2e8:	c9                   	leave  
 2e9:	c3                   	ret    

000002ea <atoi>:

int
atoi(const char *s)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f7:	eb 24                	jmp    31d <atoi+0x33>
    n = n*10 + *s++ - '0';
 2f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fc:	89 d0                	mov    %edx,%eax
 2fe:	c1 e0 02             	shl    $0x2,%eax
 301:	01 d0                	add    %edx,%eax
 303:	01 c0                	add    %eax,%eax
 305:	89 c2                	mov    %eax,%edx
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 00             	movzbl (%eax),%eax
 30d:	0f be c0             	movsbl %al,%eax
 310:	8d 04 02             	lea    (%edx,%eax,1),%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2f                	cmp    $0x2f,%al
 325:	7e 0a                	jle    331 <atoi+0x47>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 39                	cmp    $0x39,%al
 32f:	7e c8                	jle    2f9 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 331:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 348:	eb 13                	jmp    35d <memmove+0x27>
    *dst++ = *src++;
 34a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34d:	0f b6 10             	movzbl (%eax),%edx
 350:	8b 45 f8             	mov    -0x8(%ebp),%eax
 353:	88 10                	mov    %dl,(%eax)
 355:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 359:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 361:	0f 9f c0             	setg   %al
 364:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 de                	jne    34a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    

00000371 <trampoline>:
 371:	5a                   	pop    %edx
 372:	59                   	pop    %ecx
 373:	58                   	pop    %eax
 374:	c9                   	leave  
 375:	c3                   	ret    

00000376 <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 37c:	c7 44 24 08 71 03 00 	movl   $0x371,0x8(%esp)
 383:	00 
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 44 24 04          	mov    %eax,0x4(%esp)
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	89 04 24             	mov    %eax,(%esp)
 391:	e8 ba 00 00 00       	call   450 <register_signal_handler>
	return 0;
 396:	b8 00 00 00 00       	mov    $0x0,%eax
}
 39b:	c9                   	leave  
 39c:	c3                   	ret    
 39d:	90                   	nop
 39e:	90                   	nop
 39f:	90                   	nop

000003a0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a0:	b8 01 00 00 00       	mov    $0x1,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <exit>:
SYSCALL(exit)
 3a8:	b8 02 00 00 00       	mov    $0x2,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <wait>:
SYSCALL(wait)
 3b0:	b8 03 00 00 00       	mov    $0x3,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <pipe>:
SYSCALL(pipe)
 3b8:	b8 04 00 00 00       	mov    $0x4,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <read>:
SYSCALL(read)
 3c0:	b8 05 00 00 00       	mov    $0x5,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <write>:
SYSCALL(write)
 3c8:	b8 10 00 00 00       	mov    $0x10,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <close>:
SYSCALL(close)
 3d0:	b8 15 00 00 00       	mov    $0x15,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <kill>:
SYSCALL(kill)
 3d8:	b8 06 00 00 00       	mov    $0x6,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <exec>:
SYSCALL(exec)
 3e0:	b8 07 00 00 00       	mov    $0x7,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <open>:
SYSCALL(open)
 3e8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mknod>:
SYSCALL(mknod)
 3f0:	b8 11 00 00 00       	mov    $0x11,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <unlink>:
SYSCALL(unlink)
 3f8:	b8 12 00 00 00       	mov    $0x12,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <fstat>:
SYSCALL(fstat)
 400:	b8 08 00 00 00       	mov    $0x8,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <link>:
SYSCALL(link)
 408:	b8 13 00 00 00       	mov    $0x13,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <mkdir>:
SYSCALL(mkdir)
 410:	b8 14 00 00 00       	mov    $0x14,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <chdir>:
SYSCALL(chdir)
 418:	b8 09 00 00 00       	mov    $0x9,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <dup>:
SYSCALL(dup)
 420:	b8 0a 00 00 00       	mov    $0xa,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <getpid>:
SYSCALL(getpid)
 428:	b8 0b 00 00 00       	mov    $0xb,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sbrk>:
SYSCALL(sbrk)
 430:	b8 0c 00 00 00       	mov    $0xc,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <sleep>:
SYSCALL(sleep)
 438:	b8 0d 00 00 00       	mov    $0xd,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <uptime>:
SYSCALL(uptime)
 440:	b8 0e 00 00 00       	mov    $0xe,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <halt>:
SYSCALL(halt)
 448:	b8 16 00 00 00       	mov    $0x16,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <register_signal_handler>:
SYSCALL(register_signal_handler)
 450:	b8 17 00 00 00       	mov    $0x17,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <alarm>:
SYSCALL(alarm)
 458:	b8 18 00 00 00       	mov    $0x18,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	83 ec 28             	sub    $0x28,%esp
 466:	8b 45 0c             	mov    0xc(%ebp),%eax
 469:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 46c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 473:	00 
 474:	8d 45 f4             	lea    -0xc(%ebp),%eax
 477:	89 44 24 04          	mov    %eax,0x4(%esp)
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	89 04 24             	mov    %eax,(%esp)
 481:	e8 42 ff ff ff       	call   3c8 <write>
}
 486:	c9                   	leave  
 487:	c3                   	ret    

00000488 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 488:	55                   	push   %ebp
 489:	89 e5                	mov    %esp,%ebp
 48b:	53                   	push   %ebx
 48c:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 496:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 49a:	74 17                	je     4b3 <printint+0x2b>
 49c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a0:	79 11                	jns    4b3 <printint+0x2b>
    neg = 1;
 4a2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ac:	f7 d8                	neg    %eax
 4ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b1:	eb 06                	jmp    4b9 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 4b9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 4c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ce:	f7 f3                	div    %ebx
 4d0:	89 d0                	mov    %edx,%eax
 4d2:	0f b6 80 64 09 00 00 	movzbl 0x964(%eax),%eax
 4d9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 4dd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 4e1:	8b 45 10             	mov    0x10(%ebp),%eax
 4e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ea:	ba 00 00 00 00       	mov    $0x0,%edx
 4ef:	f7 75 d4             	divl   -0x2c(%ebp)
 4f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	75 c5                	jne    4c0 <printint+0x38>
  if(neg)
 4fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4ff:	74 2a                	je     52b <printint+0xa3>
    buf[i++] = '-';
 501:	8b 45 ec             	mov    -0x14(%ebp),%eax
 504:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 509:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 50d:	eb 1d                	jmp    52c <printint+0xa4>
    putc(fd, buf[i]);
 50f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 512:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 517:	0f be c0             	movsbl %al,%eax
 51a:	89 44 24 04          	mov    %eax,0x4(%esp)
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	89 04 24             	mov    %eax,(%esp)
 524:	e8 37 ff ff ff       	call   460 <putc>
 529:	eb 01                	jmp    52c <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 52b:	90                   	nop
 52c:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 530:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 534:	79 d9                	jns    50f <printint+0x87>
    putc(fd, buf[i]);
}
 536:	83 c4 44             	add    $0x44,%esp
 539:	5b                   	pop    %ebx
 53a:	5d                   	pop    %ebp
 53b:	c3                   	ret    

0000053c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 53c:	55                   	push   %ebp
 53d:	89 e5                	mov    %esp,%ebp
 53f:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 542:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 549:	8d 45 0c             	lea    0xc(%ebp),%eax
 54c:	83 c0 04             	add    $0x4,%eax
 54f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 552:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 559:	e9 7e 01 00 00       	jmp    6dc <printf+0x1a0>
    c = fmt[i] & 0xff;
 55e:	8b 55 0c             	mov    0xc(%ebp),%edx
 561:	8b 45 ec             	mov    -0x14(%ebp),%eax
 564:	8d 04 02             	lea    (%edx,%eax,1),%eax
 567:	0f b6 00             	movzbl (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	25 ff 00 00 00       	and    $0xff,%eax
 572:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 579:	75 2c                	jne    5a7 <printf+0x6b>
      if(c == '%'){
 57b:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 57f:	75 0c                	jne    58d <printf+0x51>
        state = '%';
 581:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 588:	e9 4b 01 00 00       	jmp    6d8 <printf+0x19c>
      } else {
        putc(fd, c);
 58d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	89 44 24 04          	mov    %eax,0x4(%esp)
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	89 04 24             	mov    %eax,(%esp)
 59d:	e8 be fe ff ff       	call   460 <putc>
 5a2:	e9 31 01 00 00       	jmp    6d8 <printf+0x19c>
      }
    } else if(state == '%'){
 5a7:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 5ab:	0f 85 27 01 00 00    	jne    6d8 <printf+0x19c>
      if(c == 'd'){
 5b1:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 5b5:	75 2d                	jne    5e4 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5c3:	00 
 5c4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5cb:	00 
 5cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d0:	8b 45 08             	mov    0x8(%ebp),%eax
 5d3:	89 04 24             	mov    %eax,(%esp)
 5d6:	e8 ad fe ff ff       	call   488 <printint>
        ap++;
 5db:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 5df:	e9 ed 00 00 00       	jmp    6d1 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 5e4:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 5e8:	74 06                	je     5f0 <printf+0xb4>
 5ea:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 5ee:	75 2d                	jne    61d <printf+0xe1>
        printint(fd, *ap, 16, 0);
 5f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f3:	8b 00                	mov    (%eax),%eax
 5f5:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5fc:	00 
 5fd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 604:	00 
 605:	89 44 24 04          	mov    %eax,0x4(%esp)
 609:	8b 45 08             	mov    0x8(%ebp),%eax
 60c:	89 04 24             	mov    %eax,(%esp)
 60f:	e8 74 fe ff ff       	call   488 <printint>
        ap++;
 614:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 618:	e9 b4 00 00 00       	jmp    6d1 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 61d:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 621:	75 46                	jne    669 <printf+0x12d>
        s = (char*)*ap;
 623:	8b 45 f4             	mov    -0xc(%ebp),%eax
 626:	8b 00                	mov    (%eax),%eax
 628:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 62b:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 62f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 633:	75 27                	jne    65c <printf+0x120>
          s = "(null)";
 635:	c7 45 e4 53 09 00 00 	movl   $0x953,-0x1c(%ebp)
        while(*s != 0){
 63c:	eb 1f                	jmp    65d <printf+0x121>
          putc(fd, *s);
 63e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	0f be c0             	movsbl %al,%eax
 647:	89 44 24 04          	mov    %eax,0x4(%esp)
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	89 04 24             	mov    %eax,(%esp)
 651:	e8 0a fe ff ff       	call   460 <putc>
          s++;
 656:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 65a:	eb 01                	jmp    65d <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 65c:	90                   	nop
 65d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 660:	0f b6 00             	movzbl (%eax),%eax
 663:	84 c0                	test   %al,%al
 665:	75 d7                	jne    63e <printf+0x102>
 667:	eb 68                	jmp    6d1 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 669:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 66d:	75 1d                	jne    68c <printf+0x150>
        putc(fd, *ap);
 66f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 672:	8b 00                	mov    (%eax),%eax
 674:	0f be c0             	movsbl %al,%eax
 677:	89 44 24 04          	mov    %eax,0x4(%esp)
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 da fd ff ff       	call   460 <putc>
        ap++;
 686:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 68a:	eb 45                	jmp    6d1 <printf+0x195>
      } else if(c == '%'){
 68c:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 690:	75 17                	jne    6a9 <printf+0x16d>
        putc(fd, c);
 692:	8b 45 e8             	mov    -0x18(%ebp),%eax
 695:	0f be c0             	movsbl %al,%eax
 698:	89 44 24 04          	mov    %eax,0x4(%esp)
 69c:	8b 45 08             	mov    0x8(%ebp),%eax
 69f:	89 04 24             	mov    %eax,(%esp)
 6a2:	e8 b9 fd ff ff       	call   460 <putc>
 6a7:	eb 28                	jmp    6d1 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a9:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6b0:	00 
 6b1:	8b 45 08             	mov    0x8(%ebp),%eax
 6b4:	89 04 24             	mov    %eax,(%esp)
 6b7:	e8 a4 fd ff ff       	call   460 <putc>
        putc(fd, c);
 6bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bf:	0f be c0             	movsbl %al,%eax
 6c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c6:	8b 45 08             	mov    0x8(%ebp),%eax
 6c9:	89 04 24             	mov    %eax,(%esp)
 6cc:	e8 8f fd ff ff       	call   460 <putc>
      }
      state = 0;
 6d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d8:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 6dc:	8b 55 0c             	mov    0xc(%ebp),%edx
 6df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6e2:	8d 04 02             	lea    (%edx,%eax,1),%eax
 6e5:	0f b6 00             	movzbl (%eax),%eax
 6e8:	84 c0                	test   %al,%al
 6ea:	0f 85 6e fe ff ff    	jne    55e <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f0:	c9                   	leave  
 6f1:	c3                   	ret    
 6f2:	90                   	nop
 6f3:	90                   	nop

000006f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
 6f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fa:	8b 45 08             	mov    0x8(%ebp),%eax
 6fd:	83 e8 08             	sub    $0x8,%eax
 700:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 703:	a1 80 09 00 00       	mov    0x980,%eax
 708:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70b:	eb 24                	jmp    731 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8b 00                	mov    (%eax),%eax
 712:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 715:	77 12                	ja     729 <free+0x35>
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71d:	77 24                	ja     743 <free+0x4f>
 71f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 727:	77 1a                	ja     743 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 731:	8b 45 f8             	mov    -0x8(%ebp),%eax
 734:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 737:	76 d4                	jbe    70d <free+0x19>
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 741:	76 ca                	jbe    70d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 743:	8b 45 f8             	mov    -0x8(%ebp),%eax
 746:	8b 40 04             	mov    0x4(%eax),%eax
 749:	c1 e0 03             	shl    $0x3,%eax
 74c:	89 c2                	mov    %eax,%edx
 74e:	03 55 f8             	add    -0x8(%ebp),%edx
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 00                	mov    (%eax),%eax
 756:	39 c2                	cmp    %eax,%edx
 758:	75 24                	jne    77e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 75a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75d:	8b 50 04             	mov    0x4(%eax),%edx
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 00                	mov    (%eax),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	01 c2                	add    %eax,%edx
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
 77c:	eb 0a                	jmp    788 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	8b 10                	mov    (%eax),%edx
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	8b 40 04             	mov    0x4(%eax),%eax
 78e:	c1 e0 03             	shl    $0x3,%eax
 791:	03 45 fc             	add    -0x4(%ebp),%eax
 794:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 797:	75 20                	jne    7b9 <free+0xc5>
    p->s.size += bp->s.size;
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 50 04             	mov    0x4(%eax),%edx
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	8b 40 04             	mov    0x4(%eax),%eax
 7a5:	01 c2                	add    %eax,%edx
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b0:	8b 10                	mov    (%eax),%edx
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	89 10                	mov    %edx,(%eax)
 7b7:	eb 08                	jmp    7c1 <free+0xcd>
  } else
    p->s.ptr = bp;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7bf:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	a3 80 09 00 00       	mov    %eax,0x980
}
 7c9:	c9                   	leave  
 7ca:	c3                   	ret    

000007cb <morecore>:

static Header*
morecore(uint nu)
{
 7cb:	55                   	push   %ebp
 7cc:	89 e5                	mov    %esp,%ebp
 7ce:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d8:	77 07                	ja     7e1 <morecore+0x16>
    nu = 4096;
 7da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	c1 e0 03             	shl    $0x3,%eax
 7e7:	89 04 24             	mov    %eax,(%esp)
 7ea:	e8 41 fc ff ff       	call   430 <sbrk>
 7ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 7f2:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 7f6:	75 07                	jne    7ff <morecore+0x34>
    return 0;
 7f8:	b8 00 00 00 00       	mov    $0x0,%eax
 7fd:	eb 22                	jmp    821 <morecore+0x56>
  hp = (Header*)p;
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	8b 55 08             	mov    0x8(%ebp),%edx
 80b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 80e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 811:	83 c0 08             	add    $0x8,%eax
 814:	89 04 24             	mov    %eax,(%esp)
 817:	e8 d8 fe ff ff       	call   6f4 <free>
  return freep;
 81c:	a1 80 09 00 00       	mov    0x980,%eax
}
 821:	c9                   	leave  
 822:	c3                   	ret    

00000823 <malloc>:

void*
malloc(uint nbytes)
{
 823:	55                   	push   %ebp
 824:	89 e5                	mov    %esp,%ebp
 826:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 829:	8b 45 08             	mov    0x8(%ebp),%eax
 82c:	83 c0 07             	add    $0x7,%eax
 82f:	c1 e8 03             	shr    $0x3,%eax
 832:	83 c0 01             	add    $0x1,%eax
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 838:	a1 80 09 00 00       	mov    0x980,%eax
 83d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 840:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 844:	75 23                	jne    869 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 846:	c7 45 f0 78 09 00 00 	movl   $0x978,-0x10(%ebp)
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	a3 80 09 00 00       	mov    %eax,0x980
 855:	a1 80 09 00 00       	mov    0x980,%eax
 85a:	a3 78 09 00 00       	mov    %eax,0x978
    base.s.size = 0;
 85f:	c7 05 7c 09 00 00 00 	movl   $0x0,0x97c
 866:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 871:	8b 45 ec             	mov    -0x14(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 87a:	72 4d                	jb     8c9 <malloc+0xa6>
      if(p->s.size == nunits)
 87c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 885:	75 0c                	jne    893 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 887:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88a:	8b 10                	mov    (%eax),%edx
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	89 10                	mov    %edx,(%eax)
 891:	eb 26                	jmp    8b9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 893:	8b 45 ec             	mov    -0x14(%ebp),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	89 c2                	mov    %eax,%edx
 89b:	2b 55 f4             	sub    -0xc(%ebp),%edx
 89e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	c1 e0 03             	shl    $0x3,%eax
 8ad:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 8b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8b6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bc:	a3 80 09 00 00       	mov    %eax,0x980
      return (void*)(p + 1);
 8c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c4:	83 c0 08             	add    $0x8,%eax
 8c7:	eb 38                	jmp    901 <malloc+0xde>
    }
    if(p == freep)
 8c9:	a1 80 09 00 00       	mov    0x980,%eax
 8ce:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 8d1:	75 1b                	jne    8ee <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d6:	89 04 24             	mov    %eax,(%esp)
 8d9:	e8 ed fe ff ff       	call   7cb <morecore>
 8de:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e5:	75 07                	jne    8ee <malloc+0xcb>
        return 0;
 8e7:	b8 00 00 00 00       	mov    $0x0,%eax
 8ec:	eb 13                	jmp    901 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f7:	8b 00                	mov    (%eax),%eax
 8f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8fc:	e9 70 ff ff ff       	jmp    871 <malloc+0x4e>
}
 901:	c9                   	leave  
 902:	c3                   	ret    
