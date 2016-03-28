
_stage1_sigfpe:     file format elf32-i386


Disassembly of section .text:

00000000 <dummy>:
#include "stat.h"
#include "user.h"
#include "signal.h"

void dummy(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp

}
   3:	5d                   	pop    %ebp
   4:	c3                   	ret    

00000005 <handle_signal>:

void handle_signal(siginfo_t info)
{
   5:	55                   	push   %ebp
   6:	89 e5                	mov    %esp,%ebp
   8:	83 ec 18             	sub    $0x18,%esp
	printf(1, "Caught signal %d...\n", info.signum);
   b:	8b 45 08             	mov    0x8(%ebp),%eax
   e:	89 44 24 08          	mov    %eax,0x8(%esp)
  12:	c7 44 24 04 a0 08 00 	movl   $0x8a0,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  21:	e8 b2 04 00 00       	call   4d8 <printf>
	if (info.signum == SIGFPE)
  26:	8b 45 08             	mov    0x8(%ebp),%eax
  29:	85 c0                	test   %eax,%eax
  2b:	75 16                	jne    43 <handle_signal+0x3e>
		printf(1, "TEST PASSED\n");
  2d:	c7 44 24 04 b5 08 00 	movl   $0x8b5,0x4(%esp)
  34:	00 
  35:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3c:	e8 97 04 00 00       	call   4d8 <printf>
  41:	eb 14                	jmp    57 <handle_signal+0x52>
	else
		printf(1, "TEST FAILED: wrong signal sent.\n");
  43:	c7 44 24 04 c4 08 00 	movl   $0x8c4,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 81 04 00 00       	call   4d8 <printf>
	exit();
  57:	e8 e8 02 00 00       	call   344 <exit>

0000005c <main>:
}

int main(int argc, char *argv[])
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	83 e4 f0             	and    $0xfffffff0,%esp
  62:	83 ec 20             	sub    $0x20,%esp
	int x = 5;
  65:	c7 44 24 18 05 00 00 	movl   $0x5,0x18(%esp)
  6c:	00 
	int y = 0;
  6d:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  74:	00 

	signal(SIGFPE, handle_signal);
  75:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  7c:	00 
  7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  84:	e8 89 02 00 00       	call   312 <signal>

	x = x / y;
  89:	8b 44 24 18          	mov    0x18(%esp),%eax
  8d:	89 c2                	mov    %eax,%edx
  8f:	c1 fa 1f             	sar    $0x1f,%edx
  92:	f7 7c 24 1c          	idivl  0x1c(%esp)
  96:	89 44 24 18          	mov    %eax,0x18(%esp)

	printf(1, "TEST FAILED: no signal sent.\n");
  9a:	c7 44 24 04 e5 08 00 	movl   $0x8e5,0x4(%esp)
  a1:	00 
  a2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a9:	e8 2a 04 00 00       	call   4d8 <printf>
	
	exit();
  ae:	e8 91 02 00 00       	call   344 <exit>
  b3:	90                   	nop

000000b4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	57                   	push   %edi
  b8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  bc:	8b 55 10             	mov    0x10(%ebp),%edx
  bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  c2:	89 cb                	mov    %ecx,%ebx
  c4:	89 df                	mov    %ebx,%edi
  c6:	89 d1                	mov    %edx,%ecx
  c8:	fc                   	cld    
  c9:	f3 aa                	rep stos %al,%es:(%edi)
  cb:	89 ca                	mov    %ecx,%edx
  cd:	89 fb                	mov    %edi,%ebx
  cf:	89 5d 08             	mov    %ebx,0x8(%ebp)
  d2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  d5:	5b                   	pop    %ebx
  d6:	5f                   	pop    %edi
  d7:	5d                   	pop    %ebp
  d8:	c3                   	ret    

000000d9 <strcpy>:
#include "x86.h"
#include "signal.h"

char*
strcpy(char *s, char *t)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 10             	movzbl (%eax),%edx
  eb:	8b 45 08             	mov    0x8(%ebp),%eax
  ee:	88 10                	mov    %dl,(%eax)
  f0:	8b 45 08             	mov    0x8(%ebp),%eax
  f3:	0f b6 00             	movzbl (%eax),%eax
  f6:	84 c0                	test   %al,%al
  f8:	0f 95 c0             	setne  %al
  fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ff:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 103:	84 c0                	test   %al,%al
 105:	75 de                	jne    e5 <strcpy+0xc>
    ;
  return os;
 107:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 10a:	c9                   	leave  
 10b:	c3                   	ret    

0000010c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 10c:	55                   	push   %ebp
 10d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 10f:	eb 08                	jmp    119 <strcmp+0xd>
    p++, q++;
 111:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 115:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 119:	8b 45 08             	mov    0x8(%ebp),%eax
 11c:	0f b6 00             	movzbl (%eax),%eax
 11f:	84 c0                	test   %al,%al
 121:	74 10                	je     133 <strcmp+0x27>
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	0f b6 10             	movzbl (%eax),%edx
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	0f b6 00             	movzbl (%eax),%eax
 12f:	38 c2                	cmp    %al,%dl
 131:	74 de                	je     111 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	0f b6 00             	movzbl (%eax),%eax
 139:	0f b6 d0             	movzbl %al,%edx
 13c:	8b 45 0c             	mov    0xc(%ebp),%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	0f b6 c0             	movzbl %al,%eax
 145:	89 d1                	mov    %edx,%ecx
 147:	29 c1                	sub    %eax,%ecx
 149:	89 c8                	mov    %ecx,%eax
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    

0000014d <strlen>:

uint
strlen(char *s)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 153:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 15a:	eb 04                	jmp    160 <strlen+0x13>
 15c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
 163:	03 45 08             	add    0x8(%ebp),%eax
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	84 c0                	test   %al,%al
 16b:	75 ef                	jne    15c <strlen+0xf>
    ;
  return n;
 16d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 170:	c9                   	leave  
 171:	c3                   	ret    

00000172 <memset>:

void*
memset(void *dst, int c, uint n)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 178:	8b 45 10             	mov    0x10(%ebp),%eax
 17b:	89 44 24 08          	mov    %eax,0x8(%esp)
 17f:	8b 45 0c             	mov    0xc(%ebp),%eax
 182:	89 44 24 04          	mov    %eax,0x4(%esp)
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	89 04 24             	mov    %eax,(%esp)
 18c:	e8 23 ff ff ff       	call   b4 <stosb>
  return dst;
 191:	8b 45 08             	mov    0x8(%ebp),%eax
}
 194:	c9                   	leave  
 195:	c3                   	ret    

00000196 <strchr>:

char*
strchr(const char *s, char c)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 04             	sub    $0x4,%esp
 19c:	8b 45 0c             	mov    0xc(%ebp),%eax
 19f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1a2:	eb 14                	jmp    1b8 <strchr+0x22>
    if(*s == c)
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ad:	75 05                	jne    1b4 <strchr+0x1e>
      return (char*)s;
 1af:	8b 45 08             	mov    0x8(%ebp),%eax
 1b2:	eb 13                	jmp    1c7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	0f b6 00             	movzbl (%eax),%eax
 1be:	84 c0                	test   %al,%al
 1c0:	75 e2                	jne    1a4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <gets>:

char*
gets(char *buf, int max)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 1d6:	eb 44                	jmp    21c <gets+0x53>
    cc = read(0, &c, 1);
 1d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1df:	00 
 1e0:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1ee:	e8 69 01 00 00       	call   35c <read>
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(cc < 1)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	7e 2d                	jle    229 <gets+0x60>
      break;
    buf[i++] = c;
 1fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1ff:	03 45 08             	add    0x8(%ebp),%eax
 202:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 206:	88 10                	mov    %dl,(%eax)
 208:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    if(c == '\n' || c == '\r')
 20c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 210:	3c 0a                	cmp    $0xa,%al
 212:	74 16                	je     22a <gets+0x61>
 214:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 218:	3c 0d                	cmp    $0xd,%al
 21a:	74 0e                	je     22a <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 21f:	83 c0 01             	add    $0x1,%eax
 222:	3b 45 0c             	cmp    0xc(%ebp),%eax
 225:	7c b1                	jl     1d8 <gets+0xf>
 227:	eb 01                	jmp    22a <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 229:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22d:	03 45 08             	add    0x8(%ebp),%eax
 230:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
}
 236:	c9                   	leave  
 237:	c3                   	ret    

00000238 <stat>:

int
stat(char *n, struct stat *st)
{
 238:	55                   	push   %ebp
 239:	89 e5                	mov    %esp,%ebp
 23b:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 245:	00 
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 33 01 00 00       	call   384 <open>
 251:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(fd < 0)
 254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 258:	79 07                	jns    261 <stat+0x29>
    return -1;
 25a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 25f:	eb 23                	jmp    284 <stat+0x4c>
  r = fstat(fd, st);
 261:	8b 45 0c             	mov    0xc(%ebp),%eax
 264:	89 44 24 04          	mov    %eax,0x4(%esp)
 268:	8b 45 f0             	mov    -0x10(%ebp),%eax
 26b:	89 04 24             	mov    %eax,(%esp)
 26e:	e8 29 01 00 00       	call   39c <fstat>
 273:	89 45 f4             	mov    %eax,-0xc(%ebp)
  close(fd);
 276:	8b 45 f0             	mov    -0x10(%ebp),%eax
 279:	89 04 24             	mov    %eax,(%esp)
 27c:	e8 eb 00 00 00       	call   36c <close>
  return r;
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <atoi>:

int
atoi(const char *s)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 28c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 293:	eb 24                	jmp    2b9 <atoi+0x33>
    n = n*10 + *s++ - '0';
 295:	8b 55 fc             	mov    -0x4(%ebp),%edx
 298:	89 d0                	mov    %edx,%eax
 29a:	c1 e0 02             	shl    $0x2,%eax
 29d:	01 d0                	add    %edx,%eax
 29f:	01 c0                	add    %eax,%eax
 2a1:	89 c2                	mov    %eax,%edx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	0f be c0             	movsbl %al,%eax
 2ac:	8d 04 02             	lea    (%edx,%eax,1),%eax
 2af:	83 e8 30             	sub    $0x30,%eax
 2b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 2b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	0f b6 00             	movzbl (%eax),%eax
 2bf:	3c 2f                	cmp    $0x2f,%al
 2c1:	7e 0a                	jle    2cd <atoi+0x47>
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	3c 39                	cmp    $0x39,%al
 2cb:	7e c8                	jle    295 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 2cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  src = vsrc;
 2de:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0)
 2e4:	eb 13                	jmp    2f9 <memmove+0x27>
    *dst++ = *src++;
 2e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2e9:	0f b6 10             	movzbl (%eax),%edx
 2ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ef:	88 10                	mov    %dl,(%eax)
 2f1:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 2f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2fd:	0f 9f c0             	setg   %al
 300:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 304:	84 c0                	test   %al,%al
 306:	75 de                	jne    2e6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 308:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30b:	c9                   	leave  
 30c:	c3                   	ret    

0000030d <trampoline>:
 30d:	5a                   	pop    %edx
 30e:	59                   	pop    %ecx
 30f:	58                   	pop    %eax
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <signal>:
//	"addl 4, %esp\n\t"
	"leave\n\t"
	"ret\n\t"
);
int signal(int signum, sighandler_t handler) 
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 18             	sub    $0x18,%esp
	register_signal_handler(signum, handler, trampoline);
 318:	c7 44 24 08 0d 03 00 	movl   $0x30d,0x8(%esp)
 31f:	00 
 320:	8b 45 0c             	mov    0xc(%ebp),%eax
 323:	89 44 24 04          	mov    %eax,0x4(%esp)
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 04 24             	mov    %eax,(%esp)
 32d:	e8 ba 00 00 00       	call   3ec <register_signal_handler>
	return 0;
 332:	b8 00 00 00 00       	mov    $0x0,%eax
}
 337:	c9                   	leave  
 338:	c3                   	ret    
 339:	90                   	nop
 33a:	90                   	nop
 33b:	90                   	nop

0000033c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 33c:	b8 01 00 00 00       	mov    $0x1,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <exit>:
SYSCALL(exit)
 344:	b8 02 00 00 00       	mov    $0x2,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <wait>:
SYSCALL(wait)
 34c:	b8 03 00 00 00       	mov    $0x3,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <pipe>:
SYSCALL(pipe)
 354:	b8 04 00 00 00       	mov    $0x4,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <read>:
SYSCALL(read)
 35c:	b8 05 00 00 00       	mov    $0x5,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <write>:
SYSCALL(write)
 364:	b8 10 00 00 00       	mov    $0x10,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <close>:
SYSCALL(close)
 36c:	b8 15 00 00 00       	mov    $0x15,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <kill>:
SYSCALL(kill)
 374:	b8 06 00 00 00       	mov    $0x6,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exec>:
SYSCALL(exec)
 37c:	b8 07 00 00 00       	mov    $0x7,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <open>:
SYSCALL(open)
 384:	b8 0f 00 00 00       	mov    $0xf,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <mknod>:
SYSCALL(mknod)
 38c:	b8 11 00 00 00       	mov    $0x11,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <unlink>:
SYSCALL(unlink)
 394:	b8 12 00 00 00       	mov    $0x12,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <fstat>:
SYSCALL(fstat)
 39c:	b8 08 00 00 00       	mov    $0x8,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <link>:
SYSCALL(link)
 3a4:	b8 13 00 00 00       	mov    $0x13,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <mkdir>:
SYSCALL(mkdir)
 3ac:	b8 14 00 00 00       	mov    $0x14,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <chdir>:
SYSCALL(chdir)
 3b4:	b8 09 00 00 00       	mov    $0x9,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <dup>:
SYSCALL(dup)
 3bc:	b8 0a 00 00 00       	mov    $0xa,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <getpid>:
SYSCALL(getpid)
 3c4:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sbrk>:
SYSCALL(sbrk)
 3cc:	b8 0c 00 00 00       	mov    $0xc,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <sleep>:
SYSCALL(sleep)
 3d4:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <uptime>:
SYSCALL(uptime)
 3dc:	b8 0e 00 00 00       	mov    $0xe,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <halt>:
SYSCALL(halt)
 3e4:	b8 16 00 00 00       	mov    $0x16,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <register_signal_handler>:
SYSCALL(register_signal_handler)
 3ec:	b8 17 00 00 00       	mov    $0x17,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <alarm>:
SYSCALL(alarm)
 3f4:	b8 18 00 00 00       	mov    $0x18,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 28             	sub    $0x28,%esp
 402:	8b 45 0c             	mov    0xc(%ebp),%eax
 405:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 408:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 40f:	00 
 410:	8d 45 f4             	lea    -0xc(%ebp),%eax
 413:	89 44 24 04          	mov    %eax,0x4(%esp)
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	89 04 24             	mov    %eax,(%esp)
 41d:	e8 42 ff ff ff       	call   364 <write>
}
 422:	c9                   	leave  
 423:	c3                   	ret    

00000424 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 424:	55                   	push   %ebp
 425:	89 e5                	mov    %esp,%ebp
 427:	53                   	push   %ebx
 428:	83 ec 44             	sub    $0x44,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 42b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 432:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 436:	74 17                	je     44f <printint+0x2b>
 438:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 43c:	79 11                	jns    44f <printint+0x2b>
    neg = 1;
 43e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 445:	8b 45 0c             	mov    0xc(%ebp),%eax
 448:	f7 d8                	neg    %eax
 44a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 44d:	eb 06                	jmp    455 <printint+0x31>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }

  i = 0;
 455:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  do{
    buf[i++] = digits[x % base];
 45c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
 45f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 462:	8b 45 f4             	mov    -0xc(%ebp),%eax
 465:	ba 00 00 00 00       	mov    $0x0,%edx
 46a:	f7 f3                	div    %ebx
 46c:	89 d0                	mov    %edx,%eax
 46e:	0f b6 80 0c 09 00 00 	movzbl 0x90c(%eax),%eax
 475:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
 479:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  }while((x /= base) != 0);
 47d:	8b 45 10             	mov    0x10(%ebp),%eax
 480:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 483:	8b 45 f4             	mov    -0xc(%ebp),%eax
 486:	ba 00 00 00 00       	mov    $0x0,%edx
 48b:	f7 75 d4             	divl   -0x2c(%ebp)
 48e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 495:	75 c5                	jne    45c <printint+0x38>
  if(neg)
 497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49b:	74 2a                	je     4c7 <printint+0xa3>
    buf[i++] = '-';
 49d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
 4a5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

  while(--i >= 0)
 4a9:	eb 1d                	jmp    4c8 <printint+0xa4>
    putc(fd, buf[i]);
 4ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ae:	0f b6 44 05 dc       	movzbl -0x24(%ebp,%eax,1),%eax
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	89 04 24             	mov    %eax,(%esp)
 4c0:	e8 37 ff ff ff       	call   3fc <putc>
 4c5:	eb 01                	jmp    4c8 <printint+0xa4>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c7:	90                   	nop
 4c8:	83 6d ec 01          	subl   $0x1,-0x14(%ebp)
 4cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d0:	79 d9                	jns    4ab <printint+0x87>
    putc(fd, buf[i]);
}
 4d2:	83 c4 44             	add    $0x44,%esp
 4d5:	5b                   	pop    %ebx
 4d6:	5d                   	pop    %ebp
 4d7:	c3                   	ret    

000004d8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e5:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e8:	83 c0 04             	add    $0x4,%eax
 4eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; fmt[i]; i++){
 4ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
 4f5:	e9 7e 01 00 00       	jmp    678 <printf+0x1a0>
    c = fmt[i] & 0xff;
 4fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 500:	8d 04 02             	lea    (%edx,%eax,1),%eax
 503:	0f b6 00             	movzbl (%eax),%eax
 506:	0f be c0             	movsbl %al,%eax
 509:	25 ff 00 00 00       	and    $0xff,%eax
 50e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(state == 0){
 511:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 515:	75 2c                	jne    543 <printf+0x6b>
      if(c == '%'){
 517:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 51b:	75 0c                	jne    529 <printf+0x51>
        state = '%';
 51d:	c7 45 f0 25 00 00 00 	movl   $0x25,-0x10(%ebp)
 524:	e9 4b 01 00 00       	jmp    674 <printf+0x19c>
      } else {
        putc(fd, c);
 529:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52c:	0f be c0             	movsbl %al,%eax
 52f:	89 44 24 04          	mov    %eax,0x4(%esp)
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	89 04 24             	mov    %eax,(%esp)
 539:	e8 be fe ff ff       	call   3fc <putc>
 53e:	e9 31 01 00 00       	jmp    674 <printf+0x19c>
      }
    } else if(state == '%'){
 543:	83 7d f0 25          	cmpl   $0x25,-0x10(%ebp)
 547:	0f 85 27 01 00 00    	jne    674 <printf+0x19c>
      if(c == 'd'){
 54d:	83 7d e8 64          	cmpl   $0x64,-0x18(%ebp)
 551:	75 2d                	jne    580 <printf+0xa8>
        printint(fd, *ap, 10, 1);
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	8b 00                	mov    (%eax),%eax
 558:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 55f:	00 
 560:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 567:	00 
 568:	89 44 24 04          	mov    %eax,0x4(%esp)
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	89 04 24             	mov    %eax,(%esp)
 572:	e8 ad fe ff ff       	call   424 <printint>
        ap++;
 577:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 57b:	e9 ed 00 00 00       	jmp    66d <printf+0x195>
      } else if(c == 'x' || c == 'p'){
 580:	83 7d e8 78          	cmpl   $0x78,-0x18(%ebp)
 584:	74 06                	je     58c <printf+0xb4>
 586:	83 7d e8 70          	cmpl   $0x70,-0x18(%ebp)
 58a:	75 2d                	jne    5b9 <printf+0xe1>
        printint(fd, *ap, 16, 0);
 58c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58f:	8b 00                	mov    (%eax),%eax
 591:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 598:	00 
 599:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5a0:	00 
 5a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	89 04 24             	mov    %eax,(%esp)
 5ab:	e8 74 fe ff ff       	call   424 <printint>
        ap++;
 5b0:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5b4:	e9 b4 00 00 00       	jmp    66d <printf+0x195>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5b9:	83 7d e8 73          	cmpl   $0x73,-0x18(%ebp)
 5bd:	75 46                	jne    605 <printf+0x12d>
        s = (char*)*ap;
 5bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        ap++;
 5c7:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
        if(s == 0)
 5cb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 5cf:	75 27                	jne    5f8 <printf+0x120>
          s = "(null)";
 5d1:	c7 45 e4 03 09 00 00 	movl   $0x903,-0x1c(%ebp)
        while(*s != 0){
 5d8:	eb 1f                	jmp    5f9 <printf+0x121>
          putc(fd, *s);
 5da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5dd:	0f b6 00             	movzbl (%eax),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	89 04 24             	mov    %eax,(%esp)
 5ed:	e8 0a fe ff ff       	call   3fc <putc>
          s++;
 5f2:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 5f6:	eb 01                	jmp    5f9 <printf+0x121>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5f8:	90                   	nop
 5f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5fc:	0f b6 00             	movzbl (%eax),%eax
 5ff:	84 c0                	test   %al,%al
 601:	75 d7                	jne    5da <printf+0x102>
 603:	eb 68                	jmp    66d <printf+0x195>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 605:	83 7d e8 63          	cmpl   $0x63,-0x18(%ebp)
 609:	75 1d                	jne    628 <printf+0x150>
        putc(fd, *ap);
 60b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	89 44 24 04          	mov    %eax,0x4(%esp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	89 04 24             	mov    %eax,(%esp)
 61d:	e8 da fd ff ff       	call   3fc <putc>
        ap++;
 622:	83 45 f4 04          	addl   $0x4,-0xc(%ebp)
 626:	eb 45                	jmp    66d <printf+0x195>
      } else if(c == '%'){
 628:	83 7d e8 25          	cmpl   $0x25,-0x18(%ebp)
 62c:	75 17                	jne    645 <printf+0x16d>
        putc(fd, c);
 62e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 631:	0f be c0             	movsbl %al,%eax
 634:	89 44 24 04          	mov    %eax,0x4(%esp)
 638:	8b 45 08             	mov    0x8(%ebp),%eax
 63b:	89 04 24             	mov    %eax,(%esp)
 63e:	e8 b9 fd ff ff       	call   3fc <putc>
 643:	eb 28                	jmp    66d <printf+0x195>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 645:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 64c:	00 
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 a4 fd ff ff       	call   3fc <putc>
        putc(fd, c);
 658:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	89 44 24 04          	mov    %eax,0x4(%esp)
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	89 04 24             	mov    %eax,(%esp)
 668:	e8 8f fd ff ff       	call   3fc <putc>
      }
      state = 0;
 66d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 674:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
 678:	8b 55 0c             	mov    0xc(%ebp),%edx
 67b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 67e:	8d 04 02             	lea    (%edx,%eax,1),%eax
 681:	0f b6 00             	movzbl (%eax),%eax
 684:	84 c0                	test   %al,%al
 686:	0f 85 6e fe ff ff    	jne    4fa <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 68c:	c9                   	leave  
 68d:	c3                   	ret    
 68e:	90                   	nop
 68f:	90                   	nop

00000690 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	83 e8 08             	sub    $0x8,%eax
 69c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69f:	a1 28 09 00 00       	mov    0x928,%eax
 6a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a7:	eb 24                	jmp    6cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b1:	77 12                	ja     6c5 <free+0x35>
 6b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b9:	77 24                	ja     6df <free+0x4f>
 6bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c3:	77 1a                	ja     6df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c8:	8b 00                	mov    (%eax),%eax
 6ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d3:	76 d4                	jbe    6a9 <free+0x19>
 6d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6dd:	76 ca                	jbe    6a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e2:	8b 40 04             	mov    0x4(%eax),%eax
 6e5:	c1 e0 03             	shl    $0x3,%eax
 6e8:	89 c2                	mov    %eax,%edx
 6ea:	03 55 f8             	add    -0x8(%ebp),%edx
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	39 c2                	cmp    %eax,%edx
 6f4:	75 24                	jne    71a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f9:	8b 50 04             	mov    0x4(%eax),%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	8b 40 04             	mov    0x4(%eax),%eax
 704:	01 c2                	add    %eax,%edx
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	8b 10                	mov    (%eax),%edx
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	89 10                	mov    %edx,(%eax)
 718:	eb 0a                	jmp    724 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 10                	mov    (%eax),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	c1 e0 03             	shl    $0x3,%eax
 72d:	03 45 fc             	add    -0x4(%ebp),%eax
 730:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 733:	75 20                	jne    755 <free+0xc5>
    p->s.size += bp->s.size;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 50 04             	mov    0x4(%eax),%edx
 73b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73e:	8b 40 04             	mov    0x4(%eax),%eax
 741:	01 c2                	add    %eax,%edx
 743:	8b 45 fc             	mov    -0x4(%ebp),%eax
 746:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	8b 10                	mov    (%eax),%edx
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	89 10                	mov    %edx,(%eax)
 753:	eb 08                	jmp    75d <free+0xcd>
  } else
    p->s.ptr = bp;
 755:	8b 45 fc             	mov    -0x4(%ebp),%eax
 758:	8b 55 f8             	mov    -0x8(%ebp),%edx
 75b:	89 10                	mov    %edx,(%eax)
  freep = p;
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	a3 28 09 00 00       	mov    %eax,0x928
}
 765:	c9                   	leave  
 766:	c3                   	ret    

00000767 <morecore>:

static Header*
morecore(uint nu)
{
 767:	55                   	push   %ebp
 768:	89 e5                	mov    %esp,%ebp
 76a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 76d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 774:	77 07                	ja     77d <morecore+0x16>
    nu = 4096;
 776:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 77d:	8b 45 08             	mov    0x8(%ebp),%eax
 780:	c1 e0 03             	shl    $0x3,%eax
 783:	89 04 24             	mov    %eax,(%esp)
 786:	e8 41 fc ff ff       	call   3cc <sbrk>
 78b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(p == (char*)-1)
 78e:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 792:	75 07                	jne    79b <morecore+0x34>
    return 0;
 794:	b8 00 00 00 00       	mov    $0x0,%eax
 799:	eb 22                	jmp    7bd <morecore+0x56>
  hp = (Header*)p;
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  hp->s.size = nu;
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	8b 55 08             	mov    0x8(%ebp),%edx
 7a7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ad:	83 c0 08             	add    $0x8,%eax
 7b0:	89 04 24             	mov    %eax,(%esp)
 7b3:	e8 d8 fe ff ff       	call   690 <free>
  return freep;
 7b8:	a1 28 09 00 00       	mov    0x928,%eax
}
 7bd:	c9                   	leave  
 7be:	c3                   	ret    

000007bf <malloc>:

void*
malloc(uint nbytes)
{
 7bf:	55                   	push   %ebp
 7c0:	89 e5                	mov    %esp,%ebp
 7c2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c5:	8b 45 08             	mov    0x8(%ebp),%eax
 7c8:	83 c0 07             	add    $0x7,%eax
 7cb:	c1 e8 03             	shr    $0x3,%eax
 7ce:	83 c0 01             	add    $0x1,%eax
 7d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((prevp = freep) == 0){
 7d4:	a1 28 09 00 00       	mov    0x928,%eax
 7d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e0:	75 23                	jne    805 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7e2:	c7 45 f0 20 09 00 00 	movl   $0x920,-0x10(%ebp)
 7e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ec:	a3 28 09 00 00       	mov    %eax,0x928
 7f1:	a1 28 09 00 00       	mov    0x928,%eax
 7f6:	a3 20 09 00 00       	mov    %eax,0x920
    base.s.size = 0;
 7fb:	c7 05 24 09 00 00 00 	movl   $0x0,0x924
 802:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 805:	8b 45 f0             	mov    -0x10(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(p->s.size >= nunits){
 80d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 816:	72 4d                	jb     865 <malloc+0xa6>
      if(p->s.size == nunits)
 818:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
 821:	75 0c                	jne    82f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 823:	8b 45 ec             	mov    -0x14(%ebp),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 26                	jmp    855 <malloc+0x96>
      else {
        p->s.size -= nunits;
 82f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	89 c2                	mov    %eax,%edx
 837:	2b 55 f4             	sub    -0xc(%ebp),%edx
 83a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 840:	8b 45 ec             	mov    -0x14(%ebp),%eax
 843:	8b 40 04             	mov    0x4(%eax),%eax
 846:	c1 e0 03             	shl    $0x3,%eax
 849:	01 45 ec             	add    %eax,-0x14(%ebp)
        p->s.size = nunits;
 84c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 84f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 852:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	a3 28 09 00 00       	mov    %eax,0x928
      return (void*)(p + 1);
 85d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 860:	83 c0 08             	add    $0x8,%eax
 863:	eb 38                	jmp    89d <malloc+0xde>
    }
    if(p == freep)
 865:	a1 28 09 00 00       	mov    0x928,%eax
 86a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 86d:	75 1b                	jne    88a <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	89 04 24             	mov    %eax,(%esp)
 875:	e8 ed fe ff ff       	call   767 <morecore>
 87a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 87d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 881:	75 07                	jne    88a <malloc+0xcb>
        return 0;
 883:	b8 00 00 00 00       	mov    $0x0,%eax
 888:	eb 13                	jmp    89d <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 88d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 890:	8b 45 ec             	mov    -0x14(%ebp),%eax
 893:	8b 00                	mov    (%eax),%eax
 895:	89 45 ec             	mov    %eax,-0x14(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 898:	e9 70 ff ff ff       	jmp    80d <malloc+0x4e>
}
 89d:	c9                   	leave  
 89e:	c3                   	ret    
