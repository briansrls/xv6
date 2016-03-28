
_stage2:     file format elf32-i386


Disassembly of section .text:

00000000 <dummy>:
#include "signal.h"

volatile int flag = 0;

void dummy(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    printf(1, "TEST FAILED: this should never execute.\n");
   6:	c7 44 24 04 98 08 00 	movl   $0x898,0x4(%esp)
   d:	00 
   e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  15:	e8 b6 04 00 00       	call   4d0 <printf>
}
  1a:	c9                   	leave  
  1b:	c3                   	ret    

0000001c <handle_signal>:

void handle_signal(siginfo_t info)
{
  1c:	55                   	push   %ebp
  1d:	89 e5                	mov    %esp,%ebp
    __asm__ ("movl $0x0,%ecx\n\t");
  1f:	b9 00 00 00 00       	mov    $0x0,%ecx
    flag = 1;
  24:	c7 05 38 09 00 00 01 	movl   $0x1,0x938
  2b:	00 00 00 
} 
  2e:	5d                   	pop    %ebp
  2f:	c3                   	ret    

00000030 <main>:

int main(void)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	83 e4 f0             	and    $0xfffffff0,%esp
  36:	83 ec 10             	sub    $0x10,%esp
    register int ecx asm ("%ecx");
    
    signal(SIGALRM, handle_signal);
  39:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  40:	00 
  41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  48:	e8 bd 02 00 00       	call   30a <signal>

    ecx = 5;
  4d:	b9 05 00 00 00       	mov    $0x5,%ecx

    alarm(1);
  52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  59:	e8 8e 03 00 00       	call   3ec <alarm>

    while(!flag);
  5e:	a1 38 09 00 00       	mov    0x938,%eax
  63:	85 c0                	test   %eax,%eax
  65:	74 f7                	je     5e <main+0x2e>

    if (ecx == 5)
  67:	89 c8                	mov    %ecx,%eax
  69:	83 f8 05             	cmp    $0x5,%eax
  6c:	75 1c                	jne    8a <main+0x5a>
        printf(1, "TEST PASSED: Final value of ecx is %d...\n", ecx);
  6e:	89 c8                	mov    %ecx,%eax
  70:	89 44 24 08          	mov    %eax,0x8(%esp)
  74:	c7 44 24 04 c4 08 00 	movl   $0x8c4,0x4(%esp)
  7b:	00 
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 48 04 00 00       	call   4d0 <printf>
  88:	eb 1a                	jmp    a4 <main+0x74>
    else
        printf(1, "TEST FAILED: Final value of ecx is %d...\n", ecx);
  8a:	89 c8                	mov    %ecx,%eax
  8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  90:	c7 44 24 04 f0 08 00 	movl   $0x8f0,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 2c 04 00 00       	call   4d0 <printf>

    exit();
  a4:	e8 93 02 00 00       	call   33c <exit>
  a9:	90                   	nop
  aa:	90                   	nop
  ab:	90                   	nop

000000ac <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ac:	55                   	push   %ebp
  ad:	89 e5                	mov    %esp,%ebp
  af:	57                   	push   %edi
  b0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b4:	8b 55 10             	mov    0x10(%ebp),%edx
  b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ba:	89 cb                	mov    %ecx,%ebx
  bc:	89 df                	mov    %ebx,%edi
  be:	89 d1                	mov    %edx,%ecx
  c0:	fc                   	cld    
  c1:	f3 aa                	rep stos %al,%es:(%edi)
  c3:	89 ca                	mov    %ecx,%edx
  c5:	89 fb                	mov    %edi,%ebx
  c7:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ca:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  cd:	5b                   	pop    %ebx
  ce:	5f                   	pop    %edi
  cf:	5d                   	pop    %ebp
  d0:	c3                   	ret    

000000d1 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  d1:	55                   	push   %ebp
  d2:	89 e5                	mov    %esp,%ebp
  d4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  e0:	0f b6 10             	movzbl (%eax),%edx
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	88 10                	mov    %dl,(%eax)
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	84 c0                	test   %al,%al
  f0:	0f 95 c0             	setne  %al
  f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  fb:	84 c0                	test   %al,%al
  fd:	75 de                	jne    dd <strcpy+0xc>
    ;
  return os;
  ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 102:	c9                   	leave  
 103:	c3                   	ret    

00000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 107:	eb 08                	jmp    111 <strcmp+0xd>
    p++, q++;
 109:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 10d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	0f b6 00             	movzbl (%eax),%eax
 117:	84 c0                	test   %al,%al
 119:	74 10                	je     12b <strcmp+0x27>
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	0f b6 10             	movzbl (%eax),%edx
 121:	8b 45 0c             	mov    0xc(%ebp),%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	38 c2                	cmp    %al,%dl
 129:	74 de                	je     109 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	0f b6 d0             	movzbl %al,%edx
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	0f b6 00             	movzbl (%eax),%eax
 13a:	0f b6 c0             	movzbl %al,%eax
 13d:	89 d1                	mov    %edx,%ecx
 13f:	29 c1                	sub    %eax,%ecx
 141:	89 c8                	mov    %ecx,%eax
}
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <strlen>:

uint
strlen(char *s)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 152:	eb 04                	jmp    158 <strlen+0x13>
 154:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 158:	8b 45 fc             	mov    -0x4(%ebp),%eax
 15b:	03 45 08             	add    0x8(%ebp),%eax
 15e:	0f b6 00             	movzbl (%eax),%eax
 161:	84 c0                	test   %al,%al
 163:	75 ef                	jne    154 <strlen+0xf>
    ;
  return n;
 165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 168:	c9                   	leave  
 169:	c3                   	ret    

0000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 170:	8b 45 10             	mov    0x10(%ebp),%eax
 173:	89 44 24 08          	mov    %eax,0x8(%esp)
 177:	8b 45 0c             	mov    0xc(%ebp),%eax
 17a:	89 44 24 04          	mov    %eax,0x4(%esp)
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 04 24             	mov    %eax,(%esp)
 184:	e8 23 ff ff ff       	call   ac <stosb>
  return dst;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <strchr>:

char*
strchr(const char *s, char c)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 04             	sub    $0x4,%esp
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19a:	eb 14                	jmp    1b0 <strchr+0x22>
    if(*s == c)
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a5:	75 05                	jne    1ac <strchr+0x1e>
      return (char*)s;
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	eb 13                	jmp    1bf <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b0:	8b 45 08             	mov    0x8(%ebp),%eax
 1b3:	0f b6 00             	movzbl (%eax),%eax
 1b6:	84 c0                	test   %al,%al
 1b8:	75 e2                	jne    19c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1bf:	c9                   	leave  
 1c0:	c3                   	ret    

000001c1 <gets>:

char*
gets(char *buf, int max)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1ce:	eb 44                	jmp    214 <gets+0x53>
    cc = read(0, &c, 1);
 1d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1d7:	00 
 1d8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1db:	89 44 24 04          	mov    %eax,0x4(%esp)
 1df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1e6:	e8 69 01 00 00       	call   354 <read>
 1eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f2:	7e 2d                	jle    221 <gets+0x60>
      break;
    buf[i++] = c;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f7:	03 45 08             	add    0x8(%ebp),%eax
 1fa:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1fe:	88 10                	mov    %dl,(%eax)
 200:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 204:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 208:	3c 0a                	cmp    $0xa,%al
 20a:	74 16                	je     222 <gets+0x61>
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	3c 0d                	cmp    $0xd,%al
 212:	74 0e                	je     222 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 214:	8b 45 f0             	mov    -0x10(%ebp),%eax
 217:	83 c0 01             	add    $0x1,%eax
 21a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 21d:	7c b1                	jl     1d0 <gets+0xf>
 21f:	eb 01                	jmp    222 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 221:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 222:	8b 45 f0             	mov    -0x10(%ebp),%eax
 225:	03 45 08             	add    0x8(%ebp),%eax
 228:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 22e:	c9                   	leave  
 22f:	c3                   	ret    

00000230 <stat>:

int
stat(char *n, struct stat *st)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 236:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23d:	00 
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	89 04 24             	mov    %eax,(%esp)
 244:	e8 33 01 00 00       	call   37c <open>
 249:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 24c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 250:	79 07                	jns    259 <stat+0x29>
    return -1;
 252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 257:	eb 23                	jmp    27c <stat+0x4c>
  r = fstat(fd, st);
 259:	8b 45 0c             	mov    0xc(%ebp),%eax
 25c:	89 44 24 04          	mov    %eax,0x4(%esp)
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 29 01 00 00       	call   394 <fstat>
 26b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 26e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 271:	89 04 24             	mov    %eax,(%esp)
 274:	e8 eb 00 00 00       	call   364 <close>
  return r;
 279:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <atoi>:

int
atoi(const char *s)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 284:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 28b:	eb 24                	jmp    2b1 <atoi+0x33>
    n = n*10 + *s++ - '0';
 28d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 290:	89 d0                	mov    %edx,%eax
 292:	c1 e0 02             	shl    $0x2,%eax
 295:	01 d0                	add    %edx,%eax
 297:	01 c0                	add    %eax,%eax
 299:	89 c2                	mov    %eax,%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	0f be c0             	movsbl %al,%eax
 2a4:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2a7:	83 e8 30             	sub    $0x30,%eax
 2aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3c 2f                	cmp    $0x2f,%al
 2b9:	7e 0a                	jle    2c5 <atoi+0x47>
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 39                	cmp    $0x39,%al
 2c3:	7e c8                	jle    28d <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2dc:	eb 13                	jmp    2f1 <memmove+0x27>
    *dst++ = *src++;
 2de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e1:	0f b6 10             	movzbl (%eax),%edx
 2e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e7:	88 10                	mov    %dl,(%eax)
 2e9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2ed:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2f5:	0f 9f c0             	setg   %al
 2f8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2fc:	84 c0                	test   %al,%al
 2fe:	75 de                	jne    2de <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 300:	8b 45 08             	mov    0x8(%ebp),%eax
}
 303:	c9                   	leave  
 304:	c3                   	ret    

00000305 <trampoline>:
 305:	5a                   	pop    %edx
 306:	59                   	pop    %ecx
 307:	58                   	pop    %eax
 308:	c9                   	leave  
 309:	c3                   	ret    

0000030a <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 310:	c7 44 24 08 05 03 00 	movl   $0x305,0x8(%esp)
 317:	00 
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	89 44 24 04          	mov    %eax,0x4(%esp)
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	89 04 24             	mov    %eax,(%esp)
 325:	e8 ba 00 00 00       	call   3e4 <register_signal_handler>
	return 0;
 32a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 32f:	c9                   	leave  
 330:	c3                   	ret    
 331:	90                   	nop
 332:	90                   	nop
 333:	90                   	nop

00000334 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 334:	b8 01 00 00 00       	mov    $0x1,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <exit>:
SYSCALL(exit)
 33c:	b8 02 00 00 00       	mov    $0x2,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <wait>:
SYSCALL(wait)
 344:	b8 03 00 00 00       	mov    $0x3,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <pipe>:
SYSCALL(pipe)
 34c:	b8 04 00 00 00       	mov    $0x4,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <read>:
SYSCALL(read)
 354:	b8 05 00 00 00       	mov    $0x5,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <write>:
SYSCALL(write)
 35c:	b8 10 00 00 00       	mov    $0x10,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <close>:
SYSCALL(close)
 364:	b8 15 00 00 00       	mov    $0x15,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <kill>:
SYSCALL(kill)
 36c:	b8 06 00 00 00       	mov    $0x6,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <exec>:
SYSCALL(exec)
 374:	b8 07 00 00 00       	mov    $0x7,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <open>:
SYSCALL(open)
 37c:	b8 0f 00 00 00       	mov    $0xf,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <mknod>:
SYSCALL(mknod)
 384:	b8 11 00 00 00       	mov    $0x11,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <unlink>:
SYSCALL(unlink)
 38c:	b8 12 00 00 00       	mov    $0x12,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <fstat>:
SYSCALL(fstat)
 394:	b8 08 00 00 00       	mov    $0x8,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <link>:
SYSCALL(link)
 39c:	b8 13 00 00 00       	mov    $0x13,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <mkdir>:
SYSCALL(mkdir)
 3a4:	b8 14 00 00 00       	mov    $0x14,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <chdir>:
SYSCALL(chdir)
 3ac:	b8 09 00 00 00       	mov    $0x9,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <dup>:
SYSCALL(dup)
 3b4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <getpid>:
SYSCALL(getpid)
 3bc:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <sbrk>:
SYSCALL(sbrk)
 3c4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sleep>:
SYSCALL(sleep)
 3cc:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <uptime>:
SYSCALL(uptime)
 3d4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <halt>:
SYSCALL(halt)
 3dc:	b8 16 00 00 00       	mov    $0x16,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <register_signal_handler>:
SYSCALL(register_signal_handler)
 3e4:	b8 17 00 00 00       	mov    $0x17,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <alarm>:
SYSCALL(alarm)
 3ec:	b8 18 00 00 00       	mov    $0x18,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	83 ec 28             	sub    $0x28,%esp
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 400:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 407:	00 
 408:	8d 45 f4             	lea    -0xc(%ebp),%eax
 40b:	89 44 24 04          	mov    %eax,0x4(%esp)
 40f:	8b 45 08             	mov    0x8(%ebp),%eax
 412:	89 04 24             	mov    %eax,(%esp)
 415:	e8 42 ff ff ff       	call   35c <write>
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	53                   	push   %ebx
 420:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 42e:	74 17                	je     447 <printint+0x2b>
 430:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 434:	79 11                	jns    447 <printint+0x2b>
    neg = 1;
 436:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	f7 d8                	neg    %eax
 442:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 445:	eb 06                	jmp    44d <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 447:	8b 45 0c             	mov    0xc(%ebp),%eax
 44a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 44d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 454:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 457:	8b 5d 10             	mov    0x10(%ebp),%ebx
 45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45d:	ba 00 00 00 00       	mov    $0x0,%edx
 462:	f7 f3                	div    %ebx
 464:	89 d0                	mov    %edx,%eax
 466:	0f b6 80 24 09 00 00 	movzbl 0x924(%eax),%eax
 46d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 471:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 475:	8b 45 10             	mov    0x10(%ebp),%eax
 478:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47e:	ba 00 00 00 00       	mov    $0x0,%edx
 483:	f7 75 d4             	divl   -0x2c(%ebp)
 486:	89 45 f4             	mov    %eax,-0xc(%ebp)
 489:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 48d:	75 c5                	jne    454 <printint+0x38>
  if(neg)
 48f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 493:	74 2a                	je     4bf <printint+0xa3>
    buf[i++] = '-';
 495:	8b 45 ec             	mov    -0x14(%ebp),%eax
 498:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 49d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4a1:	eb 1d                	jmp    4c0 <printint+0xa4>
    putc(fd, buf[i]);
 4a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a6:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4ab:	0f be c0             	movsbl %al,%eax
 4ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	89 04 24             	mov    %eax,(%esp)
 4b8:	e8 37 ff ff ff       	call   3f4 <putc>
 4bd:	eb 01                	jmp    4c0 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4bf:	90                   	nop
 4c0:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c8:	79 d9                	jns    4a3 <printint+0x87>
    putc(fd, buf[i]);
}
 4ca:	83 c4 44             	add    $0x44,%esp
 4cd:	5b                   	pop    %ebx
 4ce:	5d                   	pop    %ebp
 4cf:	c3                   	ret    

000004d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d0:	55                   	push   %ebp
 4d1:	89 e5                	mov    %esp,%ebp
 4d3:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4dd:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e0:	83 c0 04             	add    $0x4,%eax
 4e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 4e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4ed:	e9 7e 01 00 00       	jmp    670 <printf+0x1a0>
    c = fmt[i] & 0xff;
 4f2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f8:	8d 04 02             	lea    (%edx,%eax,1),%eax
 4fb:	0f b6 00             	movzbl (%eax),%eax
 4fe:	0f be c0             	movsbl %al,%eax
 501:	25 ff 00 00 00       	and    $0xff,%eax
 506:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 509:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 50d:	75 2c                	jne    53b <printf+0x6b>
      if(c == '%'){
 50f:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 513:	75 0c                	jne    521 <printf+0x51>
        state = '%';
 515:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 51c:	e9 4b 01 00 00       	jmp    66c <printf+0x19c>
      } else {
        putc(fd, c);
 521:	8b 45 e8             	mov    -0x18(%ebp),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	89 44 24 04          	mov    %eax,0x4(%esp)
 52b:	8b 45 08             	mov    0x8(%ebp),%eax
 52e:	89 04 24             	mov    %eax,(%esp)
 531:	e8 be fe ff ff       	call   3f4 <putc>
 536:	e9 31 01 00 00       	jmp    66c <printf+0x19c>
      }
    } else if(state == '%'){
 53b:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 53f:	0f 85 27 01 00 00    	jne    66c <printf+0x19c>
      if(c == 'd'){
 545:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 549:	75 2d                	jne    578 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 54b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54e:	8b 00                	mov    (%eax),%eax
 550:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 557:	00 
 558:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 55f:	00 
 560:	89 44 24 04          	mov    %eax,0x4(%esp)
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 04 24             	mov    %eax,(%esp)
 56a:	e8 ad fe ff ff       	call   41c <printint>
        ap++;
 56f:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 573:	e9 ed 00 00 00       	jmp    665 <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 578:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 57c:	74 06                	je     584 <printf+0xb4>
 57e:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 582:	75 2d                	jne    5b1 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 584:	8b 45 f4             	mov    -0xc(%ebp),%eax
 587:	8b 00                	mov    (%eax),%eax
 589:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 590:	00 
 591:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 598:	00 
 599:	89 44 24 04          	mov    %eax,0x4(%esp)
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	89 04 24             	mov    %eax,(%esp)
 5a3:	e8 74 fe ff ff       	call   41c <printint>
        ap++;
 5a8:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5ac:	e9 b4 00 00 00       	jmp    665 <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5b1:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5b5:	75 46                	jne    5fd <printf+0x12d>
        s = (char*)*ap;
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	8b 00                	mov    (%eax),%eax
 5bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5bf:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5c7:	75 27                	jne    5f0 <printf+0x120>
          s = "(null)";
 5c9:	c7 45 e4 1a 09 00 00 	movl   $0x91a,-0x1c(%ebp)
        while(*s != 0){
 5d0:	eb 1f                	jmp    5f1 <printf+0x121>
          putc(fd, *s);
 5d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d5:	0f b6 00             	movzbl (%eax),%eax
 5d8:	0f be c0             	movsbl %al,%eax
 5db:	89 44 24 04          	mov    %eax,0x4(%esp)
 5df:	8b 45 08             	mov    0x8(%ebp),%eax
 5e2:	89 04 24             	mov    %eax,(%esp)
 5e5:	e8 0a fe ff ff       	call   3f4 <putc>
          s++;
 5ea:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 5ee:	eb 01                	jmp    5f1 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f0:	90                   	nop
 5f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f4:	0f b6 00             	movzbl (%eax),%eax
 5f7:	84 c0                	test   %al,%al
 5f9:	75 d7                	jne    5d2 <printf+0x102>
 5fb:	eb 68                	jmp    665 <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fd:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 601:	75 1d                	jne    620 <printf+0x150>
        putc(fd, *ap);
 603:	8b 45 f4             	mov    -0xc(%ebp),%eax
 606:	8b 00                	mov    (%eax),%eax
 608:	0f be c0             	movsbl %al,%eax
 60b:	89 44 24 04          	mov    %eax,0x4(%esp)
 60f:	8b 45 08             	mov    0x8(%ebp),%eax
 612:	89 04 24             	mov    %eax,(%esp)
 615:	e8 da fd ff ff       	call   3f4 <putc>
        ap++;
 61a:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 61e:	eb 45                	jmp    665 <printf+0x195>
      } else if(c == '%'){
 620:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 624:	75 17                	jne    63d <printf+0x16d>
        putc(fd, c);
 626:	8b 45 e8             	mov    -0x18(%ebp),%eax
 629:	0f be c0             	movsbl %al,%eax
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	89 04 24             	mov    %eax,(%esp)
 636:	e8 b9 fd ff ff       	call   3f4 <putc>
 63b:	eb 28                	jmp    665 <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 63d:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 644:	00 
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	89 04 24             	mov    %eax,(%esp)
 64b:	e8 a4 fd ff ff       	call   3f4 <putc>
        putc(fd, c);
 650:	8b 45 e8             	mov    -0x18(%ebp),%eax
 653:	0f be c0             	movsbl %al,%eax
 656:	89 44 24 04          	mov    %eax,0x4(%esp)
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	89 04 24             	mov    %eax,(%esp)
 660:	e8 8f fd ff ff       	call   3f4 <putc>
      }
      state = 0;
 665:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 66c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 670:	8b 55 0c             	mov    0xc(%ebp),%edx
 673:	8b 45 ec             	mov    -0x14(%ebp),%eax
 676:	8d 04 02             	lea    (%edx,%eax,1),%eax
 679:	0f b6 00             	movzbl (%eax),%eax
 67c:	84 c0                	test   %al,%al
 67e:	0f 85 6e fe ff ff    	jne    4f2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 684:	c9                   	leave  
 685:	c3                   	ret    
 686:	90                   	nop
 687:	90                   	nop

00000688 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	83 e8 08             	sub    $0x8,%eax
 694:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 697:	a1 44 09 00 00       	mov    0x944,%eax
 69c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 69f:	eb 24                	jmp    6c5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8b 00                	mov    (%eax),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	77 12                	ja     6bd <free+0x35>
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 24                	ja     6d7 <free+0x4f>
 6b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6bb:	77 1a                	ja     6d7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cb:	76 d4                	jbe    6a1 <free+0x19>
 6cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d0:	8b 00                	mov    (%eax),%eax
 6d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6d5:	76 ca                	jbe    6a1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6da:	8b 40 04             	mov    0x4(%eax),%eax
 6dd:	c1 e0 03             	shl    $0x3,%eax
 6e0:	89 c2                	mov    %eax,%edx
 6e2:	03 55 f8             	add    -0x8(%ebp),%edx
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	39 c2                	cmp    %eax,%edx
 6ec:	75 24                	jne    712 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	8b 50 04             	mov    0x4(%eax),%edx
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 00                	mov    (%eax),%eax
 6f9:	8b 40 04             	mov    0x4(%eax),%eax
 6fc:	01 c2                	add    %eax,%edx
 6fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 701:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	8b 10                	mov    (%eax),%edx
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	89 10                	mov    %edx,(%eax)
 710:	eb 0a                	jmp    71c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 10                	mov    (%eax),%edx
 717:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 40 04             	mov    0x4(%eax),%eax
 722:	c1 e0 03             	shl    $0x3,%eax
 725:	03 45 fc             	add    -0x4(%ebp),%eax
 728:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 72b:	75 20                	jne    74d <free+0xc5>
    p->s.size += bp->s.size;
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 50 04             	mov    0x4(%eax),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	01 c2                	add    %eax,%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	8b 10                	mov    (%eax),%edx
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	89 10                	mov    %edx,(%eax)
 74b:	eb 08                	jmp    755 <free+0xcd>
  } else
    p->s.ptr = bp;
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 55 f8             	mov    -0x8(%ebp),%edx
 753:	89 10                	mov    %edx,(%eax)
  freep = p;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	a3 44 09 00 00       	mov    %eax,0x944
}
 75d:	c9                   	leave  
 75e:	c3                   	ret    

0000075f <morecore>:

static Header*
morecore(uint nu)
{
 75f:	55                   	push   %ebp
 760:	89 e5                	mov    %esp,%ebp
 762:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 765:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 76c:	77 07                	ja     775 <morecore+0x16>
    nu = 4096;
 76e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 775:	8b 45 08             	mov    0x8(%ebp),%eax
 778:	c1 e0 03             	shl    $0x3,%eax
 77b:	89 04 24             	mov    %eax,(%esp)
 77e:	e8 41 fc ff ff       	call   3c4 <sbrk>
 783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 786:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 78a:	75 07                	jne    793 <morecore+0x34>
    return 0;
 78c:	b8 00 00 00 00       	mov    $0x0,%eax
 791:	eb 22                	jmp    7b5 <morecore+0x56>
  hp = (Header*)p;
 793:	8b 45 f0             	mov    -0x10(%ebp),%eax
 796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 799:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79c:	8b 55 08             	mov    0x8(%ebp),%edx
 79f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a5:	83 c0 08             	add    $0x8,%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 d8 fe ff ff       	call   688 <free>
  return freep;
 7b0:	a1 44 09 00 00       	mov    0x944,%eax
}
 7b5:	c9                   	leave  
 7b6:	c3                   	ret    

000007b7 <malloc>:

void*
malloc(uint nbytes)
{
 7b7:	55                   	push   %ebp
 7b8:	89 e5                	mov    %esp,%ebp
 7ba:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7bd:	8b 45 08             	mov    0x8(%ebp),%eax
 7c0:	83 c0 07             	add    $0x7,%eax
 7c3:	c1 e8 03             	shr    $0x3,%eax
 7c6:	83 c0 01             	add    $0x1,%eax
 7c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7cc:	a1 44 09 00 00       	mov    0x944,%eax
 7d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d8:	75 23                	jne    7fd <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7da:	c7 45 f0 3c 09 00 00 	movl   $0x93c,-0x10(%ebp)
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	a3 44 09 00 00       	mov    %eax,0x944
 7e9:	a1 44 09 00 00       	mov    0x944,%eax
 7ee:	a3 3c 09 00 00       	mov    %eax,0x93c
    base.s.size = 0;
 7f3:	c7 05 40 09 00 00 00 	movl   $0x0,0x940
 7fa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 805:	8b 45 ec             	mov    -0x14(%ebp),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 80e:	72 4d                	jb     85d <malloc+0xa6>
      if(p->s.size == nunits)
 810:	8b 45 ec             	mov    -0x14(%ebp),%eax
 813:	8b 40 04             	mov    0x4(%eax),%eax
 816:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 819:	75 0c                	jne    827 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 81b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81e:	8b 10                	mov    (%eax),%edx
 820:	8b 45 f0             	mov    -0x10(%ebp),%eax
 823:	89 10                	mov    %edx,(%eax)
 825:	eb 26                	jmp    84d <malloc+0x96>
      else {
        p->s.size -= nunits;
 827:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	89 c2                	mov    %eax,%edx
 82f:	2b 55 f4             	sub    -0xc(%ebp),%edx
 832:	8b 45 ec             	mov    -0x14(%ebp),%eax
 835:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 838:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	c1 e0 03             	shl    $0x3,%eax
 841:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 844:	8b 45 ec             	mov    -0x14(%ebp),%eax
 847:	8b 55 f4             	mov    -0xc(%ebp),%edx
 84a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	a3 44 09 00 00       	mov    %eax,0x944
      return (void*)(p + 1);
 855:	8b 45 ec             	mov    -0x14(%ebp),%eax
 858:	83 c0 08             	add    $0x8,%eax
 85b:	eb 38                	jmp    895 <malloc+0xde>
    }
    if(p == freep)
 85d:	a1 44 09 00 00       	mov    0x944,%eax
 862:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 865:	75 1b                	jne    882 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	89 04 24             	mov    %eax,(%esp)
 86d:	e8 ed fe ff ff       	call   75f <morecore>
 872:	89 45 ec             	mov    %eax,-0x14(%ebp)
 875:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 879:	75 07                	jne    882 <malloc+0xcb>
        return 0;
 87b:	b8 00 00 00 00       	mov    $0x0,%eax
 880:	eb 13                	jmp    895 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 882:	8b 45 ec             	mov    -0x14(%ebp),%eax
 885:	89 45 f0             	mov    %eax,-0x10(%ebp)
 888:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 890:	e9 70 ff ff ff       	jmp    805 <malloc+0x4e>
}
 895:	c9                   	leave  
 896:	c3                   	ret    
